/**
 * Created by yyusupov on 21.07.2022.
 */

import { LightningElement, api, wire, track } from 'lwc';
import getTeams from '@salesforce/apex/GetTeamData.getTeams';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const COLUMNS = [
        {label: 'Team Name', fieldName:'teamName'},
        {label: 'Total Points', fieldName:'TotalPoints'},
        {label: 'Number of Employees', fieldName:'NumberOfEmployees'},
        {type: 'button', typeAttributes: {
                label: 'View',
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'View'
            }},
]

export default class TeamRanking extends LightningElement {
    teamColumns = COLUMNS;
    teamId = null;
    @track teams;
    showDetails = false;
    sizes;
    searchValue = '';

    searchKeyword(event) {
            this.searchValue = event.target.value;
    }

    handleSearchKeyword(){
        getTeams({nameVal: this.searchValue})
        .then(result =>{
            this.teams = result;
        }).catch(error=>{
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
            });
            this.dispatchEvent(event);
            this.teams = null;
        });
    }

    @wire(getTeams) wiredTeams({data, error}) {
        if (data){
            console.log(JSON.stringify(data));
            this.teams = data;
        }else if (error){
            console.error(JSON.stringify(error));
        }
    }

    callRowAction(event){
        this.teamId = event.detail.row.Id;
        const actionName = event.detail.action.name;
        console.log(JSON.stringify(event))
        console.log(this.teamId)
        console.log(this.teams)
        if (actionName == 'View'){
            this.showDetails = true;
        }
    }
}