/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
public class US104WebinarDataFactory {
    public static Id createWebinarApproval(Boolean withMembers, Integer cost, Integer numOfSeats, String approvalStatus){
        Webinar__c webinarC = new Webinar__c(Name='TestWebinar',
                Total_Number_of_Seats__c=numOfSeats, Cost__c=cost, Approval_Status__c = approvalStatus);
        Database.insert(webinarC, false);

        if(withMembers){
            assignMembersToWebinar(webinarC, returnWebinarMembers(3));
        }

        return webinarC.Id;
    }

    public static Id createWebinarType(Boolean withMembers, Integer cost, Integer numOfSeats, String type){
        Webinar__c webinarC = new Webinar__c(Name='TestWebinar',
                Total_Number_of_Seats__c=numOfSeats, Cost__c=cost, Type__c=type);
        Database.insert(webinarC, false);

        if(withMembers){
            assignMembersToWebinar(webinarC, returnWebinarMembers(3));
        }

        return webinarC.Id;
    }

    public static List<Webinar_Member__c> returnWebinarMembers(Integer n){
        List<Webinar_Member__c> webinarMembers = new List<Webinar_Member__c>();
        for (Integer i = 0; i < n; i++){
            webinarMembers.add(new Webinar_Member__c(Name=getRandomName()));
        }
        Database.insert(webinarMembers, false);

        return webinarMembers;
    }

    public static Webinar_Member__c createWebinarMemberContactUser(Id contactId, Id userId, Boolean isSave){
        Webinar_Member__c member = new Webinar_Member__c(Name=getRandomName(), Related_User__c=userId,
                Related_Contact__c=contactId);

        if (isSave){
            Database.insert(member, false);
        }

        return member;
    }

    public static Contact createContact(Boolean isInsert){
        Contact contactC = new Contact(FirstName=getRandomName(), LastName=getRandomName());
        if (isInsert) {
            Database.insert(contactC, false);
        }

        return contactC;
    }


    private static void assignMembersToWebinar(Webinar__c webinar, List<Webinar_Member__c> members){
        for (Webinar_Member__c member : members){
            member.Related_Webinar__c = webinar.Id;
        }
        Database.update(members, false);
    }

    private static String getRandomName() {
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String pwd = key.substring(0,len);
        return pwd;
    }
}