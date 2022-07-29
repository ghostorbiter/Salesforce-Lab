/**
 * Created by yyusupov on 21.07.2022.
 */

public with sharing class EmployeeActionTriggerHandler {
    public static void handleBeforeInsert(List<Employee_Action__c> newActions){
        restrictOpenAction(newActions);
    }

    private static void restrictOpenAction(List<Employee_Action__c> newActions){
        List<Id> actionIds = new List<Id>();
        for(Employee_Action__c action : newActions){
            actionIds.add(action.Reference_to_Action__c);
        }

        Map<Id, Action__c> mapIdToAction = new Map<Id, Action__c>([SELECT Id, Status__c FROM
                Action__c WHERE Id In :actionIds]);

        for (Employee_Action__c action : newActions){
            if (mapIdToAction.get(action.Reference_to_Action__c).Status__c != 'Open Registration'){
                action.addError('Cannot create Employee Action for Action without Status "Open Registration"');
            }
        }
    }
}