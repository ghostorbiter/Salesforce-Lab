/**
 * Created by yyusupov on 07.07.2022.
 */

@IsTest
public class Day4PreventDeletionAccountDataFactories {

    public static Account createAccount(Boolean withOpportunities){
        Account accountC = new Account(AccountNumber='Prevent Deletion Account Test',
                Name='UnitTest', ActiveAccount__c=true);
        Database.insert(accountC, false);
//        createOpportunitiesForAccount(accountC, withOpportunities);

        if(withOpportunities){
            Opportunity opportunity = new Opportunity(Name='preventAccountDeletionOpportunity',
                    StageName='New', CloseDate=Date.today()+30, AccountId=accountC.Id);
            Database.insert(opportunity, true);
        }

        return accountC;
    }

    private static void createOpportunitiesForAccount(Account account, Boolean needOpportunities){
        if(needOpportunities){
            Opportunity opportunity = new Opportunity(Name='preventAccountDeletionOpportunity',
                StageName='New', CloseDate=Date.today()+30, AccountId=account.Id);
            Database.insert(opportunity, false);
        }
        else{
            Opportunity opportunity = new Opportunity(Name='preventAccountDeletionOpportunity',
                    StageName='New', CloseDate=Date.today()+30);
            Database.insert(opportunity, false);
        }
    }

}