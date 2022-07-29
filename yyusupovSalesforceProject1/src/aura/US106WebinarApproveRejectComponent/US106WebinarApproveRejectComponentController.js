/**
 * Created by yyusupov on 08.07.2022.
 */

({
    doInit : function(component, event, helper) {
        const actions = [
            {label: 'Approve', name: 'approveWebinar'},
            {label: 'Reject', name: 'rejectWebinar'}
        ];
        component.set("v.columns", [
          {'label' : 'Name', 'fieldName': 'Name', 'type': 'text'},
          {'label' : 'Type', 'fieldName': 'Type__c', 'type' : 'text'},
          {'label' : 'Status', 'fieldName': 'Status__c', 'type': 'text'},
          {'label' : 'Approval_Status', 'fieldName': 'Approval_Status__c', 'type': 'text'},
          {'label' : 'Cost', 'fieldName': 'Cost__c', 'type': 'number'},
          {type: 'action', typeAttributes: {rowActions: actions}}
        ]);

        helper.doInit(component, helper);
    },

    onRowActions : function(component, event, helper) {
            var action = event.getParam('action');
            var row = event.getParam('row');
            component.set("v.webinarId", row.Id);

            switch (action.name) {
                case 'approveWebinar':
                    helper.changeWebinarStatus(component, helper, row.Id, 'Approved');
                    break;
                case 'rejectWebinar':
                    let open = component.get("c.openModel");
                    open.setParams({
                        'component' : component,
                        'event' : event,
                        'helper' : helper
                    });

                    $A.enqueueAction(open);

                    helper.changeWebinarStatus(component, helper, row.Id, 'Rejected');
                    break;
            }
        },

        openModel: function(component, event, helper) {
              component.set("v.isModalOpen", true);
           },

        closeModel: function(component, event, helper) {
          var rejectReasonTextArea = component.find("rejectReasonText").get("v.value");
          if (rejectReasonTextArea.length > 0){
              component.set("v.isModalOpen", false);
          }
        },

        submitDetails: function(component, event, helper) {
           var rejectReasonTextArea = component.find("rejectReasonText").get("v.value");
           var webinarId = component.get("v.webinarId");

           var assign = component.get("c.assignRejectReason");
           assign.setParams({
               'webinarId' : webinarId,
               'reason' : String(rejectReasonTextArea)
           })

           $A.enqueueAction(assign);
           component.set("v.isModalOpen", false);
        }

});

///ask Jakub