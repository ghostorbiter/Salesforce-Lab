/**
 * Created by yyusupov on 13.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions'
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Webinar from '@salesforce/schema/Webinar__c';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import cloneWebinar from '@salesforce/apex/US109WebinarCreateButtonCtrlr.cloneWebinar';

import WEBINAR_NAME from '@salesforce/schema/Webinar__c.Name';
import WEBINAR_TYPE from '@salesforce/schema/Webinar__c.Type__c';
import WEBINAR_COST from '@salesforce/schema/Webinar__c.Cost__c';
import WEBINAR_PRICE from '@salesforce/schema/Webinar__c.Price__c';

const fields = [
    WEBINAR_NAME,
    WEBINAR_TYPE,
    WEBINAR_COST,
    WEBINAR_PRICE
];

export default class Us109WebinarCreateButton extends NavigationMixin(LightningElement) {
    @api recordId;
    fields = Webinar;
    webinarId;
    webinarFields = {};

    closeAction(){
      this.dispatchEvent(new CloseActionScreenEvent());
    }

    saveAction(event){
        event.preventDefault();

        this.template.querySelectorAll('lightning-input-field').forEach(element=> {
            this.webinarFields[element.fieldName] = element.value;
        })

        this.createWebinar();
    }

    createWebinar(){
        cloneWebinar({name: this.webinarFields['Name'], type: this.webinarFields['Type__c'], cost: this.webinarFields['Cost__c'], price: this.webinarFields['Price__c']})
        .then(response => {
            this.webinarId = response;

            this.showSuccessMessage();
            this.navigateToNewWebinar();

        }).catch(error => {
            console.log(JSON.stringify(error))
            alert('Error');
        });
    }

    navigateToNewWebinar(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId: this.webinarId,
                actionName: 'view',
            },
        });
    }

    showSuccessMessage(){
        const evt = new ShowToastEvent({
            title: 'Thank you!',
            message: 'The webinar was successfully created!',
            variant: 'success'
        });

        this.dispatchEvent(evt);
    }

    @wire(getRecord, { recordId: '$recordId', fields: fields })
    webinar;
}