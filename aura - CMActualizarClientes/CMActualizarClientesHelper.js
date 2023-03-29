({
    actualizarClientes : function(component,event) {

        var apexMethod = component.get('c.actualizaClientes');	
        apexMethod.setParams({});
        
        apexMethod.setCallback(this, function(response) {
            var state = response.getState();
            alert('Los clientes se están actualizando.');

            if (state == 'SUCCESS') {
                var data = response.getReturnValue();
            } else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(apexMethod);

    }
})