@RestResource(urlMapping='/smstwilio/*')
global without sharing class RestServiceTwilioSendSMS {
    @HttpPost
    global static Void doPost(){
        
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('Content-type','text/xml');
  		System.debug('request\n'+System.JSON.serializePretty(req));
        Map<String, String> sms = req.params ;
        String fromPhNumber ;
        String smsBody ;
         
        if (sms.containsKey('From')){
            fromPhNumber = sms.get('From') ;
        } 
        if (sms.containsKey('Body')){
            smsBody = sms.get('Body').toLowerCase();
        }
        System.debug('mensaje recibido--->'+smsBody);
        System.debug('# del mensaje--->'+fromPhNumber);
        
        if(smsBody.isNumeric()){
           TwilioClient.updateSurveyDetailsAsync(smsBody,fromPhNumber);
        }else{
            TwilioClient.updateRCPAsync(smsBody,fromPhNumber);
        }
        
        
        
    } 
}