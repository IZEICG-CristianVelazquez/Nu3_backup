@isTest 
public class ScheduleDailyFacturadoSMSTest {
    
    @isTest public static void runScheduler(){
        
        Account acc = new Account(Name = 'Prueba',
                                  Estatus_de_cuenta__c='Activo',
                                  Base_de_Datos__c ='NU3_AgropecuariaPiedadense_LAGOS',
                                  Tarifa_flete__c = 100.00,
                                  Disponible_para_encuestas__c = true,
                                  Phone = '+527713830985'
                                 );
        insert acc;
        
        
        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        Id pricebookId = Test.getStandardPricebookId();   
        
        Lugar_de_entrega__c lu = new Lugar_de_entrega__c(Name='San joaquin',
                                                         Cliente__c= acc.Id,
                                                         Tipo_de_Unidad__c ='Camioneta',
                                                         Factor__c = 1
                                                        );
        insert lu;
        
        Order o = new Order(AccountId = acc.Id,
                            EffectiveDate = Date.today(),
                            Descuento_general__c = 0.05,
                            Status='Cotización',
                            Pricebook2Id = pricebookId,
                            ID_Externo__c='123456',
                            Admin_Ventas_MP__c = false,
                            Gerente_MP__c = false,
                            Gerente_Alimentos_Balanceados__c = false,
                            Incluye_flete__c = true,
                            Costo_flete__c =100.00,
                            Lugar_de_entrega__c = lu.Id,
                            Factor_flete_SAP__c = 1,
                            Tipo_de_Unidad__c ='Camioneta'
                           );
        insert o;
        
        Encuesta__c enc = new Encuesta__c(Name='test',pregunta__c='test2');
        insert enc;
        
        
        Detalle_de_encuesta__c detEnc = new Detalle_de_encuesta__c();
        detEnc.Account_relacionada__c = acc.ID;
        detEnc.Encuesta__c = enc.Id;
        detEnc.fecha_de_cambio_Status__c =  (Date.today().addDays(-1));
        detEnc.Tel_fono_destino__c = acc.Phone;
       	detEnc.order_Relacionada__c = o.Id;
        detEnc.estatus_de_env_o__c = 'pendiente de enviar';
        insert detEnc;
        
        String body = '{"success":true}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        
        Test.StartTest();
        ScheduleDailyFacturadoSMS sh1 = new ScheduleDailyFacturadoSMS();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    
    }
    
}