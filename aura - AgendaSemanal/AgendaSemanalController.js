({
    init : function(component, event, helper) {

        
        component.set("v.columns", helper.obtenerColumnas());
        component.set("v.columnsGuardado", helper.obtenerColumnasGuardado());
        
        
    },

    handleCloseAgenda : function (component, event, helper) {

        component.set("v.openAgenda", false);
        helper.resetearVariables(component);

    },

    handleOpenAgenda : function (component, event, helper) {

        component.set('v.isLoading', true);
        helper.obtenerDatos(component)
        component.set("v.openAgenda", true);


    },

    updateRowSelection: function (cmp, event) {

        var selectedRows = event.getParam('selectedRows');
        var clonedRows = cmp.get("v.selectedRowsClone");

        if (clonedRows === undefined || clonedRows.length == 0) {

            clonedRows = selectedRows;

        }

        var concatRows = clonedRows.concat(selectedRows);
        var uniqueRows = Array.from(new Set(concatRows))

        cmp.set('v.selectedRows', uniqueRows);

    
    },

    updateSeleccionados : function (component, event) {

        component.set('v.selectedRowsClone', component.get("v.selectedRows"));
        
        var seleccionados = component.get("v.selectedRowsClone");
        var disponibles = component.get('v.filteredData');
        var quitarSeleccionados = disponibles.filter( function( el ) { return !seleccionados.includes( el );} );
        
        component.set('v.filteredData', quitarSeleccionados);
        component.find("tablaClientes").set('v.selectedRows', null);     

    },

    filter : function(component, event, helper) {
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data, regex;

        if (term) {

            try {
                regex = new RegExp(term, "i");
                // filter checks each row, constructs new array where function returns true
    
                results = data.filter(row=>regex.test(row.Cliente) || regex.test(row.Municipio));
            } catch(e) {
                // invalid regex, use full list
    
                console.log('e', e);
            }
            component.set("v.filteredData", results);

        } else {

            component.set('v.selectedRowsClone', component.get("v.selectedRows"));
        
            var seleccionados = component.get("v.selectedRowsClone");
            var disponibles = component.get('v.data');
            var quitarSeleccionados = disponibles.filter( function( el ) { return !seleccionados.includes( el );} );
            
            component.set('v.filteredData', quitarSeleccionados);
            
            component.find("tablaClientes").set('v.selectedRows', null); 

        }

        
    },

    updateColumnSorting : function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }, 0);
    },

    handleGenerarAgenda : function (component, event, helper) {

        var draftValues = component.find('tablaGuardado').get("v.draftValues");
        console.log("draftValues", draftValues);

        helper.generar(component);

    },

    chandleCellChange : function (component, event, helper) {

        var draftValues = event.getParam('draftValues');
        console.log("draftValues", JSON.stringify(draftValues));

        if (draftValues && draftValues.length) {

            var selectedRowsClone = component.get("v.selectedRowsClone");
            console.log("selectedRowsClone", selectedRowsClone);

            for (var i = 0; i < selectedRowsClone.length; i++) {

                console.log("selectedRowsClone[i].Id", selectedRowsClone[i].Id);

                if (selectedRowsClone[i].Id === draftValues[0].Id ) {

                    selectedRowsClone[i].FechaPlaneada = draftValues[0].FechaPlaneada;

                }

            }

            component.set("v.selectedRowsClone", selectedRowsClone);

        }

    }

    
})