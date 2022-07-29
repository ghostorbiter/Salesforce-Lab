/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
private class Day4RestrictContactByNameUnitTest {
    private static string FIRSTNAME = 'INVALID';
    private static string LASTNAME = 'INVALIDNAME';
    @IsTest
    private static void beforeInsertInvalid() {
        Contact contactC = new Contact(FirstName=FIRSTNAME, LastName=LASTNAME);

        Test.startTest();
            Database.SaveResult insertResult = Database.insert(contactC, false);
        Test.stopTest();

        System.assert(!insertResult.isSuccess());
        System.assert(insertResult.getErrors().size() > 0);
        System.assertEquals(insertResult.getErrors()[0].getMessage(),
                'The Last Name "'+LASTNAME+'" is not allowed for DML', 'invalid data insert failed');
    }

    @IsTest
    private static void beforeInsertValid() {
        Contact contactC = new Contact(FirstName=FIRSTNAME, LastName='Valid');

        Test.startTest();
            Database.SaveResult insertResult = Database.insert(contactC, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess());
    }

    @IsTest
    private static void beforeUpdateInvalid() {
        Contact contactC = new Contact(FirstName=FIRSTNAME, LastName='Valid');
        insert contactC;
        contactC.LastName = LASTNAME;

        Test.startTest();
            Database.SaveResult updateResult = Database.update(contactC, false);
        Test.stopTest();

        System.assert(!updateResult.isSuccess());
        System.assert(updateResult.getErrors().size() > 0);
        System.assertEquals(updateResult.getErrors()[0].getMessage(),
                'The Last Name "'+LASTNAME+'" is not allowed for DML', 'invalid data insert failed');
    }

    @IsTest
    private static void beforeUpdateValid() {
        Contact contactC = new Contact(FirstName=FIRSTNAME, LastName='Valid');
        insert contactC;
        contactC.LastName = 'LASTNAME';

        Test.startTest();
        Database.SaveResult updateResult = Database.update(contactC, false);
        Test.stopTest();

        System.assert(updateResult.isSuccess());
    }
}