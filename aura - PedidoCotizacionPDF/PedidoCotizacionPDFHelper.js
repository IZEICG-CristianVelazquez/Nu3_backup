({
    mostrarPdf : function (component) {
        var apexMethod = component.get('c.getPDFData');
        var recordId = component.get("v.recordId");
        var URL = "/apex/PedidoCotizacionPDF?Id=" + recordId;
        
        apexMethod.setParams({
            "pdfURL" : URL
        });
        
        apexMethod.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {

                var pdfData = response.getReturnValue();
                component.set('v.pdfData',pdfData);

                $A.createComponent(
                    "c:pdfViewer",
                    {
                        "pdfData": pdfData
                    },
                    function(pdfViewer, status, errorMessage){
                        console.log(status);
                        if (status === "SUCCESS") {
                        var pdfContainer = component.get("v.pdfContainer");
                        pdfContainer.push(pdfViewer);
                        component.set("v.pdfContainer", pdfContainer);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            throw new Error("No response from server or client is offline.");
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            throw new Error("Error: " + errorMessage);
                        }
                    }
               );
                
            } else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(apexMethod);
    },

    savePDF : function(component){

        var action = component.get('c.savePDF');
        var recordId = component.get("v.recordId");
        var name = component.get("v.simpleRecord.OrderNumber");
        var URL = "/apex/PedidoCotizacionPDF?Id=" + recordId;

        action.setParams({
            "recordId" : recordId,
            "namePedido" : name,
            "pdfURL" : URL
        });

        action.setCallback(this, function(response){

            var state = response.getState();
            console.log("guardarPDF");
            console.log(state);

            if(state === "SUCCESS"){

                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();

            }

        });

        $A.enqueueAction(action);

    },

    countAtt : function(component){

        var action = component.get('c.countAtt');
        var recordId = component.get("v.recordId");
        var name = component.get("v.simpleRecord.OrderNumber") + '.pdf';

        action.setParams({
            "recordId" : recordId,
            "namePedido" : name
        });

        action.setCallback(this, function(response){

            var state = response.getState();

            console.log(response.getReturnValue());
            if(state === "SUCCESS"){

                component.set("v.habilitar",response.getReturnValue());

            }

        });

        $A.enqueueAction(action);

    }
})