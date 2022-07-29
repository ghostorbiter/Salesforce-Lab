/**
 * Created by yyusupov on 08.07.2022.
 */

({
    doInit : function(component, helper) {
            const getWebinars = component.get("c.getWebinars");
            getWebinars.setParams({
                queryLimit: component.get("v.webinarLimit")
            });
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

    changeWebinarStatus : function(component, helper, rowId, changedStatus) {
        let webinarChosenEvent = component.get("c.changeApprovalStatus");
        webinarChosenEvent.setParams({
            'webinarId' : rowId,
            'newStatus' : changedStatus
        });

        webinarChosenEvent.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let initAgain = component.get("c.doInit");
                initAgain.setParams({
                    'component' : component,
                    'helper' : helper
                });

                $A.enqueueAction(initAgain);
            }
            else if (state === "ERROR") {
                console.error('Something went wrong')
            }
        });

        $A.enqueueAction(webinarChosenEvent);
    }
});