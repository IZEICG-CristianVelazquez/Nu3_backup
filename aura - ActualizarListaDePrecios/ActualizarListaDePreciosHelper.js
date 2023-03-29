({
    actualizar : function(component) {

		var params = {

			"listaId": component.get("v.recordId")

		}

        this.callServer(component, "c.actualizarLista", params, function(response) {

			if (response.getState() === "SUCCESS") {
					
				this.showToast( "success", "Información", "Se esta procesando la actualización");

			} else if (response.getState() === "ERROR") {

				var errors = response.getError();

				console.log("errors " + JSON.stringify(errors));

                if (errors) {

                	if (errors[0] && errors[0].pageErrors && errors[0].pageErrors.length) {

                        this.showToast( "error", "Información", errors[0].pageErrors[0].message);

                        console.log("Error message: " + errors[0].pageErrors[0].message);

                    }

                    if (errors[0] && errors[0].fieldErrors && errors[0].fieldErrors.length) {

                        this.showToast( "error", "Información", errors[0].fieldErrors[0]);


                    }

                } else {

                    console.log("Unknown error");

                }

			}

		});


        
        

    },

    showToast : function(type, title, message) {

	    var toastEvent = $A.get("e.force:showToast");
	    toastEvent.setParams({
	        "type": type,
	        "title": title,
	        "message": message
	    });
	    toastEvent.fire();
    },

    callServer : function (component, name, params, callback) {

		var action = component.get(name);

		if (params) {
			action.setParams(params);
		}

		action.setCallback(this, callback);
	
		$A.enqueueAction(action);

	}
})