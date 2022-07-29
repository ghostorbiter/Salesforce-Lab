/**
 * Created by yyusupov on 21.07.2022.
 */

trigger updateTeamTrigger on Employee__c (after insert, after update, after delete) {
    if (Trigger.isAfter && Trigger.isInsert){
        UpdateTeamTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate){
        UpdateTeamTriggerHandler.handleAfterUpdate(Trigger.new);
    }

}