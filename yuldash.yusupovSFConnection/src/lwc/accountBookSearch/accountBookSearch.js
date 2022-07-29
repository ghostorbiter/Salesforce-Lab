/**
 * Created by yyusupov on 22.07.2022.
 */

import { LightningElement, api, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getSearchBooks from '@salesforce/apex/accountBookSearchControler.getSearchedBooks';

const COLUMNS = [
        {label: 'Order Name', fieldName:'urlName', type:'url', typeAttributes: {
            label: { fieldName: 'strName' },
            target: '_blank'
        }},
        {label: 'Order Start Date', fieldName:'startDate', type: 'Date', sortable: "true"},
        {label: 'Order Status', fieldName:'Status'},
        {label: 'Quantity', fieldName:'Quantity'},
]

export default class AccountBookSearch extends LightningElement {

    @api recordId;
    @track orders = [];
    @track sortDirection;
    orderColumns = COLUMNS;
    clickSearch = false;
    searchValue = '';

    searchKeyword(event) {
        this.searchValue = event.target.value;
    }

    handleSearchKeyword(){
        this.clickSearch = true;
        getSearchBooks({searchStr: this.searchValue, accountId: this.recordId})
        .then(result =>{
            let urlName;
            this.orders = result.map(row => {
                urlName = `/lightning/r/Product2/${row.orderId}/view`;
                return {...row, urlName};
            });
        }).catch(error =>{
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
            });
            this.dispatchEvent(event);
            this.orders = null;
        })
    }

    handleSort(event){
        this.sortDirection = event.detail.sortDirection;
        this.sortOrderData(event.detail.sortDirection);
    }

    sortOrderData(direction){
        let parseData = JSON.parse(JSON.stringify(this.orders));
        let keyVal = (a) =>{
            return a["startDate"];
        };

        let isReverse = direction === 'asc' ? 1 : -1;

        parseData.sort((x,y) => {
            x = keyVal(x) ? keyVal(x) : '';
            y = keyVal(y) ? keyVal(y) : '';

            return isReverse * ((x > y) - (y > x));
        });

        this.orders = parseData;
    }
}