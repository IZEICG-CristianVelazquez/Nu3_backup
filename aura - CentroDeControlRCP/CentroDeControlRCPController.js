({
    init : function(component, event, helper) {
        
        helper.initEmpApi(component);
        helper.subscribe(component,event,helper);
        helper.getData(component);
        window.setInterval(
            $A.getCallback(function() { 
                console.log('requesting Data');
                helper.getData(component);
            }), 60000
        ); 
    }
})