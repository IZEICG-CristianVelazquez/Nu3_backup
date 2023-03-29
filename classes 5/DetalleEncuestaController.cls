public class DetalleEncuestaController {
	
   
    
    @RemoteAction
    public static void saveSurveyDetail(String inconformidad, ID idDetEncuesta) {
        
        Detalle_de_encuesta__c detEnc;
		
        for(Detalle_de_encuesta__c item :[SELECT id, inconformidadPedido__c
									      FROM Detalle_de_encuesta__c
									      WHERE id =: idDetEncuesta Limit 1]) {
			item.inconformidadPedido__c = inconformidad;
			detEnc = item;
		}

		if(detEnc != null && detEnc.inconformidadPedido__c != '') {
			update detEnc;
		}

	}

}