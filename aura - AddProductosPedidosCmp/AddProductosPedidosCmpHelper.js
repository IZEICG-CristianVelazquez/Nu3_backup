({
    close : function(component, event, helper){
        
        $A.get("e.force:closeQuickAction").fire()
        console.log('Quick action closed');
    }
})