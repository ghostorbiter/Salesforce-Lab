/**
 * Created by yyusupov on 21.07.2022.
 */

public with sharing class UpdateTeamTriggerHandler {

    public static void handleAfterInsert(List<Employee__c> employees){
//        calculateTeamTotalPoints(employees);
    }

    public static void handleAfterUpdate(List<Employee__c> employees){
//        calculateTeamTotalPoints(employees);
    }

    // *** Logic ***

    private static void calculateTeamTotalPoints(List<Employee__c> employees){
//        List<Id> employeeTeamIds = new List<Id>();
//        for(Employee__c employee : employees){
//            employeeTeamIds.add(employee.Team__c);
//        }
//
//        List<Team__c> teams = [SELECT Id, Type__c, Total_Points__c FROM Team__c WHERE Id IN :employeeTeamIds];
//
//        List<Id> teamIds = new List<Id>();
//        List<Id> officeIds = new List<Id>();
//        List<Id> countryIds = new List<Id>();
//
//        for(Team__c team : teams){
//            team.Total_Points__c = 0;
//
//            if (team.Type__c == 'Team'){
//                teamIds.add(team.Id);
//            }else if (team.Type__c == 'Office'){
//                officeIds.add(team.Id);
//            }else if (team.Type__c == 'Country'){
//                countryIds.add(team.Id);
//            }
//        }
//
//        calculateTotalPointsTypeTeam(teamIds);
//        calculateTotalPointsTypeOffice(officeIds);
//        calculateTotalPointsTypeCountry(countryIds);

        List<Id> employeeTeamIds = new List<Id>();
        for(Employee__c employee : employees){
            employeeTeamIds.add(employee.Team__c);
        }

        Map<Id, Team__c> mapIdToTeam = new Map<Id, Team__c>([SELECT Id, (SELECT Id, Type__c FROM Teams__r),
                Type__c, Total_Points__c FROM Team__c WHERE Id IN :employeeTeamIds]);

        for(Employee__c employee : employees){
            Team__c currentTeam = mapIdToTeam.get(employee.Team__c);
            switch on currentTeam.Type__c {
                 when 'Team' {
                     currentTeam.Total_Points__c += employee.Total_Points__c;
                 }
                when 'Office'{
                    mapIdToTeam.get(employee.Id).Total_Points__c = 0;
                    for (Team__c team : mapIdToTeam.get(employee.Id).Teams__r){
                        if (team.Type__c == 'Team'){
                            mapIdToTeam.get(employee.Id).Total_Points__c += team.Total_Points__c;
                        }
                    }
                }
                when 'Country'{
                    mapIdToTeam.get(employee.Id).Total_Points__c = 0;
                    for (Team__c team : mapIdToTeam.get(employee.Id).Teams__r){
                        if (team.Type__c == 'Office'){
                            mapIdToTeam.get(employee.Id).Total_Points__c += team.Total_Points__c;
                        }
                    }
                }
            }
        }

        update mapIdToTeam.values();
//        update teams;
    }
}