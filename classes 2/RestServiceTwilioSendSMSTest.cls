@isTest
public class RestServiceTwilioSendSMSTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;

        Contact ctc = new Contact();
        ctc.LastName = 'LastName test';
        ctc.MobilePhone = '+525511223344';
        ctc.AccountId = acc.Id;
        insert ctc;

        Registro_Choferes_Pedidos__c choferesPedidos = new Registro_Choferes_Pedidos__c();
        choferesPedidos.Chofer__c = ctc.Id;
        choferesPedidos.Estatus__c = 'Pendiente de confirmación';
        insert choferesPedidos;
    }

    @isTest static void RestServiceTwilioSendSMS_Aceptado() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/smstwilio/';
        request.httpMethod = 'GET';
        request.params.put('From', '+525511223344');
        request.params.put('Body', 'si');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        RestServiceTwilioSendSMS.doPost();

        Test.stopTest();

        Registro_Choferes_Pedidos__c choferPedidoAceptado = [SELECT Name, Estatus__c FROM Registro_Choferes_Pedidos__c LIMIT 1];
        
    }

    @isTest static void RestServiceTwilioSendSMS_Rechazado() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/smstwilio/';
        request.httpMethod = 'GET';
        request.params.put('From', '+525511223344');
        request.params.put('Body', 'no');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        RestServiceTwilioSendSMS.doPost();

        Test.stopTest();

        Registro_Choferes_Pedidos__c choferPedidoAceptado = [SELECT Name, Estatus__c FROM Registro_Choferes_Pedidos__c LIMIT 1];
        
    }
    
}