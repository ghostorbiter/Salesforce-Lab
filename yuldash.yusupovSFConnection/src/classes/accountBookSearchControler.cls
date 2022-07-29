/**
 * Created by yyusupov on 22.07.2022.
 */

public with sharing class accountBookSearchControler {
    @AuraEnabled (Cacheable = true)
    public static List<SObject> getSearchedBooks(String searchStr, Id accountId){
        if (searchStr == ''){
            searchStr = '%';
        }else {
            searchStr = '%' + searchStr + '%';
        }

        return [
                SELECT OrderId orderId, Order.Name strName, Order.EffectiveDate startDate, Order.Status Status, SUM(Quantity) Quantity
                FROM OrderItem
                WHERE Product2.Name LIKE :searchStr AND Order.Account.Id = :accountId
                GROUP BY Order.Name, OrderId, Order.Status, Order.EffectiveDate
        ];
    }
}