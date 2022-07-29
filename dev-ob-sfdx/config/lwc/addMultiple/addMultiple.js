/**
 * Created by yyusupov on 20.07.2022.
 */

import { LightningElement, api } from 'lwc';
import Id from '@salesforce/schema/WebStore/Id';
import addToCart from '@salesforce/apex/addMultipleCntrlr.addToCart';

export default class AddMultiple extends LightningElement {
    @api recordId;
    @api quantity = 250;
    webStoreId = Id;

    add250(event){
        addToCart({productId: this.recordId, webStoreId: this.webStoreId, quantity: this.quantity.toString()})
        .then(response =>{
            console.log('Success');
        }).catch(error =>{
            console.log(JSON.stringify(error));
            alert('Error');
        });
    }
}