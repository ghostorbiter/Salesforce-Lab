/**
 * Created by yyusupov on 13.07.2022.
 */

public with sharing class US109WebinarCreateButtonCtrlr {
    @AuraEnabled
    public static Id cloneWebinar(String name, String type, Decimal cost, Decimal price){
        Webinar__c webinar = new Webinar__c(Name = name, Type__c = type, Cost__c = cost, Price__c = price);

        insert webinar;
        return webinar.Id;
    }
}