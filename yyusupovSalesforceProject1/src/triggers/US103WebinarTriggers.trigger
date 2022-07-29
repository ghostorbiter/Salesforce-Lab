
/**
 * Created by yyusupov on 06.07.2022.
 */

trigger US103WebinarTriggers on Webinar__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    if (Trigger.isAfter && Trigger.isInsert)
    {
        US103WebinarTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isInsert)
    {
        US103WebinarTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    else if (Trigger.isBefore && Trigger.isUpdate)
    {
        US103WebinarTriggerHandler.handleBeforeUpdate(Trigger.new);
        US103WebinarTriggerHandler.handleBeforeUpdate(Trigger.oldMap, Trigger.newMap);
    }

}