@isTest 
public class DetalleEncuestaControllerTest {

    @isTest static void saveSurveyDetailTest(){
        Encuesta__c enc = new Encuesta__c();
        insert enc;
        Detalle_de_encuesta__c detEnc = new  Detalle_de_encuesta__c(Encuesta__c = enc.Id);
        insert detEnc;
        DetalleEncuestaController.saveSurveyDetail('Test',detEnc.ID);
    
    }
    
    
}