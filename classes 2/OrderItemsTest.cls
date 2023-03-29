@isTest
public with sharing class OrderItemsTest {
   
    @isTest
    static void testLugar_de_entregaNotNull(){
        
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        Id pricebookId = Test.getStandardPricebookId();   

        Account a = new Account(Name = 'Prueba',
                                Estatus_de_cuenta__c='Activo',
                                Base_de_Datos__c ='NU3_AgropecuariaPiedadense_LAGOS',
                                Tarifa_flete__c = 100.00
                               );
        insert a;
        List <Account> listAccount = [SELECT id FROM Account WHERE Name = 'Prueba' Limit 1];
        Lugar_de_entrega__c lu = new Lugar_de_entrega__c(Name='San joaquin',
                                                         Cliente__c= listAccount.get(0).Id,
                                                         Tipo_de_Unidad__c ='Camioneta',
                                                         Factor__c = 1
                                                        );
        insert lu;
        
        List<Lugar_de_entrega__c> lug = [SELECT Id FROM Lugar_de_entrega__c WHERE Name='San joaquin' Limit 1];
        
        Order o = new Order(AccountId = listAccount.get(0).Id,
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

        ///
        Product2 p2_1 = new Product2(Name = 'Producto prueba 2', ProductCode = '123455', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1602',Grupo_de_art_culos__c='101');
        insert p2_1;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        pbe.Pricebook2Id = pricebookId;
        pbe.UnitPrice = 10.00;
        insert pbe;

        ///
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = p2_1.Id;
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pricebookId;
        pbe2.UnitPrice = 10.00;
        insert pbe2;
        
        Pricebook2 pb2 = new Pricebook2(Id= pbe.Pricebook2Id);
        pb2.IsActive = true;
        update pb2; 
        
        Decimal price = 10.0;
        Decimal kilos = 5.0;
        Decimal disc = 10.0;
        
        Order externalOrder = new Order(ID_Externo__c = '123456');
        
        // Lista de OrderItems 
        List <OrderItem> items = new OrderItem[]{
            new OrderItem(Order = externalOrder, 
                          UnitPrice = 9.0,
                          Quantity = 12,
                          Product2Id = pbe.Product2Id, 
                          PricebookEntryId = pbe.Id,
                          Descuento_SAP__c = 12.0,
                          Grupo_de_art_culos_del_producto_del__c = '101'
                         ),
                new OrderItem(Order = externalOrder, 
                              UnitPrice = 10.0,
                              Quantity = 11,
                              Product2Id = pbe2.Product2Id, 
                              PricebookEntryId = pbe2.Id,
                              Descuento_SAP__c = 12.0,
                              Grupo_de_art_culos_del_producto_del__c = '109'
                             )
                };
                    
                    insert items;
        
		Test.startTest();
        System.assertEquals(o.Admin_Ventas_MP__c,false);
        System.assertEquals(o.Gerente_MP__c,false);
        System.assertEquals(o.Gerente_Alimentos_Balanceados__c,false);
        Test.stopTest();        
        
    }
    
    @isTest
    static void testLugar_de_entregaNull(){
        
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId());
        
        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        Id pricebookId = Test.getStandardPricebookId();   

        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        Account a = new Account(Name = 'Prueba',
                                Estatus_de_cuenta__c='Activo',
                                Base_de_Datos__c ='NU3_AgropecuariaPiedadense_LAGOS',
                                Tarifa_flete__c = 100.00
                               );
        insert a;
        List <Account> listAccount = [SELECT id FROM Account WHERE Name = 'Prueba' Limit 1];
      
        Order o = new Order(AccountId = listAccount.get(0).Id,
                            EffectiveDate = Date.today(),
                            Descuento_general__c = 0.05,
                            Status='Cotización',
                            Pricebook2Id = pricebookId,
                            ID_Externo__c='123456',
                            Admin_Ventas_MP__c = false,
                            Gerente_MP__c = false,
                            Gerente_Alimentos_Balanceados__c = false,
                            Gerente_GrandPet__c = false,
                            Agente_Ventas_INPRO__c = false,
                            Gerente_INPRO__c = true,
                            Boutique__c = false,
                            Gerente_AquaNU3__c	= false
                           );
        insert o;
        
        Product2 p2 = new Product2(Name = 'Producto prueba', ProductCode = '123456', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1601');
        insert p2;

        ///
        Product2 p2_2 = new Product2(Name = 'Producto prueba 2', ProductCode = '123452', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1602',Grupo_de_art_culos__c='101');
        insert p2_2;

        Product2 p2_3 = new Product2(Name = 'Producto prueba 3', ProductCode = '123453', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1603',Grupo_de_art_culos__c='101');
        insert p2_3;

        Product2 p2_4 = new Product2(Name = 'Producto prueba 4', ProductCode = '123454', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1604',Grupo_de_art_culos__c='101');
        insert p2_4;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        pbe.Pricebook2Id = pricebookId;
        pbe.UnitPrice = 10.00;
        insert pbe;

        ///
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = p2_2.Id;
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pricebookId;
        pbe2.UnitPrice = 10.00;
        insert pbe2;

        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = p2_3.Id;
        pbe3.IsActive = true;
        pbe3.Pricebook2Id = pricebookId;
        pbe3.UnitPrice = 10.00;
        insert pbe3;

        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = p2_4.Id;
        pbe4.IsActive = true;
        pbe4.Pricebook2Id = pricebookId;
        pbe4.UnitPrice = 10.00;
        insert pbe4;
        
        Pricebook2 pb2 = new Pricebook2(Id= pbe.Pricebook2Id);
        pb2.IsActive = true;
        update pb2; 
        
        Decimal price = 10.0;
        Decimal kilos = 5.0;
        Decimal disc = 10.0;
        
        Order externalOrder = new Order(ID_Externo__c = '123456');
        
        // Lista de OrderItems 
        List <OrderItem> items = new OrderItem[]{
            new OrderItem(Order = externalOrder, 
                          UnitPrice = 9.0,
                          Quantity = 12,
                          Product2Id = pbe.Product2Id, 
                          PricebookEntryId = pbe.Id,
                          Descuento_SAP__c = 12.0,
                          Grupo_de_art_culos_del_producto_del__c = '110'
                         ),
                new OrderItem(Order = externalOrder, 
                              UnitPrice = 10.0,
                              Quantity = 11,
                              Product2Id = pbe2.Product2Id, 
                              PricebookEntryId = pbe2.Id,
                              Descuento_SAP__c = 12.0,
                              Grupo_de_art_culos_del_producto_del__c = '116'
                             ),
                  new OrderItem(Order = externalOrder, 
                          UnitPrice = 9.0,
                          Quantity = 12,
                          Product2Id = pbe3.Product2Id, 
                          PricebookEntryId = pbe3.Id,
                          Descuento_SAP__c = 12.0,
                          Grupo_de_art_culos_del_producto_del__c = '118'
                         ),
                new OrderItem(Order = externalOrder, 
                              UnitPrice = 10.0,
                              Quantity = 11,
                              Product2Id = pbe4.Product2Id, 
                              PricebookEntryId = pbe4.Id,
                              Descuento_SAP__c = 12.0,
                              Grupo_de_art_culos_del_producto_del__c = '122'
                            )            
                };
                    
                    insert items;
        
		Test.startTest();
        System.assertEquals(o.Admin_Ventas_MP__c,false);
        System.assertEquals(o.Gerente_MP__c,false);
        System.assertEquals(o.Gerente_Alimentos_Balanceados__c,false);
        Test.stopTest();        
        
    }
    
}