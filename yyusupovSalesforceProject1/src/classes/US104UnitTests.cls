/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
private class US104UnitTests {

    //----------------------------- Below 100 ---------------------------------

    @IsTest
    static void beforeInsertCostBelow100UTInvalid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 90, 100, '');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals('Approved', webinar.Approval_Status__c);
    }

    @IsTest
    static void beforeInsertCostBelow100UTValid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100, '');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals(null, webinar.Approval_Status__c);
    }

    @IsTest
    static void beforeUpdateCostBelow100UTInvalid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100, '');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        webinar.Cost__c = 90;
        Database.update(webinar, false);
        webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals('Approved', webinar.Approval_Status__c);
    }

    @IsTest
    static void beforeUpdateCostBelow100UTValid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100, '');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        webinar.Cost__c = 500;
        Database.update(webinar, false);
        webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals(null, webinar.Approval_Status__c);
    }

    //----------------------------- Reject Canceled ---------------------------------

    @IsTest
    static void beforeInsertRejectCanceledInvalid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100,
                'Rejected');
        Webinar__c webinar = [SELECT Id, Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals('Canceled', webinar.Status__c);
    }

    @IsTest
    static void beforeInsertRejectCanceledValid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100,
                'Approved');
        Webinar__c webinar = [SELECT Id, Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals(null, webinar.Status__c);
    }

    @IsTest
    static void beforeUpdateRejectCanceledInvalid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100,
                'Approved');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        webinar.Approval_Status__c = 'Rejected';
        Database.update(webinar, false);
        webinar = [SELECT Id, Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals('Canceled', webinar.Status__c);
    }

    @IsTest
    static void beforeUpdateRejectCanceledValid() {
        Test.startTest();
        Id webinarID = US104WebinarDataFactory.createWebinarApproval(false, 200, 100,
                'Approved');
        Webinar__c webinar = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id = :webinarID];
        webinar.Approval_Status__c = null;
        Database.update(webinar, false);
        webinar = [SELECT Id, Status__c FROM Webinar__c WHERE Id = :webinarID];
        Test.stopTest();

        System.assertEquals(null, webinar.Status__c);
    }

    //---------------------------- Contact || User ------------------------------------

    @IsTest
    static void beforeInsertContactUserInvalid() {
        Test.startTest();
        List<User> userId = [SELECT Id FROM User LIMIT 1];
        Contact contactId = US104WebinarDataFactory.createContact(true);
        Webinar_Member__c member = US104WebinarDataFactory.createWebinarMemberContactUser(contactId.Id, userId[0].Id, false);
        Database.SaveResult saveResult = Database.insert(member, false);
        Test.stopTest();

        System.assert(!saveResult.isSuccess());
        System.assert(saveResult.getErrors().size() > 0);
        System.assertEquals('Webinar Member cannot be Contact and User at the same time',
                saveResult.getErrors()[0].getMessage());
    }

    @IsTest
    static void beforeInsertContactUserValid() {
        Test.startTest();
        List<User> userId = [SELECT Id FROM User LIMIT 1];
        Webinar_Member__c userMember = US104WebinarDataFactory.createWebinarMemberContactUser(null, userId[0].Id, false);
        Database.SaveResult saveResultUser = Database.insert(userMember, false);

        Contact contactId = US104WebinarDataFactory.createContact(true);
        Webinar_Member__c contactMember = US104WebinarDataFactory.createWebinarMemberContactUser(
                contactId.Id, null, false);
        Database.SaveResult saveResultContact = Database.insert(contactMember, false);
        Test.stopTest();

        System.assert(saveResultUser.isSuccess());
        System.assert(saveResultContact.isSuccess());
    }

    @IsTest
    static void beforeUpdateContactUserInvalid() {
        List<User> userId = [SELECT Id FROM User LIMIT 1];
        Contact contactId = US104WebinarDataFactory.createContact(true);
        Webinar_Member__c userMember = US104WebinarDataFactory.createWebinarMemberContactUser(null, userId[0].Id, true);
        Webinar_Member__c contactMember = US104WebinarDataFactory.createWebinarMemberContactUser(contactId.Id, null, true);

        Test.startTest();
        userMember.Related_Contact__c = contactId.Id;
        Database.SaveResult saveResultUser = Database.update(userMember, false);

        contactMember.Related_User__c = userId[0].Id;
        Database.SaveResult saveResultContact = Database.update(contactMember, false);
        Test.stopTest();

        System.assert(!saveResultUser.isSuccess());
        System.assert(saveResultUser.getErrors().size() > 0);
        System.assertEquals('Webinar Member cannot be Contact and User at the same time',
                saveResultUser.getErrors()[0].getMessage());

        System.assert(!saveResultContact.isSuccess());
        System.assert(saveResultContact.getErrors().size() > 0);
        System.assertEquals('Webinar Member cannot be Contact and User at the same time',
                saveResultContact.getErrors()[0].getMessage());
    }

    @IsTest
    static void beforeUpdateContactUserValid() {

        List<User> userId = [SELECT Id FROM User LIMIT 1];
        Contact contactId = US104WebinarDataFactory.createContact(true);
        Webinar_Member__c userMember = US104WebinarDataFactory.createWebinarMemberContactUser(null, userId[0].Id, true);
        Webinar_Member__c contactMember = US104WebinarDataFactory.createWebinarMemberContactUser(contactId.Id, null, true);

        Test.startTest();
        userMember.Comments__c = 'This is comment';
        Database.SaveResult saveResultUser = Database.update(userMember, false);

        contactMember.Comments__c = 'This is comment';
        Database.SaveResult saveResultContact = Database.update(contactMember, false);
        Test.stopTest();

        System.assert(saveResultUser.isSuccess());
        System.assert(saveResultContact.isSuccess());

    }

}