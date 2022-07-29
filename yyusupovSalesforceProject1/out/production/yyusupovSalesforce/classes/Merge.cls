/**
 * Created by yyusupov on 05.07.2022.
 */

public with sharing class Merge {

    public void MergeTwoInstances(SObject master, SObject slave)
    {
        if (master.getSObjectType() != slave.getSObjectType())
        {
            throw new Exception('The provided instances are not same!');
        }

        String sObjectType = master.getSObjectType().getDescribe().getName();
        Map<String, SObjectField> masterFields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();

        try{
            for (String str : masterFields.keySet())
            {
                if (master.get(str) == null)
                {
                    if (slave.get(str) != null)
                    {
                        master.put(str, slave.get(str));
                    }
                }
            }
        } catch (Exception ex)
        {
            System.debug(ex);
        }
    }

    @IsTest
    public void Main()
    {
        Account testAcc1 = new Account(Name='Yuldash', Type='Technology PArtner', Industry='Consulting', AnnualRevenue=10000);
        Account testAcc2 = new Account(Name='Something', NumberOfEmployees=200, Description='Some description');

        (Account)MergeTwoInstances(testAcc1, testAcc2);
        System.debug(testAcc1);
    }
}