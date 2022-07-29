/**
 * Created by yyusupov on 11.07.2022.
 */

({
    doInit : function(component, event, helper) {
            component.set("v.columns", [
              {'label' : 'Name', 'fieldName': 'Name', 'type': 'text'},
              {'label' : 'Type', 'fieldName': 'Type__c', 'type' : 'text'},
              {'label' : 'Status', 'fieldName': 'Status__c', 'type': 'text'},
              {'label' : 'Approval Status', 'fieldName': 'Approval_Status__c', 'type': 'text'},
              {'label' : 'Cost', 'fieldName': 'Cost__c', 'type': 'number'},
              {type:  'button', typeAttributes:
                    {
                      label: 'Register',
                      name: 'registerWebinar',
                      title: 'registerWebinar',
                      value: 'test',
                      disabled: false
                    }
                }
            ]);

            helper.doInit(component, helper);
        },

        onRowActions: function (cmp, event, helper) {
            var action = event.getParam('action');
            var row = event.getParam('row');
            switch (action.name) {
                case 'registerWebinar':
                    helper.registerWebinar(cmp, helper, row);
                    break;
            }
        },

        search : function(cmp, event, helper) {
            var searchType = cmp.find("filterType").get("v.value");
            var searchText = cmp.find("filterText").get("v.value");

            switch(searchType){
                case "type":
                    helper.searchByType(cmp, helper, searchText);
                    break;
                case "status":
                    helper.searchByStatus(cmp, helper, searchText);
                    break;
            }
        }
});