({


    doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        /*
        if (recordId) {
            
            helper.cargarDatosCartera(component, recordId);
        
        }
        */
        helper.cargarUsuariosPorRoles(component, recordId);
        
    },

    handleOpenCartera : function(component, event, helper) {

        var recordId = component.get("v.recordId");
        var userId = component.find("userId").get("v.value");
        var userLabel = component.find("userId").get("v.label");
        
        
        console.log("handleOpenCartera recordId", recordId);
        console.log("handleOpenCartera value", userId);
        console.log("handleOpenCartera label ", userLabel);

        helper.cargarDatosCartera(component, recordId, userId, userLabel);

    }
})