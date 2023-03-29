@isTest public class TwilioClientTest {
    
    @testSetup
    static void setupData () {
        
        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;
        
        Contact ctc = new Contact();
        ctc.LastName = 'LastName test';
        ctc.MobilePhone = '+527713830985';
        ctc.AccountId = acc.Id;
        insert ctc;
        
        Registro_Choferes_Pedidos__c choferesPedidos = new Registro_Choferes_Pedidos__c();
        choferesPedidos.Chofer__c = ctc.Id;
        choferesPedidos.Estatus__c = 'Pendiente de confirmación';
        insert choferesPedidos;
    }
    
    @isTest public static void sendSMSTest(){
        
      
        String body = '{"success":true}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Test.startTest();
        TwilioClient cli = new TwilioClient();
        cli.sendSMS('+527713830985','test');
        Test.stopTest();


    }
    
    @isTest public static void sendSMSTest2(){
        
      
        String body = '{"success":true}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        
        TwilioClient cli = new TwilioClient();
		
        Test.startTest();
        TwilioClient.sendSurveyAsync('+527713830985','test');
        
        Registro_Choferes_Pedidos__c rcp = [SELECT Id, Chofer__c, Estatus__c 
                                            FROM Registro_Choferes_Pedidos__c 
                                            WHERE Estatus__c = 'Pendiente de confirmación' LIMIT 1];
        TwilioClient.sendSMSAsync('+527713830985','test', rcp.Id);
        Test.stopTest();

    }
    
    @isTest public static void checkPhoneFormatTest(){
        
        TwilioClient.checkFormatNumber('+527713830985');
        TwilioClient.checkFormatNumber('9997713830985');
        TwilioClient.checkFormatNumber('7713830985');
        
    }
    
    
}