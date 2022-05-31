({
    generatePDFHelper : function(component) {
        var action = component.get('c.generatePDF');
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                component.set('v.accList', response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
})
