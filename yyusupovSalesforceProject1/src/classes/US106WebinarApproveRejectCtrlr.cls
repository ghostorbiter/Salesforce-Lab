/**
 * Created by yyusupov on 08.07.2022.
 */

public with sharing class US106WebinarApproveRejectCtrlr {
        @AuraEnabled
        public static Webinar__c[] getWebinars(Integer queryLimit){
            return [SELECT Type__c,Name,Status__c, Approval_Status__c, Cost__c FROM Webinar__c WHERE
                    Approval_Status__c = 'Pending' LIMIT :queryLimit];
    }

    @AuraEnabled
    public static void changeApprovalStatus(Id webinarId, String newStatus){
        Webinar__c webinar = [SELECT Id FROM Webinar__c WHERE Id = :webinarId];
        webinar.Approval_Status__c = newStatus;
        update webinar;
    }

    @AuraEnabled
    public static void assignRejectReason(Id webinarId, String reason){
        Webinar__c webinar = [SELECT Id FROM Webinar__c WHERE Id = :webinarId];
        webinar.Description__c = reason;
        update webinar;
    }

}