/**
 * Created by yyusupov on 11.07.2022.
 */

public with sharing class US107WebinarSearchComponentCtrlr {
    @AuraEnabled
    public static Webinar__c[] getWebinars(){
        System.debug('test from get webinars');
        return [SELECT Type__c,Name,Status__c, Approval_Status__c, Cost__c FROM Webinar__c LIMIT 50];
    }

    @AuraEnabled
    public static Webinar__c[] getWebinarsByType(String type){
        return [SELECT Type__c,Name,Status__c, Approval_Status__c, Cost__c FROM Webinar__c WHERE
                Type__c LIKE :type LIMIT 50];
    }

    @AuraEnabled
    public static Webinar__c[] getWebinarsByStatus(String status){
        System.debug('before return');
        System.debug(status);

        return [SELECT Type__c,Name,Status__c, Approval_Status__c, Cost__c FROM Webinar__c WHERE
                Status__c LIKE :status  LIMIT 50];
    }

    @AuraEnabled
    public static void registerForWebinar(Id webinarId){
        Id currentUserId = UserInfo.getUserId();
        Webinar_Member__c webinarMember = new Webinar_Member__c(Related_User__c = currentUserId,
                Related_Webinar__c = webinarId);
//        Database.insert(webinarMember, false);
        insert webinarMember;
    }
}