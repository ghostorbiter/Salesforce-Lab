/**
 * Created by yyusupov on 06.07.2022.
 */

public with sharing class US104WebinarMemberTriggerHandler
{

    public static void handleBeforeInsert(List<Webinar_Member__c> webinarMembers)
    {
        assignContactsToExternal(webinarMembers);
        onlyUserOrContact(webinarMembers);
        statusRejectedFillComments(webinarMembers);
        sameWebinarMembersContactUser(webinarMembers);
    }

    public static void handleBeforeUpdate(List<Webinar_Member__c> webinarMembers)
    {
        assignContactsToExternal(webinarMembers);
        onlyUserOrContact(webinarMembers);
        addParticipantToWebinar(webinarMembers);
        statusRejectedFillComments(webinarMembers);
    }

    public static void handleAfterInsert(List<Webinar_Member__c> webinarMembers)
    {
        addParticipantToWebinar(webinarMembers);
    }

    public static void handleAfterUpdate(List<Webinar_Member__c> webinarMembers)
    {
        addParticipantToWebinar(webinarMembers);
    }


    // *** Logic ***

    private static void assignContactsToExternal(List<Webinar_Member__c> webinarMembers)
    {
        Set<Id> webinarIds = new Set<Id>();
        for (Webinar_Member__c webinarMember : webinarMembers)
        {
            if (webinarMember.Related_Contact__c != null)
            {
                webinarIds.add(webinarMember.Related_Webinar__c);
            }
        }

        List<Webinar__c> webinars = [SELECT Id, Type__c FROM Webinar__c WHERE Id IN :webinarIds];
        for (Webinar__c webinar : webinars)
        {
            //addError?
            if (webinar.Type__c == 'External')
            {
                for (Webinar_Member__c webinarMember : webinarMembers)
                {
                    if (webinarMember.Related_Webinar__c == webinar.Id && webinarMember.Related_Contact__c != null)
                    {
                        webinarMember.Status__c = 'Accepted';
                    }
                }
            }
        }
    }

    private static void onlyUserOrContact(List<Webinar_Member__c> webinarMembers)
    {
        for (Webinar_Member__c webinarMember : webinarMembers)
        {
            if (webinarMember.Related_Contact__c != null && webinarMember.Related_User__c != null)
            {
                webinarMember.addError('Webinar Member cannot be Contact and User at the same time');
            }
        }
    }

    //Fix this later
    private static void addParticipantToWebinar(List<Webinar_Member__c> webinarMembers)
    {
        Set<Id> webinarIds = new Set<Id>();
        for (Webinar_Member__c webinarMember : webinarMembers)
        {
            webinarIds.add(webinarMember.Related_Webinar__c);
        }

        List<Webinar__c> webinars = [SELECT Id, Number_of_Participants__c FROM Webinar__c WHERE Id IN :webinarIds];
        Database.update(webinars, false);
    }

    private static void statusRejectedFillComments (List<Webinar_Member__c> webinarMembers)
    {
        for (Webinar_Member__c webinarMember : webinarMembers)
        {
            if (webinarMember.Status__c == 'Rejected' && webinarMember.Comments__c == null)
            {
                webinarMember.addError('Comment should not be null');
            }
        }
    }

    private static void sameWebinarMembersContactUser (List<Webinar_Member__c> webinarMembers)
    {
        List<Webinar_Member__c> allWebinarMembers = [SELECT Id, Related_Contact__c, Related_User__c,
                Related_Webinar__c FROM Webinar_Member__c];

        for (Webinar_Member__c webinarMember : webinarMembers)
        {
            for (Webinar_Member__c allWebinarMember : allWebinarMembers)
            {
                if (webinarMember.Related_Webinar__c == allWebinarMember.Related_Webinar__c &&
                        ((webinarMember.Related_Contact__c == allWebinarMember.Related_Contact__c &&
                        webinarMember.Related_Contact__c != null) ||
                        (webinarMember.Related_User__c == allWebinarMember.Related_User__c &&
                        webinarMember.Related_User__c!=null)))
                {
                    webinarMember.addError('Cannot create the webinar member with the same User/Contact and' +
                            ' same Webinar');
                }
            }
        }
    }

//    The below does not work
//
//    private static void equaliseCalculationNumOfWebinarParticipantsWithSeats(List<Webinar_Member__c> webinarMembers)
//    {
//        Set<Id> webinarIds = new Set<Id>();
//        for (Webinar_Member__c webinarMember : webinarMembers)
//        {
//            webinarIds.add(webinarMember.Related_Webinar__c);
//        }
//
//        List<Webinar__c> webinars = [SELECT Id, Type__c FROM Webinar__c WHERE Id IN :webinarIds];
//        for (Webinar__c webinar : webinars)
//        {
//            for (Webinar_Member__c webinarMember : webinarMembers)
//            {
//                if (webinarMember.Related_Webinar__c == webinar.Id &&
//                        webinar.Number_of_Participants__c < webinar.Total_Number_of_Seats__c)
//                {
//                    webinar.Number_of_Participants__c++;
//                }
//            }
//        }
//    }
//
//
//    private static void calculateNumOfWebinarParticipants(List<Webinar_Member__c> webinarMembers)
//    {
//        Set<Id> webinarIds = new Set<Id>();
//        for (Webinar_Member__c webinarMember : webinarMembers)
//        {
//            webinarIds.add(webinarMember.Related_Webinar__c);
//        }
//
//        List<Webinar__c> webinars = [SELECT Id, Type__c FROM Webinar__c WHERE Id IN :webinarIds];
//        for (Webinar__c webinar : webinars)
//        {
//            webinar.Number_of_Participants__c = 0;
//            for (Webinar_Member__c webinarMember : webinarMembers)
//            {
//                if (webinarMember.Related_Webinar__c == webinar.Id)
//                {
//                    webinar.Number_of_Participants__c = webinar.Number_of_Participants__c + 1;
//                }
//            }
//        }
//    }

}