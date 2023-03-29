@isTest
public class TwilioSmsInvocableTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;

        Contact ctc = new Contact();
        ctc.LastName = 'LastName test';
        ctc.MobilePhone = '5511223344';
        ctc.AccountId = acc.Id;
        insert ctc;

        Registro_Choferes_Pedidos__c choferesPedidos = new Registro_Choferes_Pedidos__c();
        choferesPedidos.Chofer__c = ctc.Id;
        insert choferesPedidos;
    }

    @isTest static void test_method_1() {

        ///
        Registro_Choferes_Pedidos__c regChoferPedido = [SELECT Name, Estatus__c FROM Registro_Choferes_Pedidos__c LIMIT 1];

        List<Registro_Choferes_Pedidos__c> listChoferesPedidos = new List<Registro_Choferes_Pedidos__c>();
        listChoferesPedidos.add(regChoferPedido);

        String body = '{"success":true}';

        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Test.startTest();

        TwilioSmsInvocable.invokableSms(listChoferesPedidos);

        Test.stopTest();

        Registro_Choferes_Pedidos__c regChoferPedidoActualizado = [SELECT Name, Estatus__c FROM Registro_Choferes_Pedidos__c LIMIT 1];
        System.assertEquals(regChoferPedidoActualizado.Estatus__c, 'Pendiente de confirmación');
    }
}