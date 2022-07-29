/**
 * Created by yyusupov on 21.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import getTeamById from '@salesforce/apex/GetTeamData.getTeamById'

const COLUMNS = [
    {label: 'First Name', fieldName:'First_Name__c'},
    {label: 'Last Name', fieldName:'Last_Name__c'},
    {label: 'Total Points', fieldName:'Total_Points__c'},
]

export default class ShowSpecificTeam extends LightningElement {
    @api teamId;
    columns = COLUMNS;
    teamData;

    @wire(getTeamById, {id: '$teamId'})
    data({data, error}){
        if (data){
            this.teamData = data;
            console.log(JSON.stringify(data));
        }else if (error){
            console.log(JSON.stringify(error));
        }
    }
}