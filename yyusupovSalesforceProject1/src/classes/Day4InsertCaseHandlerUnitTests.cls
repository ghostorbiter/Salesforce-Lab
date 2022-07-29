/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
private class Day4InsertCaseHandlerUnitTests {
    @IsTest
    private static void statusOpen() {
        Case caseC = new Case(Status='Open', SuppliedName='Insert Case Unit Test Open');
        insert caseC;

        Test.startTest();
            Day4UnitTestInsertCaseTriggerHandler.updateCase(caseC);
        Test.stopTest();

        Case queriedCaseC = [SELECT Priority FROM Case WHERE SuppliedName='Insert Case Unit Test Open'];
        System.assertEquals(queriedCaseC.Priority, 'Low', 'Insert Case Handler did not work');
    }

    @IsTest
    private static void statusElse() {
        Case caseC = new Case(Status='New', SuppliedName='Insert Case Unit Test Else');
        insert caseC;

        Test.startTest();
            Day4UnitTestInsertCaseTriggerHandler.updateCase(caseC);
        Test.stopTest();

        Case queriedCaseC = [SELECT Priority FROM Case WHERE SuppliedName='Insert Case Unit Test Else'];
        System.assertEquals(queriedCaseC.Priority, 'Medium', 'Insert Case Handler did not work');
    }
}