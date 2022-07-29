/**
 * Created by yyusupov on 13.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import selectRelatedQuestionnaires from '@salesforce/apex/US108ChildShowQuestionnaireCtlr.selectRelatedQuestionnaires';

const columns = [
    {label: 'Questionnaire Number', fieldName:'Name'},
    {label: 'Attendance', fieldName:'Attendance__c'},
    {label: 'Age', fieldName:'Age__c'},
    {label: 'Score', fieldName:'Score__c'},
    {label: 'Feedback', fieldName:'Feedback__c'},
    {label: 'Webinar', fieldName:'Related_Webinar__c'},
];

export default class Us108ChildShowQuestionnaires extends LightningElement {
    @api userId;
    columns = columns;

    @wire(selectRelatedQuestionnaires, {userId: '$userId'})
    questionnaires;

    handleClose(event){
        const closeEvent = new CustomEvent("closebuttonclicked");
        this.dispatchEvent(closeEvent);
    }
}