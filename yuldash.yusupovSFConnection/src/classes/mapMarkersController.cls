/**
 * Created by yyusupov on 22.07.2022.
 */

public with sharing class mapMarkersController {
    @AuraEnabled(Cacheable=true)
    public static List<Account> getWholesalers(){
        return [SELECT Name, BillingCountry, BillingCity, BillingStreet, BillingPostalCode, BillingState
                FROM Account WHERE Customer_Type__c = 'Book Wholesaler'];

//        return [SELECT Order.BillingAddress FROM OrderItem WHERE Product2.Id = :productId];
    }

    @AuraEnabled(Cacheable=true)
    public static List<OrderItem> getWholesalersByProductId(Id productId){
        return [SELECT Order.Account.Name, Order.Account.BillingCountry, Order.Account.BillingCity,
                Order.Account.BillingStreet,Order.Account.BillingPostalCode,Order.Account.BillingState
                FROM OrderItem WHERE Product2.Id = :productId AND Order.Account.Customer_Type__c = 'Book Wholesaler'];
    }
}