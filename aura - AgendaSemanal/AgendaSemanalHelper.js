({
    obtenerColumnas : function () {

        var columns = [
            {label: 'Cliente', fieldName: 'Cliente', type: 'text', sortable: true},
            {label: 'Municipio', fieldName: 'Municipio', type: 'text', sortable: true},
            {label: 'Estado', fieldName: 'Estado', type: 'text', sortable: true},
            {label: 'Indicador de Visita', fieldName: 'IndicadorVisita', type: 'number', sortable: true}
        ];

        return columns;

    },

    obtenerColumnasGuardado : function () {

        var columns = [
            {label: 'Cliente', fieldName: 'Cliente', type: 'text', sortable: true},
            {label: 'Municipio', fieldName: 'Municipio', type: 'text', sortable: true},
            {label: 'Estado', fieldName: 'Estado', type: 'text', sortable: true},
            {label: 'Indicador de Visita', fieldName: 'IndicadorVisita', type: 'number', sortable: true},
            {label: 'Fecha Planeada', fieldName: 'FechaPlaneada', type: 'date-local', sortable: true, editable: true}
        ];

        return columns;

    },

    obtenerDatos : function (component) {

        var action = component.get("c.obtenerCuentas");

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            component.set('v.isLoading', false);

            if (state === "SUCCESS") {
                
                component.set("v.data", response.getReturnValue());
                component.set("v.filteredData", component.get("v.data"));

            }
            else if (state === "INCOMPLETE") {
                // do something
            }

            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);

    },

    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.filteredData");
        var reverse = sortDirection !== 'asc';

        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.filteredData", data);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };

        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },

    resetearVariables : function (component) {

        var arrEmpty = [];
        component.set("v.filteredData", arrEmpty);
        component.find("tablaClientes").set('v.selectedRows', arrEmpty);     
        component.set("v.selectedRowsClone", arrEmpty);

    },

    generar : function (component) {

        //generarVisitas
        var cuentas = component.get("v.selectedRowsClone");

		var params = {
			"JSONCuentas": JSON.stringify(cuentas)
        };
        
        console.log("cuentas", JSON.stringify(cuentas));

		this.callServer(component, "c.generarVisitas", params, function(response) {

			if (response.getState() === "SUCCESS") {
				
				if (response.getReturnValue()) {
					
					this.showToast( "success", "Información", "Se han generado las visitas");

					var result = response.getReturnValue();

					if (result['success']) {

						component.set("v.openAgenda", false);
                        this.resetearVariables(component);

					}

				}

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

	},

    
})