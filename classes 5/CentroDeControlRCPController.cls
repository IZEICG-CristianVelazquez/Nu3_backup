public class CentroDeControlRCPController {

    public class dataRCP{
        @AuraEnabled public String idRCP;
        @AuraEnabled public String nombre;
        @AuraEnabled public String unidadNegocio;
        @AuraEnabled public String anden;
        @AuraEnabled public String status;
        @AuraEnabled public String horaEstimada;
    }
    
    @AuraEnabled
    public static String  loadData(){
 
        List<dataRCP> lstDataRCP = new List<dataRCP>();
        
        for (Registro_Choferes_Pedidos__c rcp : new RegistroChoferesPedidosSelector().selectToControlRCP()){
            
            dataRCP reg = new dataRCP();
            reg.idRCP = (rcp.Id != null)? rcp.Id:'';
        	reg.nombre = (rcp.Chofer__r.Name != null)? rcp.Chofer__r.Name: '';
            reg.unidadNegocio = (rcp.Unidad_de_negocio__c != null)? rcp.Unidad_de_negocio__c: '';
            reg.anden = (rcp.And_n_Banda__c != null)? rcp.And_n_Banda__c : 'En espera';
            reg.status = (rcp.Pedido__r.Status != null)? rcp.Pedido__r.Status : '';
            reg.horaEstimada = (rcp.Hora_estimada_de_fin_de_carga__c != null)? string.valueof(rcp.Hora_estimada_de_fin_de_carga__c) :'';

            lstDataRCP.add(reg);
            
        }
        
        System.debug(System.JSON.serializePretty(lstDataRCP));
      
        return System.JSON.serializePretty(lstDataRCP);
    }
    
    
}