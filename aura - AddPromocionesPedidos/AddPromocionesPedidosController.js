({
    doInit : function(component, event, helper) {

        var recordId = component.get("v.recordId");
        var url = '/apex/AddPromocionesPedidos?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();

    }
})