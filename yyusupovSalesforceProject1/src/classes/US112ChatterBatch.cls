/**
 * Created by yyusupov on 14.07.2022.
 */

public with sharing class US112ChatterBatch implements Database.Batchable<SObject>{

    public Iterable<SObject> start(Database.BatchableContext param1) {
//        return Database.getQueryLocator('SELECT Related_User__r.Id, Related_Webinar__r.Start_Date__c, ' +
//                'Related_Webinar__r.Name FROM Webinar_Member__c WHERE Related_User__c != NULL AND ' +
//                'Related_Webinar__c != NULL AND Related_Webinar__r.Start_Date__c = TODAY AND ' +
//                'Related_Webinar__r.Start_Date__c <= ' + System.now().addHours(2) + ' AND ' +
//                'Related_Webinar__r.Start_Date__c >= ' + System.now().addHours(1));

        return [
                SELECT Related_User__r.Id, Related_Webinar__r.Start_Date__c, Related_Webinar__r.Name
                FROM Webinar_Member__c
                WHERE Related_User__c != NULL
                AND Related_Webinar__c != NULL
                AND Related_Webinar__r.Start_Date__c != NULL
                AND Related_Webinar__r.Start_Date__c = TODAY
                AND Related_Webinar__r.Start_Date__c <= :System.now().addHours(2)
                AND Related_Webinar__r.Start_Date__c >= :System.now().addHours(1)
        ];
    }

    public void execute(Database.BatchableContext param1, List<Webinar_Member__c> members) {

        if (!members.isEmpty()){
            List<FeedItem> feedItems = new List<FeedItem>();
            for (Webinar_Member__c member : members){

                FeedItem feedItem = new FeedItem(ParentId = member.Related_User__c, Body='Hey! Your Webinar ' +
                        member.Related_Webinar__r.Name + ' is starting in 2 hours');
                feedItems.add(feedItem);
            }
            try{
                insert feedItems;
            }catch (DmlException ex){
                System.debug(ex + '\n');
            }
        }
    }

    public void finish(Database.BatchableContext param1) {
        System.debug('Finished');
    }

}