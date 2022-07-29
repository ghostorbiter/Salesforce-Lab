/**
 * Created by yyusupov on 15.07.2022.
 */

trigger RandomContactAccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert){
        RandomContactAccountTriggerHandler.handleAfterInsert(Trigger.newMap);
    }
}