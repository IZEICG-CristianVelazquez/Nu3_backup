({
    doInit : function(component, event, helper) {

        helper.countAtt(component);
        helper.mostrarPdf(component);
        

    },

    closeQuickAction : function(component, event, helper){

        $A.get("e.force:closeQuickAction").fire();

    },

    guardarPDF : function(component, event, helper){

        helper.savePDF(component);

    },

    recordUpdated: function(component, event) {
        var eventParams = event.getParams();
        console.log(eventParams.changeType);
        if(eventParams.changeType === "CHANGED") {
            console.log("The record was updated");
        } else if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "REMOVED") {
            console.log("The record was removed");
            resultsToast.fire();
        } else if(eventParams.changeType === "ERROR") {
            console.log('Error: ' + component.get("v.error"));
        }
    }

})