/**
 * Created by yyusupov on 22.07.2022.
 */

public with sharing class CollectionTriggerHandler {
    public static void handleAfterUpdate(List<Collections__c> newCollections){
        withdrawnCollectionProductsDeactivated(newCollections);
    }



    private static void withdrawnCollectionProductsDeactivated(List<Collections__c> newCollections){
        List<Id> collectionIds = new List<Id>();
        for (Collections__c collection : newCollections){
            if (collection.Status__c == 'Withdrawn'){
                collectionIds.add(collection.Id);
            }
        }

        List<Product2> relatedProducts = [SELECT IsActive FROM Product2 WHERE Collection__c IN :collectionIds];
        for (Product2 product : relatedProducts){
            product.IsActive = false;
        }

        update relatedProducts;
    }
}