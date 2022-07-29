/**
 * Created by yyusupov on 06.07.2022.
 */

public with sharing class US103WebinarTriggerHandler
{

    public static void handleAfterInsert(List<Webinar__c> webinars)
    {
        webinarEventCreation(webinars);
    }

    public static void handleBeforeInsert(List<Webinar__c> webinars)
    {
        costBelow100EUR(webinars);
        cancelRejectedWebinars(webinars);
        ParticipantsExceedSeats(webinars);
//        pricePerParticipant(webinars, true);
    }

    public static void handleBeforeUpdate(List<Webinar__c> webinars)
    {
        costBelow100EUR(webinars);
        cancelRejectedWebinars(webinars);
        calculateNumberOfParticipants(webinars);
        ParticipantsExceedSeats(webinars);
//        pricePerParticipant(webinars, true);
    }

    public static void handleBeforeUpdate(Map<Id, Webinar__c> webinarsOld, Map<Id, Webinar__c> webinarsNew)
    {
        changeStatusChangeApproval(webinarsOld, webinarsNew);
    }

    // *** Logic ***

    private static void costBelow100EUR(List<Webinar__c> webinars)
    {
        for(Webinar__c webinar : webinars)
        {
            if (webinar.Cost__c < 100)
            {
                webinar.Approval_Status__c = 'Approved';
            }
        }
    }

    private static void cancelRejectedWebinars(List<Webinar__c> webinars)
    {
        for (Webinar__c webinar : webinars)
        {
            if (webinar.Approval_Status__c == 'Rejected')
            {
                webinar.Status__c = 'Canceled';
            }
        }
    }

    private static void ParticipantsExceedSeats(List<Webinar__c> webinars)
    {
        for(Webinar__c webinar : webinars)
        {
            if (webinar.Number_of_Participants__c > webinar.Total_Number_of_Seats__c)
            {
                webinar.addError('Number of Participants exceed Number of Seats');
            }
        }
    }

    private static void calculateNumberOfParticipants(List<Webinar__c> webinars)
    {
        List<Webinar_Member__c> webinarMembers = [SELECT Id, Related_Webinar__c FROM Webinar_Member__c];
        for(Webinar__c webinar : webinars)
        {
            webinar.Number_of_Participants__c = 0;
            for(Webinar_Member__c webinarMember : webinarMembers)
            {
                if (webinar.Number_of_Participants__c < webinar.Total_Number_of_Seats__c
                    && webinar.Total_Number_of_Seats__c != null && webinarMember.Related_Webinar__c == webinar.Id)
                {
                    webinar.Number_of_Participants__c++;
                }
            }
        }
    }

    private static void pricePerParticipant(List<Webinar__c> webinars, Boolean isSeats)
    {
        if (isSeats)
        {
            for (Webinar__c webinar : webinars)
            {
                if (webinar.Total_Number_of_Seats__c != null && webinar.Total_Number_of_Seats__c > 0)
                {
                    webinar.Price__c = webinar.Cost__c / webinar.Total_Number_of_Seats__c;
                }
                else
                {
                    webinar.addError('Number of seats cannot be 0');
                }
            }
        }
        else
        {
            calculateNumberOfParticipants(webinars);
            for (Webinar__c webinar : webinars)
            {
                if (webinar.Number_of_Participants__c != null && webinar.Number_of_Participants__c > 0)
                {
                    webinar.Price__c = webinar.Cost__c / webinar.Number_of_Participants__c;
                }
                else
                {
                    webinar.addError('Number of participants cannot be 0');
                }
            }
        }
    }

    private static void changeStatusChangeApproval(Map<Id, Webinar__c> webinarsOld, Map<Id, Webinar__c> webinarsNew)
    {
        for (Id webinarId : webinarsOld.keySet())
        {
            if (webinarsOld.get(webinarId).Status__c == 'New' && webinarsNew.get(webinarId).Status__c != 'Canceled'
                && webinarsOld.get(webinarId).Approval_Status__c == 'Pending')
            {
                if (webinarsNew.get(webinarId).Status__c == 'Completed')
                    webinarsNew.get(webinarId).Approval_Status__c = 'Approved';
                else
                    webinarsNew.get(webinarId).Approval_Status__c = 'Rejected';
            }
        }
    }

    private static void webinarEventCreation(List<Webinar__c> webinars)
    {
        List<Webinar_Platform_Event__e> webinarEvents = new List<Webinar_Platform_Event__e>();
        for (Webinar__c webinar : webinars)
        {
            Webinar_Platform_Event__e event = new Webinar_Platform_Event__e();
            event.Webinar_Salesforce_Id__c = webinar.Id;
            webinarEvents.add(event);
        }

        List<Database.SaveResult> results = EventBus.publish(webinarEvents);

        for (Database.SaveResult result : results)
        {
            if (result.isSuccess())
            {
                System.debug('Successfully published event');
            }
            else
            {
                for (Database.Error error : result.getErrors())
                {
                    System.debug('Error returned: ' + error.getStatusCode() + ' - ' + error.getMessage());
                }
            }
        }
    }

}