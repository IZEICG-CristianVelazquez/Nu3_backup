public class TwilioSmsInvocable {
    
    public static String getDate(){
        //Obtener fecha GMT
        DateTime dt = Date.today();
        Date gmtDate = dt.dateGmt();
        Time gmtTime = dt.timeGmt();
        DateTime newDateTime1 = DateTime.newInstance(gmtDate, gmtTime);
        String sFormattedDate = newDateTime1.format('dd-MM-yyyy');
        return sFormattedDate;
    }
    
    public static String getTime(){
        //Obtener hora local
        Datetime NOW  = system.now();
        NOW = NOW.addMinutes(30);
        String min = String.valueOf(NOW.minute());
        String hour = String.valueOf(NOW.Hour());
        String c1=  (hour.length() < 2 )?'0':'';
        String c2 = (min.length() < 2 )?':0':':';
        
        String sFormattedTime = c1+NOW.HOUR()+c2+NOW.MINUTE();	
        return sFormattedTime;
    }
    
    @InvocableMethod(label='Send sms' description='Sending sms to a phone number of a driver')
    public static void invokableSms( List<Registro_Choferes_Pedidos__c> reg) {
        
        Map<Id,Registro_Choferes_Pedidos__c> idRCP = new Map<Id,Registro_Choferes_Pedidos__c>(reg);
        String toNumber = '+527713830985';
        String dt = TwilioSmsInvocable.getDate();
        
        //Obtener datos de registro de Chofer-Pedido & envío sms
        for(Registro_Choferes_Pedidos__c item: new registroChoferesPedidosSelector().selectByIdWithRelatedData(idRCP.keySet())){
            
            String hr = TwilioSmsInvocable.getTime();
            
            String body='Pedido asignado: '
                +item.Pedido__r.Referencia_SAP__c+'. Destino: '
                +item.Lugar_de_entrega__c+'. Peso: '
                +item.Pedido__r.Kilogramos_totales_Rollup__c +'kg. Responde si o no hasta las '
                +hr+' hrs del '+dt;
            System.debug('body'+body);
            System.debug('Télefono al que se enviará el mensaje--->'+item.Chofer__r.MobilePhone);
            System.debug('Télefono al que se enviará el mensaje formateado--->'+item.Chofer__r.MobilePhone);  
            ///
            System.debug('SEND SMS - item:  ' + item);
            TwilioClient.sendSMSAsync(item.Chofer__r.MobilePhone,body, item.Id);
            
        }        
    }
}