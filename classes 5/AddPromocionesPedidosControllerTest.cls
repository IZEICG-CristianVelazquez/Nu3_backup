@IsTest public with sharing class AddPromocionesPedidosControllerTest {
    
    @IsTest public static void Test1() {
        Account a = new Account(Name = 'Prueba',Estatus_de_cuenta__c='Activo');
        insert a;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Order o = new Order(AccountId = a.Id,EffectiveDate = Date.today(),Descuento_general__c = 0.05,Descuento_por_forma_de_pago__c = 0.5,Status='Cotización',Pricebook2Id = pricebookId);
        insert o;
        
        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        List<Product2> prod2List = new Product2[]{
            new Product2(Name='Prueba1',ProductCode='050796'),
                new Product2(Name='Prueba2',ProductCode='281198'),
                new Product2(Name='Prueba2',ProductCode='281198')
                };
                    insert prod2List;
        
        List<PricebookEntry> pbeList = new PricebookEntry[]{
            new PricebookEntry(Product2Id = prod2List.get(0).Id,IsActive = true,Pricebook2Id = pricebookId,UnitPrice = 10.00),
                new PricebookEntry(Product2Id = prod2List.get(1).Id,IsActive = true,Pricebook2Id = pricebookId,UnitPrice = 10.00),  
                new PricebookEntry(Product2Id = prod2List.get(2).Id,IsActive = true,Pricebook2Id = pricebookId,UnitPrice = 10.00)  
                };
                    insert pbeList;
        
        Pricebook2 pb2 = new Pricebook2(Id= pbeList.get(0).Pricebook2Id);
        pb2.IsActive = true;
        update pb2;
        
        Date fInicio = Date.newInstance(2019, 10, 1);
        Date fFin = Date.newInstance(2019, 10, 28);
        
        Promocion__c pro = new Promocion__c(
            Name='Promo Oxxo',
            Fecha_Inicio__c = fInicio,
            Fecha_Fin__c = fFin,
            Canal__c ='AVM (A)',
            Producto_base__c=prod2List.get(1).Id,
            Producto_promocion__c=prod2List.get(2).Id,
            Cantidad_Compra_Base__c = 1,
            Cantidad_Disponible_Promocion__c = 1,
            Clasificaci_n_cliente__c = 'A',
            Cantidad_Libre_Promocion__c = 1,
            Cantidad_Usada_Producto_Promocion__c = 1
        );
        insert pro;  
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        AddPromocionesPedidosController  obj = new AddPromocionesPedidosController(sc);
        
        obj.addDetallesPromocion();
        obj.getProductosPromocion();
        obj.getProductosOrderItem();
        obj.getAllProductosOrderItem();
        obj.getProductosWithProductPromotion();
        obj.getProductos();
        obj.getIdProductosPedido();
        obj.crearOrderItem(pro.Producto_base__c,5, pro.id, 3,pro.Producto_promocion__c);
        
    }   
}