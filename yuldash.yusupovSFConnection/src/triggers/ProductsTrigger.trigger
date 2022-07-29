/**
 * Created by yyusupov on 22.07.2022.
 */

trigger ProductsTrigger on Product2 (after update) {
    if (Trigger.isAfter && Trigger.isUpdate){
        ProductsTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
}