({
    showToast: function(toastType,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type        : toastType,
            message: message,
            mode     : 'dismissable',
            title         : title
        });
        toastEvent.fire();
    },

    createRecord : function (component, event, helper,idVisita) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": idVisita,
        });
        navEvt.fire();
    }
})