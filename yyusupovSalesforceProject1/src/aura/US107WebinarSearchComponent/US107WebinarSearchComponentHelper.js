/**
 * Created by yyusupov on 11.07.2022.
 */

({
    doInit : function(component, helper) {
        const getWebinars = component.get("c.getWebinars");
        getWebinars.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                component.set("v.webinars", response.getReturnValue());
            }
            else {
                console.error('Something went wrong');
            }
        });
        $A.enqueueAction(getWebinars);
    },

    registerWebinar : function(component, helper, row){
        let webinarChosenEvent = component.get("c.registerForWebinar");
        webinarChosenEvent.setParams({
                'webinarId' : row.Id
        });

        webinarChosenEvent.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success');
            }
            else if (state === "ERROR") {
                console.error('Something went wrong')
            }
        });

        $A.enqueueAction(webinarChosenEvent);
    },

    searchByType : function (component, helper, type){
        let searchResT = component.get("c.getWebinarsByType");
        searchResT.setParams({
                'type' : type
        });

        searchResT.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.webinars", response.getReturnValue());
            }
            else if (state === "ERROR") {
                console.error('Something went wrong')
            }
        });

        $A.enqueueAction(searchResT);
    },

    searchByStatus : function (component, helper, givenStatus){
         let searchRes = component.get("c.getWebinarsByStatus");
         searchRes.setParams({
                 'status' : String(givenStatus)
             });

         searchRes.setCallback(this, function(response) {
             const state = response.getState();
             if (state === "SUCCESS") {
                 component.set("v.webinars", response.getReturnValue());
             }
             else if (state === "ERROR") {
                 console.error('Something went wrong')
             }
         });

         $A.enqueueAction(searchRes);
     }
});