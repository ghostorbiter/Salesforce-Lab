/**
 * Created by yyusupov on 14.07.2022.
 */

public with sharing class US112EmailBatch implements Database.Batchable<SObject>{

    public Iterable<SObject> start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT Name, Related_Contact__r.Email FROM Webinar_Member__c'
                + ' WHERE Related_Contact__c != NULL AND Related_Webinar__c != NULL AND ' +
                'Related_Webinar__r.Start_Date__c = TOMORROW');
    }

    public void execute(Database.BatchableContext param1, List<Webinar_Member__c> contacts) {

        if (!contacts.isEmpty()){
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('Event is near');
            message.setPlainTextBody('Don\'t miss it! It is tomorrow');
            message.saveAsActivity = false;
            String[] toAddresses;

            for (Webinar_Member__c externalParticipant : contacts){
                if (externalParticipant.Related_Contact__r.Email != null){
                    toAddresses.add(externalParticipant.Related_Contact__r.Email);
                }
            }

            message.setToAddresses(toAddresses);
            mailList.add(message);

            try{
                Messaging.sendEmail(mailList);
            }catch (Exception ex){
                System.debug(ex + '\n');
            }
        }
    }

    public void finish(Database.BatchableContext param1) {

    }
}