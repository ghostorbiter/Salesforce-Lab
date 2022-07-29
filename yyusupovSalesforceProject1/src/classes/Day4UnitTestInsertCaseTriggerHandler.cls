/**
 * Created by yyusupov on 07.07.2022.
 */

public class Day4UnitTestInsertCaseTriggerHandler {

    public static void updateCase (Case caseC) {
        if (caseC.Status == 'Open')
            caseC.Priority = 'Low';
        else caseC.Priority = 'Medium';

        update caseC;
    }

}