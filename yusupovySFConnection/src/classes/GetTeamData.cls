/**
 * Created by yyusupov on 21.07.2022.
 */

public with sharing class GetTeamData {
    @AuraEnabled (Cacheable = true)
    public static List<Object> getTeams(String nameVal){
//        return [SELECT Name, Total_Points__c, COUNT(Employees__r) FROM
//                Team__c ORDER BY Total_Points__c DESC];

        if (nameVal == null || nameVal == '') {
            return [
                    SELECT Team__r.Id, Count(Id) NumberOfEmployees, Team__r.Name teamName, MAX(Team__r.Total_Points__c)
                            TotalPoints
                    FROM Employee__c
                    WHERE Team__r.Type__c = 'Team'
                    GROUP BY Team__r.Id, Team__r.Name
            ];
        }else{
            String nameValString = '%' + nameVal + '%';

            return [
                    SELECT Team__r.Id, Count(Id) NumberOfEmployees, Team__r.Name teamName, MAX(Team__r.Total_Points__c)
                            TotalPoints
                    FROM Employee__c
                    WHERE Team__r.Type__c = 'Team' AND Team__r.Name LIKE :nameValString
                    GROUP BY Team__r.Id, Team__r.Name
            ];
        }
    }

    @AuraEnabled (Cacheable = true)
    public static List<Employee__c> getTeamById(Id id){
        return [SELECT First_Name__c, Last_Name__c, Total_Points__c FROM Employee__c WHERE Team__c = :id];
    }
}