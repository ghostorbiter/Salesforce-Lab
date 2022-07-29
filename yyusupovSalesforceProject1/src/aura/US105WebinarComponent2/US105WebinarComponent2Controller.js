/**
 * Created by yyusupov on 08.07.2022.
 */

({
    handleCancel: function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    handleSubmit: function(cmp, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
//        fields.AccountId = cmp.get("v.recordId");
        cmp.find('myWebinarForm2').submit(fields);
    },

    handleSuccess: function(cmp, event, helper) {
        // Success! Prepare a toast UI message
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Webinar Saved",
            "message": "The new webinar was created."
        });

        // Update the UI: close panel, show toast, refresh account page
        $A.get("e.force:closeQuickAction").fire();
        resultsToast.fire();

        // Reload the view
        let createWebinarEvent = $A.get("e.c:CreateNewWebinarRefreshList");
        createWebinarEvent.fire();
        cmp.find('field').forEach(function(f) {
                    f.reset();
        });
    }
})