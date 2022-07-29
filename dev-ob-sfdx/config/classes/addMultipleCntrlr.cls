/**
 * Created by yyusupov on 20.07.2022.
 */

public with sharing class addMultipleCntrlr {
    @AuraEnabled
    public static void addToCart(String productId, String webStoreId, String quantity) {
//        WebCart cart = [SELECT Id, WebStoreId, AccountId FROM WebCart WHERE OwnerId = :userId LIMIT 1];

        ConnectApi.CartItemInput cartItemInput = new ConnectApi.CartItemInput();
        cartItemInput.productId = productId;
        cartItemInput.quantity = quantity;
        cartItemInput.type = ConnectApi.CartItemType.Product;

//        ConnectApi.CommerceCart.addItemToCart(cart.WebStoreId, cart.AccountId, cart.Id, cartItemInput);
        ConnectApi.CommerceCart.addItemToCart(webStoreId, null, 'active', cartItemInput);
    }
}