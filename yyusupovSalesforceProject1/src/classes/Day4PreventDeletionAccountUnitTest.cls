/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
private class Day4PreventDeletionAccountUnitTest {

    @IsTest
    static void deleteAccountWithOpportunities() {
        Account deleteOpportunityAccount =
                Day4PreventDeletionAccountDataFactories.createAccount(true);

        Test.startTest();
            Database.DeleteResult deleteResult = Database.delete(deleteOpportunityAccount, false);
        Test.stopTest();

        System.assert(!deleteResult.isSuccess());
        System.assert(deleteResult.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.',
                deleteResult.getErrors()[0].getMessage(), 'invalid data insert failed');
    }

    @IsTest
    static void deleteAccountWithoutOpportunities() {
        Account deleteNoOpportunityAccount =
                Day4PreventDeletionAccountDataFactories.createAccount(false);

        Test.startTest();
            Database.DeleteResult deleteResult = Database.delete(deleteNoOpportunityAccount, false);
        Test.stopTest();

        System.assert(deleteResult.isSuccess());
    }
}