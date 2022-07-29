/**
 * Created by yyusupov on 13.07.2022.
 */

public with sharing class US108ChildShowQuestionnaireCtlr {
    @AuraEnabled (Cacheable = true)
    public static List<Questionnaire__c> selectRelatedQuestionnaires(Id userId){
        return [SELECT Name, Attendance__c, Age__c, Score__c, Feedback__c, Related_Webinar__c FROM
                Questionnaire__c WHERE OwnerId =:userId ORDER BY Name LIMIT 50];
    }
}