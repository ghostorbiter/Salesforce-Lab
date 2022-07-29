/**
 * Created by yyusupov on 22.07.2022.
 */

import { LightningElement, api, track, wire } from 'lwc';
import getWholesalers from '@salesforce/apex/mapMarkersController.getWholesalers';
import getWholesalersByProductId from '@salesforce/apex/mapMarkersController.getWholesalersByProductId';

export default class WholesalersMap extends LightningElement {
    @api recordId;
    @track mapMarkers = [];

    @wire(getWholesalersByProductId, {productId: '$recordId'})
    result({data, error}){
        if (data){
            data.forEach((dataItem) => {
                this.mapMarkers = [...this.mapMarkers, {
                    location:{
                        Country: dataItem.Order.Account.BillingCountry,
                        City: dataItem.Order.Account.BillingCity,
                        Street: dataItem.Order.Account.BillingStreet,
                        PostalCode: dataItem.Order.Account.BillingPostalCode,
                        State: dataItem.Order.Account.BillingState,
                    },
                    icon: 'custom:custom26',
                    title: dataItem.Order.Account.Name,
                }];
            });
        }else if (error){
            console.error(JSON.stringify(error));
        }
    }
}