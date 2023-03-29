@isTest public class CentroDeControlRCPControllerTest {
    
    
    @testSetup
    static void setupData () {
        
        Id pricebookId = Test.getStandardPricebookId();   
        
        Account acc = new Account(Name = 'Prueba',
                                  Estatus_de_cuenta__c='Activo',
                                  Base_de_Datos__c ='NU3_AgropecuariaPiedadense_LAGOS',
                                  Tarifa_flete__c = 100.00
                                 );
        insert acc;
        
        Contact ctc = new Contact();
        ctc.FirstName = 'test';
        ctc.LastName = 'LastName test';
        ctc.MobilePhone = '5511223344';
        ctc.AccountId = acc.Id;
        insert ctc;
        
        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        List <Account> listAccount = [SELECT id FROM Account WHERE Name = 'Prueba' Limit 1];
        
        Lugar_de_entrega__c lu = new Lugar_de_entrega__c(Name='San joaquin',
                                                         Cliente__c= listAccount.get(0).Id,
                                                         Tipo_de_Unidad__c ='Camioneta',
                                                         Factor__c = 1
                                                        );
        insert lu;
        
        List<Lugar_de_entrega__c> lug = [SELECT Id FROM Lugar_de_entrega__c WHERE Name='San joaquin' Limit 1];
        
        Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Pedido').getRecordTypeId();
        
        Order o = new Order(Name = 'Test',
                            AccountId = listAccount.get(0).Id,
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
                            Lugar_de_entrega__c = lug.get(0).Id,
                            Factor_flete_SAP__c = 1,
                            Tipo_de_Unidad__c ='Camioneta',
                            Banda_asignada__c = '',
                            And_n_asignado__c = ''
                            
                           );
        
        insert o;
        
        
        Product2 p2 = new Product2(Name = 'Producto prueba', ProductCode = '123456', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1601',Grupo_de_art_culos__c='101');
        insert p2;
        
        Product2 p2_1 = new Product2(Name = 'Producto prueba 2', ProductCode = '123455', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1602',Grupo_de_art_culos__c='101');
        insert p2_1;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        pbe.Pricebook2Id = pricebookId;
        pbe.UnitPrice = 10.00;
        insert pbe;
        
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = p2_1.Id;
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pricebookId;
        pbe2.UnitPrice = 10.00;
        insert pbe2;
        
        Pricebook2 pb2 = new Pricebook2(Id= pbe.Pricebook2Id);
        pb2.IsActive = true;
        update pb2; 
        
        List <OrderItem> items = new OrderItem[]{
            new OrderItem(OrderId = o.Id,
                          UnitPrice = 9.0,
                          Quantity = 12,
                          Product2Id = pbe.Product2Id, 
                          PricebookEntryId = pbe.Id,
                          Descuento_SAP__c = 12.0,
                          Grupo_de_art_culos_del_producto_del__c = '101'
                         ),
                new OrderItem(OrderId = o.Id, 
                              UnitPrice = 10.0,
                              Quantity = 11,
                              Product2Id = pbe2.Product2Id, 
                              PricebookEntryId = pbe2.Id,
                              Descuento_SAP__c = 12.0,
                              Grupo_de_art_culos_del_producto_del__c = '109'
                             )
                };
                    
                    insert items;
        
        o.Status = 'Capturado en SAP';
        update o;
        
        System.debug('Order: '+o);
        System.debug('Order Items: '+items);
        
        String body = '{"success":true}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        test.startTest();
        
        List<Order> lstOrder = [SELECT Id FROM Order WHERE  Status='Capturado en SAP' Limit 1];
  
        if(!lstOrder.isEmpty()){
            
            Registro_Choferes_Pedidos__c choferesPedidos = new Registro_Choferes_Pedidos__c();
            choferesPedidos.Chofer__c = ctc.Id;
            choferesPedidos.Estatus__c = 'Pendiente de confirmación';
            choferesPedidos.Unidad_de_negocio__c = 'GrandPet';
            choferesPedidos.Pedido__c = lstOrder.get(0).Id;        
            
            insert choferesPedidos;
        }
        
        test.stopTest();
        
    }
    
    @isTest public static void loadDataTest(){
        
        CentroDeControlRCPController.loadData();
    }
    
}