({
    doInit : function(component, event, helper) {

        helper.close(component, event, helper);
        
        var recordId = component.get("v.recordId");
        var url = '/apex/AddProductosPedidos?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url": url
        });
        
        urlEvent.fire();
        
        
    }
})