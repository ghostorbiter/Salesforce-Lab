/**
 * Created by yyusupov on 22.07.2022.
 */

trigger CollectionTrigger on Collections__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate){
        CollectionTriggerHandler.handleAfterUpdate(Trigger.new);
    }
}