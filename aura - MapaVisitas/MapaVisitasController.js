({
    init: function (component, event, helper) {
        
        //inicializar Date Init
        var date = new Date();
        var firstday = $A.localizationService.formatDate(new Date(date.getFullYear(), date.getMonth(), 1), "YYYY-MM-DD");
        var lastday = $A.localizationService.formatDate(new Date(date.getFullYear(), date.getMonth() + 1, 0), "YYYY-MM-DD");
        component.set('v.dateInit',firstday);
        component.set('v.dateFin',lastday);
        
        
        //inicializar Select
        var action = component.get("c.getPickListValuesIntoList");
        action.setCallback(this, function(result){
            var op = result.getReturnValue();
            component.set("v.options",op);
            
        });
        $A.enqueueAction(action);
        
        //inicializar Mapa
        var action = component.get("c.initMap");
        action.setCallback(this, function(response) {
            console.log('response'+response);
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                var obj =response.getReturnValue() ;
                console.log(obj);
                component.set('v.center', {
                    Latitude: '37.790197',
                    Longitude: '-122.396879'
                });
                component.set('v.mapMarkers',obj);
                component.set('v.zoomLevel', 4);
                component.set('v.markersTitle', 'Salesforce locations');
                component.set('v.showFooter', true);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getData: function(component, event, helper){
        //obtener datos del formulario de filtros y validaciones correspondientes.
        var datInSelected = component.get('v.dateInit');
        var datFiSelected = component.get('v.dateFin');
        var opc = component.find("mySelect1").get('v.value');
        var lookupId = component.get("v.lookupId");
        var cond =[0,0,0];
        var msj ="",msjTitle="";
        
        //verificar que un canal sea seleccionado
        (opc == "")? cond[0]=0  : cond[0]=1 ;
        //verificar que la fecha de inicio no sea igual o mayor a la fecha fin
        (datInSelected>=datFiSelected)? cond[1]=0 : cond[1]=1;
        //verificar que se tenga el Id de un responsable
        (lookupId=="" || lookupId== null)? cond[2]=0: cond[2]=1;
        console.log('responsable:  '+lookupId);
        if(cond[0]==0 || cond[1]==0){
            msjTitle="Atención";
            msj="Verifique información.";
            if(cond[0]==0 && cond[1]==1){
                msj="Seleccione canal.";
            }
            if(cond[1]==0 && cond[0]==1){
                msj="Las fechas son incorrectas.";
            }
            helper.showToast('info',msjTitle,msj);
        }else{
            var enlace = parent.document.location.href;
            console.log("enlace----->"+enlace);
            //Renderizar mapa
            var action = component.get("c.getVisitas");
            action.setParams({ 
                "canal": opc,
                "fechIn": datInSelected,
                "fechFin":datFiSelected,
                "idResp": lookupId,
                "URL": enlace
                
            });
            action.setCallback(this, function(response) {
                console.log('response'+response);
                var state = response.getState();
                console.log(state);
                if (state == "SUCCESS") {
                   
                    var obj =response.getReturnValue() ;
                    console.log(obj);
                   
                    if(obj.length > 0){
                        
                        component.set('v.center', {
                            Latitude: '37.790197',
                            Longitude: '-122.396879'
                        });
                        
                        component.set('v.mapMarkers',obj);
                        component.set('v.zoomLevel', 4);
                        component.set('v.markersTitle', 'Salesforce locations');
                        component.set('v.showFooter', true);
                        helper.showToast('success','Mensaje del servidor.','Consulta exitosa.');
                        component.set("v.isOpen", false);
                    }else{
                        helper.showToast('error','No se encontraron resultados.','Ajuste los criterios de búsqueda e intente de nuevo.');
                    }
                    
                }
            });
            $A.enqueueAction(action);  
        }
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
   
})