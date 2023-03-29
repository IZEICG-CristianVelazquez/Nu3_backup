@isTest
private with sharing class SchedulerObtenerPedidosFacturadosTest {
    //Exp CRON
    static String CRON_EXP = '0 0 0 15 3 ? *';
    
    @testSetup 
    private static void setupData () {
        //Aqui se ingresan los productos de prueba -->Campos requeridos:  Name,ProductCode,Kilogramos_unidad__c
        //El último campo se utiliza para el cálculo de UnitPrice en el método crearProducto de la clase ScheduleObtenerPedidosFacturados.
        List <Product2> prod2List = new Product2 []{
            	new Product2(Name = 'Producto prueba', ProductCode = '21720',Kilogramos_unidad__c=10.00),
                new Product2(Name = 'Producto prueba2', ProductCode = '21160',Kilogramos_unidad__c=15.00),
                new Product2(Name = 'Producto prueba3', ProductCode = '01s54000001UiJQAA0',Kilogramos_unidad__c=20.00),
                new Product2(Name = 'Producto prueba4', ProductCode = '050796',Kilogramos_unidad__c=30.00)
        };
       insert prod2List;
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;
       
        List<Pricebook2> PriceBook2List = new Pricebook2[]{
            new Pricebook2(Name='Custom Pricebook', isActive=true),
                new Pricebook2(Name='Custom Pricebook2', isActive=true),
                new Pricebook2(Name='Custom Pricebook3', isActive=true),
                new Pricebook2(Name='Custom Pricebook4', isActive=true)
        };
            
       insert PriceBook2List;
       
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prod2List.get(0).Id;
        pbe.IsActive = true;
        pbe.PriceBook2 = PriceBook2List.get(0);
        pbe.UnitPrice = 10.00;
        pbe.Pricebook2Id = pricebookId;
        insert pbe;
        
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = prod2List.get(1).Id;
        pbe2.IsActive = true;
        pbe.PriceBook2 = PriceBook2List.get(1);
        pbe2.UnitPrice = 10.00;
        pbe2.Pricebook2Id = pricebookId;
        insert pbe2;
        
        
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = prod2List.get(2).Id;
        pbe3.IsActive = true;
        pbe3.PriceBook2 = PriceBook2List.get(2);
        pbe3.UnitPrice = 10.00;
        pbe3.Pricebook2Id = pricebookId;
        insert pbe3;
        
        
        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        
        List <Account> clientes = new Account[]{
            new Account(Name='Test15',ID_SAP__c ='C739',Base_de_Datos__c='NU3',ID_Agente__c='16',Estatus_de_cuenta__c='Activo'),
                new Account(Name='Test2', Lista_de_Precio__c = standardPricebook.Id,Estatus_de_cuenta__c='Activo'),
                new Account(Name='Test3',Estatus_de_cuenta__c='Activo')   
                };
                    insert clientes;
        
        
        List<Order> orders = new Order[]{
            new Order(
                RecordTypeId = facturasRT,
                AccountId = clientes.get(0).Id,
                EffectiveDate =  Date.newInstance(1960, 2, 17),
                Fecha_de_facturacion__c =  null,
                Comentarios__c = 'COMMENTARIO',
                Factura__c = 'idFacSap',
                Estatus_de_Factura__c = 'Factura',
                Status = 'Factura',
                Empresa_Financiera__c = null,
                Serie_del_Documento2__c = '93', 
                Tipo_de_pago__c = 'Efectivo',
                Flete_Facturado__c = 10.00,
                Base_de_datos_TEXT__c ='NU3',
                ID_SAP__c ='344151',
                ID_Externo__c = 344151 + 'NU3'
            ),
                new Order(
                    RecordTypeId = facturasRT,
                    AccountId = clientes.get(1).Id,
                    EffectiveDate =  Date.newInstance(1960, 2, 17),
                    Fecha_de_facturacion__c =  null,
                    Comentarios__c = 'COMMENTARIO',
                    Factura__c = 'idFacSap',
                    Estatus_de_Factura__c = 'Factura',
                    Status = 'Factura',
                    Empresa_Financiera__c = null,
                    Serie_del_Documento2__c = '93', 
                    Tipo_de_pago__c = 'Efectivo',
                    Flete_Facturado__c = 10.00,
                    Base_de_datos_TEXT__c ='NU3',
                     ID_SAP__c ='344256',
                    ID_Externo__c = 344256 + 'NU3'
                ),
                new Order(
                    RecordTypeId = facturasRT,
                    AccountId = clientes.get(0).Id,
                    EffectiveDate =  Date.newInstance(1960, 2, 17),
                    Fecha_de_facturacion__c =  null,
                    Comentarios__c = 'COMMENTARIO',
                    Factura__c = 'idFacSap',
                    Estatus_de_Factura__c = 'Factura',
                    Status = 'Factura',
                    Empresa_Financiera__c = null,
                    Serie_del_Documento2__c = '93', 
                    Tipo_de_pago__c = 'Efectivo',
                    Flete_Facturado__c = 10.00,
                    Base_de_datos_TEXT__c ='NU3',
                    ID_SAP__c ='344257',
                    ID_Externo__c = 344257 + 'NU3'
                )
                
                };        
                    insert orders;
        
        Encuesta__c enc = new Encuesta__c(Name='Encuesta de satisfacción',pregunta__c='test');
        insert enc;
    
    }
    
    
    
    @isTest public static  void ProductosNuevos () {
        
		
        List<Order> orders = [SELECT  Name, ID_Externo__c,ID_SAP__c ,Base_de_datos_TEXT__c FROM Order];
        system.debug(orders);
        
       
		//Aqui se deverían de agregar los productos a las ordenes         
        
        String json = '{ "Pedidos": [' 
            +'{"IdFacSap": 2256349, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresajm", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005",'
            +'  "Productos": [ '
            +'		{"ItemCode": "55555", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.800000", "IdSalesforce": null, "Factor1": "375.000000", "Kilos": "15,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "11274.440000", "LineNum": 0 },'
            +'  	{"ItemCode": "21160", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "2954.500000", "LineNum": 1 },'
            +'		{"ItemCode": "22130", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "9.550000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "652.810000", "LineNum": 2 },'
            +'		{"ItemCode": "22350", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.220000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "302.080000", "LineNum": 3 } ],'
            +'  	"JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "4,752.00", "Listadeprecios": "Lista de precios base", "Comments": "537816", "CardCode": "C739", "NumFactura": "256349", "Estatus": "O", "Cancelada": "Y", "BusUnit": "NU3" },'
            +'{"IdFacSap": 2256350, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005",'
            +'  "Productos": [ '
            +'		{"ItemCode": "10153", "IdSAP": "344257", "Entrega": 319553, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.980000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "99.800000", "LineNum": 0 } ],'
            +'  	"JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "48.00", "Listadeprecios": "Lista de precios base", "Comments": "537817", "CardCode": "C739", "NumFactura": "256350", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" },'
            +'{"IdFacSap": 2256351, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005",'
            +'  "Productos": [ '
            +'		{"ItemCode": "21160", "IdSAP": "344151", "Entrega": 319557, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000", "IdSalesforce": null, "Factor1": "200.000000", "Kilos": "8,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "4870.860000", "LineNum": 0 } ],'
            +' 		"JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "1,920.00", "Listadeprecios": "Lista de precios base", "Comments": "539733", "CardCode": "C749", "NumFactura": "256351", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" } ] } ';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(json));
        Test.startTest();
        Encuesta__c enc = new Encuesta__c(Name='Encuesta de satisfacción',pregunta__c='test');
        insert enc;
        String jobId = System.schedule('Facturados',  CRON_EXP, new ScheduleObtenerPedidosFacturados());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();  
    }    
    

    
    
}