/**
 * Created by yyusupov on 21.07.2022.
 */

trigger EmployeeActionTrigger on Employee_Action__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert){
        EmployeeActionTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}