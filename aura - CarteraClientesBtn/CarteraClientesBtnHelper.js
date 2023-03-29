({
    cargarUsuariosPorRoles : function(component, accountId) {

        var params = {
            "accountId" : accountId
        }

        this.callServer(component, "c.obtenerValoresUsuarios", params, function(response) {

			if (response.getState() === "SUCCESS") {
				
				if (response.getReturnValue()) {
                    
                    console.log("userOptions", JSON.stringify(response.getReturnValue()));
                    component.set("v.userOptions", response.getReturnValue()); 

				}

			} else if (response.getState() === "ERROR") {

				var errors = response.getError();

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

    cargarDatosCartera : function(component, accountId, userId, userLabel) {

        var params = {
            "accountId" : accountId,
            "userId" : userId
        }

        this.callServer(component, "c.obtenerDatosCartera", params, function(response) {

            console.log("handleOpenCartera", response.getState());

			if (response.getState() === "SUCCESS") {
				
				if (response.getReturnValue()) {
                    
                    
                    var usuario = response.getReturnValue()["usuario"];
                    var cliente = response.getReturnValue()["cliente"];
					var slpCode = usuario.ID_SAP__c;
                    var slpName = usuario.Name;
                    var busUnit = usuario.Base_de_datos__c;
                    var cardCode = "Todos";
                    var tipo =  userLabel === "Todos" ?  "1" : "2";

                    if (cliente) {

                        cardCode = cliente.ID_SAP__c;
                            
                    }

                    var params = {
                        "url": '/lightning/cmp/c__CarteraClientes?c__slpCode=' + slpCode + 
                            '&c__slpName=' + slpName + '&c__busUnit=' + busUnit.toUpperCase() + 
                            '&c__cardCode=' + cardCode + '&c__tipo=' + tipo
                    }

                    this.navegarAComponente(params);

				}

			} else if (response.getState() === "ERROR") {

				var errors = response.getError();

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

    navegarAComponente : function (params) {

        var eUrl= $A.get("e.force:navigateToURL");

        eUrl.setParams(params);

        eUrl.fire();

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