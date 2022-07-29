/**
 * Created by yyusupov on 07.07.2022.
 */

trigger Day4UnitTestTriggersContact on Contact (before insert, before update) {
    //check contacts prior to insert or update for invalid data

    For (Contact c : Trigger.New) {
        if(c.LastName == 'INVALIDNAME') {	//invalidname is invalid
            c.AddError('The Last Name "'+c.LastName+'" is not allowed for DML');
        }
    }
}