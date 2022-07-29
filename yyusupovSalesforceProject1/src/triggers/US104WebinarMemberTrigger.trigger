/**
 * Created by yyusupov on 06.07.2022.
 */

trigger US104WebinarMemberTrigger on Webinar_Member__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{

    if (Trigger.isBefore && Trigger.isInsert)
    {
        US104WebinarMemberTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    else if (Trigger.isBefore && Trigger.isUpdate)
    {
        US104WebinarMemberTriggerHandler.handleBeforeUpdate(Trigger.new);
    }

    else if (Trigger.isAfter && Trigger.isInsert)
    {
        US104WebinarMemberTriggerHandler.handleAfterInsert(Trigger.new);
    }

    else if (Trigger.isAfter && Trigger.isUpdate)
    {
        US104WebinarMemberTriggerHandler.handleAfterUpdate(Trigger.new);
    }

}