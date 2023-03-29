public class TwilioClient {
    
    private static final Integer MX_CODE = 52;
    private static final String ENDPOINT = 'https://api.twilio.com/2010-04-01/Accounts/';
    private Map<String, String> myMap = new Map<String, String>{'Developer' => 'TwilioKeys_Dev', 'Producción' => 'TwilioKeys'};

    
    TwilioClientData__mdt keys;
    Enviroment_configuration__mdt env;
    
    public TwilioClient(){
        
        env  = [SELECT Enviroment__c FROM Enviroment_configuration__mdt WHERE Label = 'Env configuration'];
        String filtro = (myMap.containsKey(ENV.Enviroment__c))? myMap.get(ENV.Enviroment__c) : null;
        keys = [SELECT accountSidTwilio__c,tokenTwilio__c, PhoneNumber__c FROM TwilioClientData__mdt WHERE Label =: filtro ];
        
        System.debug('Enviroment: '+env.Enviroment__c);
        System.debug('keys: '+keys);
    }
    
    public class errorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
    
    
    //[Registro choferes pedidos]
    @future(callout=true)
    public static void updateRCPAsync(String sms,String fromPhNumber){
        
        TwilioClient client = new TwilioClient();
        client.updateRCP(sms,fromPhNumber);
        
    }
    
    public void updateRCP(String sms,String fromPhNumber){
        
        List<Registro_Choferes_Pedidos__c> toUpdate = new List<Registro_Choferes_Pedidos__c>();
        id itemId;
        System.debug('####'+fromPhNumber);
        /// Se Obtiene el celular en Formato a 10 digitos (Twilio regresa el celular a 10 digitos mas codigo del Pais)
        String phone10D = fromPhNumber.substring(fromPhNumber.length() -10,fromPhNumber.length()-1);
        
        for(Registro_Choferes_Pedidos__c item: new registroChoferesPedidosSelector().selectRCPWithRelatedData(phone10D, fromPhNumber)){
            
            System.debug('item encontrado: '+item);
            
            if(sms == 'si'){
                
                item.Estatus__c ='Aceptado';
                
            }else if(sms == 'no'){
                
                item.Estatus__c ='Rechazado';
                
            }
            
            System.debug('Estatus del RCP '+item.Name+' Actualizado:'+item.Estatus__c);
            itemId = item.Id;
            System.debug('Este es el ID del RCP a actualizar: '+itemId);
            System.debug('Este es el estatus actualizado: '+item.Estatus__c);
            toUpdate.add(item);
        }  
        
        update toUpdate;
        
    }
    
     @future(callout=true)
    public static void sendSimpleSMSAsync(String phNumber, String smsBody){
        
        TwilioClient client = new TwilioClient();
        client.sendSMS(TwilioClient.checkFormatNumber(phNumber),smsBody);
    }
    
    @future(callout=true)
    public static void sendSMSAsync(String phNumber, String smsBody, String idChoferPedido){
        
        TwilioClient client = new TwilioClient();
        client.sendSMS( phNumber,smsBody);
        client.updateEstatusConfirmacion(idChoferPedido);
        
    }
    
    public void updateEstatusConfirmacion(String idChoferPedido) {
        
        List<Registro_Choferes_Pedidos__c> listToUpdate = new List<Registro_Choferes_Pedidos__c>();
        Set<Id> setIds = new Set<Id>();
        setIds.add(idChoferPedido);
        
        /// Se obtienen los Registros Chofer Pedido por Id
        for(Registro_Choferes_Pedidos__c item: new registroChoferesPedidosSelector().selectById(setIds)){
            
            item.Estatus__c ='Pendiente de confirmación';
           /*  System.debug('TwilioClient -updateEstatusConfirmacion -Pedido Status: '+item.Pedido__r.Status); */
            System.debug('updateEstatusConfirmacion - RCP Name:  ' + item.Name + ' Estatus:  ' + item.Estatus__c);
            listToUpdate.add(item);
            
        }  
        update listToUpdate;
        
    }  
    
    
    //[Encuestas]
    @future(callout=true)
    public static void updateSurveyDetailsAsync(String sms,String fromPhNumber){
        TwilioClient client = new TwilioClient();
        client.updateSurveyDetails(sms,fromPhNumber);
    }
    
    public void updateSurveyDetails(String sms,String fromPhNumber){
        
        String phone = TwilioClient.checkFormatNumber(fromPhNumber);
        Date yesterday = Date.today().addDays(-1);
        System.debug('phone formated--> '+phone);
        System.debug('yesterday date--> '+yesterday);
        List<Detalle_de_encuesta__c> detEncUp = new List<Detalle_de_encuesta__c>();
        List<Detalle_de_encuesta__c> detEnc = [SELECT id,
                                               Encuesta__c,
                                               order_Relacionada__c,
                                               Account_relacionada__c,
                                               fecha_de_cambio_Status__c,
                                               Tel_fono_destino__c,
                                               respuesta__c
                                               FROM Detalle_de_encuesta__c
                                               WHERE Tel_fono_destino__c  =: phone AND fecha_de_cambio_Status__c =: yesterday
                                               AND estatus_de_env_o__c = 'enviado'];
        
        System.debug('---------detEnc--------\n'+System.JSON.serializePretty(detEnc));
        if(!detEnc.IsEmpty()){
            
            for(Detalle_de_encuesta__c item : detEnc){
                item.respuesta__c = sms;
                item.estatus_de_env_o__c = 'respondido';
                detEncUp.add(item);
                //aquí depende de la respuesta mandamos enlace
                System.debug('RESPONDIDO');
                if(sms == '1' || sms == '2'){
                    
                    List<Network> lstNet = [select id, name from network where name = 'Grupo NU3' Limit 1];
                    
                    String networkURL = (!lstNet.isEmpty()) ? Network.getLoginURL(lstNet.get(0).Id):'';
                    String baseUrl = networkURL.endsWith('/login') ? networkURL.removeEnd('/login') : networkURL;
                    System.debug(baseUrl);
                    
                    if(baseUrl != ''){
                          sendSMS(checkFormatNumber(fromPhNumber),baseUrl+'/DetalleEncuesta?idDetEncuesta='+item.Id);
                    }

                }
                
            }
            
            if(!detEncUp.isEmpty()){
                update detEncUp;
            }
            
        }
    }
    
    @future(callout=true)
    public static void sendSurveyAsync(String phNumber, String smsBody){
        
        TwilioClient client = new TwilioClient();
        client.sendSMS( phNumber,smsBody);   
    }
    
    
    
     
    //[Métodos BASE]
    public HttpRequest makeRequest(String method){
        
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(keys.accountSidTwilio__c+':' +keys.tokenTwilio__c)));
        request.setEndpoint(ENDPOINT+keys.accountSidTwilio__c+'/Messages.json');
        request.setHeader('X-Authy-API-Key', 'n8OEDYzWBPKfMiNJFLc3DRxuZ7zi5Kiq');
        request.setMethod(method);
        
        return request;
        
    }
    
    public httpResponse makeResponse(HttpRequest req){
        
        Http http = new Http();
        HttpResponse response = http.send(req);   
        
        if(response.getStatusCode()==201)
            
            System.debug('SMS Sent Successfully');
        
        else{
            
            System.debug('Error:\n'+(errorResponseWrapper)json.deserialize(response.getBody(),errorResponseWrapper.class));
        
        }
        
        return response;
        
    }
    
    public HttpResponse sendSMS (String phNumber,String smsBody){
        
        HttpRequest req = makeRequest('POST');
        req.setBody('To='+EncodingUtil.urlEncode(phNumber,'UTF-8')
                    +'&From='+EncodingUtil.urlEncode(keys.PhoneNumber__c,'UTF-8')
                    +'&Body='+smsBody);
        httpResponse resp = makeResponse(req);
        return resp;
        
    }
    
    public static String checkFormatNumber(String phone){
        
        if(String.isNotBlank(phone)){
            
            Boolean numeroValido = false;      
            phone =  phone.replaceAll('\\D+','');
            
            if(phone.length() == 10){ 
                
                phone = '+'+MX_CODE+phone;
                
            }else if(phone.length() > 10){
                
                phone = MX_CODE+phone.substring(phone.length() -10);
                
            }
            
            phone = (!phone.contains('+')) ?  '+'+phone : phone;
            numeroValido = (phone.length() == 13 )? true:false;
            phone = (numeroValido)? phone:'';
            
        }else{
            phone = '';
        }

        return phone;
    }
    
    
    
}