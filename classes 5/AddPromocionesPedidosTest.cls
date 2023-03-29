@isTest
private class AddPromocionesPedidosTest {

    @TestSetup
    static void setUpData(){

        
        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        Account a = new Account(Name = 'Prueba', Estatus_de_cuenta__c = 'Activo');
        insert a;

        Id pricebookId = Test.getStandardPricebookId();

        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true,
            Name = ' Standard Price Book'
        );
        update standardPricebook;

        Order o = new Order(AccountId = a.Id,EffectiveDate = Date.today(),Descuento_general__c = 0.05,Status='Cotización',Pricebook2Id = pricebookId, ID_Externo__c='123456');
        Order o2 = new Order(AccountId = a.Id,EffectiveDate = Date.today(),Descuento_general__c = 0.05,Status='Cotización',Pricebook2Id = pricebookId, ID_Externo__c='987654');
        Order o3 = new Order(AccountId = a.Id,EffectiveDate = Date.today(),Descuento_general__c = 0.05,Status='Cotización',Pricebook2Id = pricebookId, ID_Externo__c='11111');

        List<Order> oList = new List<Order>(); 
        oList.add(o);
        oList.add(o2);
        oList.add(o3);
        insert oList;


        Product2 pBase = new Product2(Name = 'Producto prueba2', ProductCode = '1234562', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1601');
        Product2 pBase2 = new Product2(Name = 'Producto prueba3', ProductCode = '1234561', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1601');
        Product2 pPromo = new Product2(Name = 'Producto prueba', ProductCode = '123456', Kilogramos_unidad__c = 123.0, Codigo_Impuesto__c = 'IVAT1601');
        List<Product2> pList = new List<Product2>(); 
        pList.add(pBase);
        pList.add(pBase2);
        pList.add(pPromo);
        insert pList;

        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Product2Id = pBase.Id;
        pbe1.IsActive = true;
        pbe1.Pricebook2Id = pricebookId;
        pbe1.UnitPrice = 10.00;

        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = pPromo.Id;
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pricebookId;
        pbe2.UnitPrice = 10.00;

        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = pBase2.Id;
        pbe3.IsActive = true;
        pbe3.Pricebook2Id = pricebookId;
        pbe3.UnitPrice = 10.00;

        List<PricebookEntry> pbeList = new List<PricebookEntry>(); 
        pbeList.add(pbe1);
        pbeList.add(pbe2);
        pbeList.add(pbe3);
        insert pbeList;

        //crear promocion del producto 
        Promocion__c promo = new Promocion__c(Cantidad_Disponible_Promocion__c = 1,
                                            Cantidad_Compra_Base__c = 10,
                                            Name = 'promo prueba',
                                            Canal__c = 'AVM (A)',
                                            Producto_base__c = pBase.Id,
                                            Producto_promocion__c = pPromo.Id,
                                            Fecha_Fin__c = Date.today(),
                                            Fecha_Inicio__c = Date.today(),
                                            Clasificaci_n_cliente__c = 'A',
                                            Cantidad_Libre_Promocion__c = 1,
                                            Cantidad_Usada_Producto_Promocion__c = 1
        );
        
        insert promo;
        

        Order externalOrder = new Order(ID_Externo__c = '123456');

        // crear nuevo producto
        OrderItem item = new OrderItem(Order = externalOrder, 
                                        UnitPrice = 9.0,
                                        Quantity = 1200,
                                        PricebookEntryId = pbe1.Id,
                                        Descuento_SAP__c = 12.0
                                    );

        // crear nuevo producto
        OrderItem item2 = new OrderItem(Order = externalOrder, 
                                        UnitPrice = 9.0,
                                        Quantity = 1200,
                                        PricebookEntryId = pbe3.Id,
                                        Descuento_SAP__c = 12.0,

                                        Descuento__c = 100,
                                        Promocion__c = promo.Id
                                    );

        Order externalOrder3 = new Order(ID_Externo__c = '11111');

        // crear nuevo producto
        OrderItem item3 = new OrderItem(Order = externalOrder3, 
                                        UnitPrice = 9.0,
                                        Quantity = 1200,
                                        PricebookEntryId = pbe2.Id,
                                        Descuento_SAP__c = 12.0
                                    );

        List<OrderItem> iList = new List<OrderItem>(); 
        iList.add(item);
        iList.add(item2);
        iList.add(item3);

        insert iList;
       
    }
    static testmethod void addPromociones (){


        Order o1 = [SELECT Id FROM Order WHERE ID_Externo__c = '123456']; 
        Order o2 = [SELECT Id FROM Order WHERE ID_Externo__c = '987654']; 
        Order o3 = [SELECT Id FROM Order WHERE ID_Externo__c = '11111']; 


        Product2 p1 = [SELECT Id FROM Product2 WHERE Name = 'Producto prueba'];   
        Product2 p2 = [SELECT Id FROM Product2 WHERE Name = 'Producto prueba2'];        
     
     
        Promocion__c promo1 = [SELECT Id FROM Promocion__c WHERE Name = 'promo prueba'];

        ApexPages.StandardController sc = new ApexPages.StandardController(o1);
		AddPromocionesPedidosController  obj = new AddPromocionesPedidosController(sc);
        obj.getProductos();
        obj.lstDetallePromocion =  '[{"Cantidad_disponible_promocion":'+ 5 +',"Producto_promocion_id":'+'\"'+ p1.Id +'\"'+',"Promocion_id":'+'\"'+ promo1.Id +'\"'+',"Producto_base_id":'+'\"'+ p2.Id +'\"'+',"Cantidad_usada":100}, {"Promocion_id":'+'\"'+ promo1.Id +'\"'+',"Producto_base_id":'+'\"'+ p2.Id +'\"'+',"Cantidad_usada":1}]';
        obj.addDetallesPromocion();

        ApexPages.StandardController sc3 = new ApexPages.StandardController(o3);
		AddPromocionesPedidosController  obj3 = new AddPromocionesPedidosController(sc3);
        obj3.getProductos();
        obj3.addDetallesPromocion();

       
    }
    

}