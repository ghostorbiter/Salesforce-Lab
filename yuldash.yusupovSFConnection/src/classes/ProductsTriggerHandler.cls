/**
 * Created by yyusupov on 22.07.2022.
 */

public with sharing class ProductsTriggerHandler implements Queueable{
    private Map<Id, Product2> oldProductsMap;
    private Map<Id, Product2> newProductsMap;

    public static void handleAfterUpdate(Map<Id, Product2> oldProductsMapPass, Map<Id, Product2> newProductsMapPass){
        ProductsTriggerHandler handler = new ProductsTriggerHandler(oldProductsMapPass, newProductsMapPass);
        Id jobId = System.enqueueJob(handler);
        System.debug(jobId);
    }

    public ProductsTriggerHandler(Map<Id, Product2> oldProductsMapPass, Map<Id, Product2> newProductsMapPass){
        this.oldProductsMap = oldProductsMapPass;
        this.newProductsMap = newProductsMapPass;
    }

    public void execute(QueueableContext param1) {

        Map<Id, Product2> postponedProducts = new Map<Id,Product2>();
        for (Id key : newProductsMap.keySet()){
            if (oldProductsMap.get(key).Release_Date__c < newProductsMap.get(key).Release_Date__c){
                postponedProducts.put(key,newProductsMap.get(key));
            }
        }

        List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE Product2.Id IN :postponedProducts.keySet()];
        List<Id> orderIds = new List<Id>();
        for (OrderItem item : orderItems){
            orderIds.add(item.OrderId);
        }

        List<Order> orders = [SELECT Related_Case__c FROM Order WHERE Id IN :orderIds AND Status IN ('Pending', 'Confirmed')];

        Case newCase = new Case(Category__c='Release Delay');
        newCase.Description = '';
        for(Product2 product : postponedProducts.values()){
            newCase.Description += product.Name + ' ';
        }

        insert newCase;

        for(Order order : orders){
            order.Related_Case__c = newCase.Id;
        }

        update orders;
    }
}