 /**
 * Created by yyusupov on 12.07.2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import USER_ID from '@salesforce/user/Id';
import USER_NAME from '@salesforce/schema/User.Name';
import WEBINAR_STATUS from '@salesforce/schema/Webinar__c.Status__c';
import WEBINAR_ID from '@salesforce/schema/Webinar__c.Id';
import QUESTIONNAIRE from '@salesforce/schema/Questionnaire__c';

export default class Us108WebinarQuestionnaire extends NavigationMixin(LightningElement) {

    @track questionnaire = {};
    @api recordId;
    @api title;
    @api wouldRecommendNo;
    @api userId = USER_ID;
    @api showUserQuestionnaires = false;
    @api successMessage;
    error;
    questionnaireId;
    isLoading = false;

    @wire(getRecord, { recordId: '$recordId', fields: [WEBINAR_STATUS] })
    webinar;

    get isCompleted(){
         return getFieldValue(this.webinar.data, WEBINAR_STATUS) == 'Completed';
    }

    @wire(getRecord, {recordId : USER_ID, fields : [USER_NAME]})
    userData({error, data}) {
        if (error){
            this.error = error;
        } else if (data) {
            this.title = 'Hi ' + data.fields.Name.value + '! Share your feedback with us!';
        }
    }

    handleChange(e){
        this.questionnaire[e.currentTarget.fieldName] = e.target.value;
    }

    handleRecommendChange(event){
        if (event.detail.value == 'No'){
            this.wouldRecommendNo = true;
        }else {
            this.wouldRecommendNo = false;
        }
        this.questionnaire[event.currentTarget.fieldName] = event.target.value;
    }

    handleSaveRecord(event){
        event.preventDefault();

        this.isLoading = true;
        this.createQuestionnaire();
    }

    handleSuccess(){

//        this.questionnaireId = event.detail.id;

         const evt = new ShowToastEvent({
            title: 'Thank you!',
            message: this.successMessage + 'Created questionnaire with id: '+this.questionnaireId,
            variant: 'success'
        });

        this.dispatchEvent(evt);
        this.isLoading = false;
        this.resetAll();

//        console.log('before mix ',this.questionnaireId);
//
//        setTimeout(() => {
//            console.log('inside timeout')
//
//        this[NavigationMixin.GenerateUrl]({
//                    type: 'standard__webPage',
//                                attributes: {
//                                    url: 'http://salesforce.com'
//                                }
//                }).then((url) => {
//                    console.log('inside then')
//                    const event = new ShowToastEvent({
//                        title: 'Success!',
//                        message: 'Record {0} created! See it {1}!',
//                        messageData: [
//                            'Salesforce',
//                            {
//                                url,
//                                label: 'here',
//                            },
//                        ],
//                    });
//                    this.dispatchEvent(event);
//                }).catch((err) => {
//                              console.log(err);
//                              console.log(JSON.stringify(err));
//                          }).finally(() => {
//                              console.log('in finally')
//                          });
//            }, 500);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId: this.questionnaireId,
                actionName: 'view',
            },
        });

    }

    createQuestionnaire(){
        this.questionnaire['Related_Webinar__c'] = this.recordId;
        let questionnaireFields = this.questionnaire;
        console.log(JSON.stringify(questionnaireFields))
        const objRecordInput = {apiName : 'Questionnaire__c', fields: questionnaireFields};
        createRecord(objRecordInput).then(response => {
            this.questionnaireId = response.id;
            this.handleSuccess();
        }).catch(error => {
            alert('Error: ' + JSON.stringify(error));
        });
    }

    handleShowClick(event){
        this.showUserQuestionnaires = true;
    }

    handleClose(event){
        this.showUserQuestionnaires = false;
    }

    resetAll(){
        this.template.querySelectorAll('lightning-input-field').forEach(element=>{
            if (element.type === 'checkbox'){
                element.checked = false;
            } else{
                element.value = null;
            }
        })
    }

}