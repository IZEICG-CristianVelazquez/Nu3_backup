public class ScheduleDailyFacturadoSMS implements Schedulable, Database.AllowsCallouts  {
    
    private static List<Detalle_de_encuesta__c> lstDetails;
    private static List<Detalle_de_encuesta__c> lstDetailsToUpdate;
    private static List<Encuesta__c> lstSurvey;
    private static final Integer MX_CODE = 52;

    public static void init(){
        
        Date yesterday = Date.today().addDays(-1);
        lstDetails = [SELECT 
                      Account_relacionada__c,
                      Account_relacionada__r.Phone,
                      Account_relacionada__r.Disponible_para_encuestas__c,
                      Encuesta__c,
                      fecha_de_cambio_Status__c,
                      estatus_de_env_o__c,
                      order_Relacionada__c 
                      FROM Detalle_de_encuesta__c
                      WHERE fecha_de_cambio_Status__c =: yesterday 
                      AND estatus_de_env_o__c ='pendiente de enviar'
                      AND Account_relacionada__r.Phone != '' 
                      AND Account_relacionada__r.Disponible_para_encuestas__c = true];    
        
        if(!lstDetails.isEmpty()){
            
            lstSurvey = [SELECT id, pregunta__c FROM Encuesta__c WHERE Id =: lstDetails.get(0).Encuesta__c];
        
        }
        
    }
    
    public void execute (SchedulableContext sc) {    
      
        processScheduler();
    
    }
    
   
    private static void processScheduler (){
    
        try{
            init();
            String phone;
            String body = (lstSurvey != null && !lstSurvey.isEmpty()) ? lstSurvey.get(0).pregunta__c : 'Del 1 a 5 siendo 5 MAX ¿como evalua su ultimo pedido en Grupo nu3?';
            
            lstDetailsToUpdate = new List<Detalle_de_encuesta__c>();
            for(Detalle_de_encuesta__c item : lstDetails){
                
                phone = String.valueOf(item.Account_relacionada__r.phone);  
                
                if(TwilioClient.checkFormatNumber(phone).length() == 13 ){
                    
                    TwilioClient.sendSurveyAsync(phone,body);
                    item.estatus_de_env_o__c = 'enviado';
                    lstDetailsToUpdate.add(item);
    
                }
     
            }
            update lstDetailsToUpdate;
        } catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

        
    }
    
}