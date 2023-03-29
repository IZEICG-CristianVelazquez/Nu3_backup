@isTest
private class SchedulerPedidosTest {
    
    static String CRON_EXP = '0 0 0 15 3 ? *';

    @testSetup 
    private static void setupData () {
        
        Encuesta__c enc = new Encuesta__c(Name='Encuesta de satisfacción',pregunta__c='test');
        insert enc;

        List<Product2> listProductsInsert = new List<Product2>();

        Product2 p1 = new Product2(Name = 'Producto prueba', ProductCode = '21720',Kilogramos_unidad__c=24);
        listProductsInsert.add(p1);

        Product2 p2 = new Product2(Name = 'Producto prueba2', ProductCode = '21160',Kilogramos_unidad__c=24);
        listProductsInsert.add(p2);

        Product2 p3 = new Product2(Name = 'Producto prueba3', ProductCode = '22530',Kilogramos_unidad__c=24);
        listProductsInsert.add(p3);

        Product2 p4 = new Product2(Name = 'Producto prueba4', ProductCode = '10153', Kilogramos_unidad__c = 10.9);
        listProductsInsert.add(p4);

        insert listProductsInsert;

        Id pricebookId = Test.getStandardPricebookId();

        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;

        List<Pricebook2> listPricebookInsert = new List<Pricebook2>();

        Pricebook2 pb1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        listPricebookInsert.add(pb1);

        Pricebook2 pb2 = new Pricebook2(Name='Custom Pricebook2', isActive=true);
        listPricebookInsert.add(pb2);

        Pricebook2 pb3 = new Pricebook2(Name='Custom Pricebook3', isActive=true);
        listPricebookInsert.add(pb3);
        
        Pricebook2 pb4 = new Pricebook2(Name='Custom Pricebook4', isActive=true);
        listPricebookInsert.add(pb4);

        insert listPricebookInsert;

        List<PricebookEntry> listPricebookEntryInsert = new List<PricebookEntry>();

        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p3.Id;
        pbe.IsActive = true;
        pbe.PriceBook2 = pb1;
        pbe.UnitPrice = 10.00;
        pbe.Pricebook2Id = pricebookId;
        listPricebookEntryInsert.add(pbe);

        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Product2Id = p2.Id;
        pbe2.IsActive = true;
        pbe.PriceBook2 = pb2;
        pbe2.UnitPrice = 10.00;
        pbe2.Pricebook2Id = pricebookId;
        listPricebookEntryInsert.add(pbe2);

        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Product2Id = p1.Id;
        pbe3.IsActive = true;
        pbe3.PriceBook2 = pb3;
        pbe3.UnitPrice = 10.00;
        pbe3.Pricebook2Id = pricebookId;
        listPricebookEntryInsert.add(pbe3);

        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = p4.Id;
        pbe4.IsActive = true;
        pbe4.PriceBook2 = pb4;
        pbe4.UnitPrice = 1900.00;
        pbe4.Pricebook2Id = pricebookId;
        pbe4.Product2 = p4;
        listPricebookEntryInsert.add(pbe4);

        insert listPricebookEntryInsert;

        List<Account> listAccountsInsert = new List<Account>();

        Account cuenta0 = new Account(
            Name='Cuenta0', 
            Clave_cliente__c='NU3256350',
            Estatus_de_cuenta__c='Activo'
        );

        listAccountsInsert.add(cuenta0);

        Account cuenta1 = new Account(Name='Cuenta1', Clave_cliente__c='NU316C739', Lista_de_Precio__c = standardPricebook.Id,Estatus_de_cuenta__c='Activo');
        listAccountsInsert.add(cuenta1);

        Account cuenta2 = new Account(Name='Cuenta2',Estatus_de_cuenta__c='Activo');
        listAccountsInsert.add(cuenta2);

        Account cuenta3 = new Account(Name='Cuenta3',Estatus_de_cuenta__c='Activo');
        listAccountsInsert.add(cuenta3);

        Account cuenta4 = new Account(Name='Cuenta4',Estatus_de_cuenta__c='Activo');
        listAccountsInsert.add(cuenta4);

        insert listAccountsInsert;

        List<Order> listOrdersInsert = new List<Order>();

        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        
        Order ord0 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta0.Id,
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
            ID_Externo__c = 344257 + 'NU3',
            Pricebook2Id = pricebookId
        );
        listOrdersInsert.add(ord0);
        
        Order ord1 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta1.Id,
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
            ID_Externo__c = 2256349 + 'NU3'
        );
        listOrdersInsert.add(ord1);
        
        Order ord2 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta2.Id,
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

            ID_Externo__c = 344256 + 'NU3'
        );
        listOrdersInsert.add(ord2);
       
        Order ord3 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta3.Id,
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

            ID_Externo__c = 344145 + 'NU3'
        );
        listOrdersInsert.add(ord3);      
        
        Order ord4 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta4.Id,
            EffectiveDate =  Date.newInstance(2019, 10, 27),
            Fecha_de_facturacion__c =  null,
            Comentarios__c = 'COMMENTARIO',
            Factura__c = 'idFacSap',
            Estatus_de_Factura__c = 'Factura',
            Status = 'Factura',
            Empresa_Financiera__c = null,
            Serie_del_Documento2__c = '93', 
            Tipo_de_pago__c = 'Efectivo',
            Flete_Facturado__c = 10.00,

            ID_Externo__c = 344146 + 'NU3'
        );
        listOrdersInsert.add(ord4);
        //OrderItems 

        insert listOrdersInsert;

        Order externalOrder = new Order(ID_Externo__c = 344257 + 'NU3');

        OrderItem orderItem = new OrderItem();        
        orderItem.Order = externalOrder;
        orderItem.UnitPrice = 9.0;
        orderItem.Quantity = 1200;
        orderItem.PricebookEntryId = pbe.Id;
        orderItem.Descuento_SAP__c = 12.0;

        insert orderItem;

        /* Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; */
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];

        User usr = new User(
            Alias = 'sysad', 
            Email='test@test.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='test@test.com'+DateTime.now().getTime()
        );

        insert usr;

        Agente__c agent = new Agente__c(
            ID_de_Agente__c = '2',
            Vendedor__c = usr.Id,
            Base_de_Datos__c = 'NU3'
        );

        insert agent;

    }

    static testmethod void schedulerPedidosExistentesTest(){
           String body = '{ "Pedidos": [ '
               +'{"IdFacSap": 2256349, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000",'
               +' 	"U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01",'
               +' 	"U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93,'
               +' 	"Project": "VPE005", '
               +'	"Productos": ['
               +'		{"ItemCode": "21720", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.800000",'
               +'   	"IdSalesforce": null, "Factor1": "375.000000", "Kilos": "15,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "11274.440000", "LineNum": 0 },'
               +' 		{"ItemCode": "21160", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000",'
               +'		"IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "2954.500000", "LineNum": 1 },'
               +' 		{"ItemCode": "22130", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "9.550000",'
               +'   	"IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "652.810000", "LineNum": 2 },'
               +' 		{"ItemCode": "22350", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.220000",'
               +' 		"IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "302.080000", "LineNum": 3 }'
               +'  	],'
               +' 	"JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null,'
               +' 	"Flete": "4,752.00", "Listadeprecios": "Lista de precios base", "Comments": "537816", "CardCode": "C739", "NumFactura": "256349", "Estatus": "O",'
               +' 	"Cancelada": "Y", "BusUnit": "NU3" },'
               +'{"IdFacSap": 2256350, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000",'
               +'	"U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01",'
               +'	"U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93,'
               +' 	"Project": "VPE005",'
               +' 	"Productos": [ '
               +'		{"ItemCode": "10153", "IdSAP": "344257", "Entrega": 319553, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.980000",'
               +'		"IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "99.800000", "LineNum": 0 }'
               +	'],'
               +' 	"JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null,'
               +' 	"Flete": "48.00", "Listadeprecios": "Lista de precios base", "Comments": "537817", "CardCode": "C739", "NumFactura": "256350", "Estatus": "O", '
               +'	"Cancelada": "N", "BusUnit": "NU3" } ], "Cantidad": 2 }';        
     
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('Facturados',  CRON_EXP, new ScheduleObtenerPedidosFacturados());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }

    static testmethod void schedulerNuevosPedidosTest ()  {
        
        //NU3 2 256350
        String body = '{'
        +   '"Pedidos":['
        +      '{'
        +         '"Referencia":"12345",'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"VPE002",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"8.220000",'
        +               '"ItemCode":"22530",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"6.470000",'
        +               '"ItemCode":"22230",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"15.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"6.350000",'
        +               '"ItemCode":"22290",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"6.170000",'
        +               '"ItemCode":"22350",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"5.900000",'
        +               '"ItemCode":"22420",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"8.850000",'
        +               '"ItemCode":"22030",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"10.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"9.750000",'
        +               '"ItemCode":"22020",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"10.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"5.350000",'
        +               '"ItemCode":"26010",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"35.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"3.920000",'
        +               '"ItemCode":"28660",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"4.450000",'
        +               '"ItemCode":"21480",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"7.550000",'
        +               '"ItemCode":"23500",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"7.070000",'
        +               '"ItemCode":"23340",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":344257,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"VIENE POR EL",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":16,'
        +         '"ShipToCode":2,'
        +         '"Series":59,'
        +         '"Project":"VPE005",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":null,'
        +               '"SlpCode":16,'
        +               '"Project":null,'
        +               '"Price":"4.150000",'
        +               '"ItemCode":"29880",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"75.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337756,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"viene por el",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"AFI001",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":37,'
        +               '"Project":null,'
        +               '"Price":"2,016.000000",'
        +               '"ItemCode":"REC-GTS",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"1.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337757,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":122,'
        +         '"ShipToCode":2,'
        +         '"Series":59,'
        +         '"Project":"VMP022",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":122,'
        +               '"Project":null,'
        +               '"Price":"0.011000",'
        +               '"ItemCode":"50322-AD",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"1.000000",'
        +               '"DiscPrcnt":"100.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337758,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"SOLICITA ANGEL CASTRO DE MATERIA PRIMA",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":"03",'
        +         '"U_Tarifa":"0.400000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":"CD. GUZMAN JAL.",'
        +         '"U_Flete":"01",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"VPE005",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":16,'
        +               '"Project":null,'
        +               '"Price":"22.000000",'
        +               '"ItemCode":"50749-AQ",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"20.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337759,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"FAVOR DE CONSOLIDAR CON PECUARIOS",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":"TOROS",'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":null,'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":-1,'
        +               '"Project":null,'
        +               '"Price":"20.100000",'
        +               '"ItemCode":"29110",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"1.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337760,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"F#76503",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":"03",'
        +         '"U_Tarifa":"0.240000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":"CHAVINDA MICH.",'
        +         '"U_Flete":"01",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"VMP015",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":115,'
        +               '"Project":null,'
        +               '"Price":"6.985000",'
        +               '"ItemCode":"10246",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"15.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337761,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"viende por el",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":"TOROS",'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":null,'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":-1,'
        +               '"Project":null,'
        +               '"Price":"4.970000",'
        +               '"ItemCode":"10120-MP",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"1.000000",'
        +               '"DiscPrcnt":"0.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337762,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"F#76528",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"LaFinanciera",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"VGP018",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"37.170000",'
        +               '"ItemCode":"50116-AD",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"25.000000",'
        +               '"DiscPrcnt":"37.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"53.810000",'
        +               '"ItemCode":"50101-AD",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"15.000000",'
        +               '"DiscPrcnt":"50.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"52.700000",'
        +               '"ItemCode":"50102-AD",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"6.000000",'
        +               '"DiscPrcnt":"50.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"55.950000",'
        +               '"ItemCode":"50092-AD",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"5.000000",'
        +               '"DiscPrcnt":"50.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"39.450000",'
        +               '"ItemCode":"50114-CA",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"6.000000",'
        +               '"DiscPrcnt":"37.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"60.220000",'
        +               '"ItemCode":"50091-CA",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"20.000000",'
        +               '"DiscPrcnt":"50.000000",'
        +               '"Kilos":12'
        +            '},'
        +            '{'
        +               '"TaxCode":"IVAT1601",'
        +               '"SlpCode":130,'
        +               '"Project":null,'
        +               '"Price":"56.190000",'
        +               '"ItemCode":"50081-CA",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"10.000000",'
        +               '"DiscPrcnt":"50.000000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337763,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-26",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"V\u00eda estafeta en un solo pallet",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '},'
        +      '{'
        +         '"U_VentaDelCU":"S/A",'
        +         '"U_Tipo":null,'
        +         '"U_Tarifa":"0.000000",'
        +         '"U_TarCam":"0.000000",'
        +         '"U_metodoDePagoCFD":"S/A",'
        +         '"U_LE":null,'
        +         '"U_Flete":"02",'
        +         '"U_EmpresaFinanciera":"MiEmpresa",'
        +         '"Status":null,'
        +         '"SlpCode":2,'
        +         '"ShipToCode":null,'
        +         '"Series":59,'
        +         '"Project":"VPE002",'
        +         '"Productos":['
        +            '{'
        +               '"TaxCode":"IVAT0001",'
        +               '"SlpCode":13,'
        +               '"Project":null,'
        +               '"Price":"5.750000",'
        +               '"ItemCode":"21720",'
        +               '"IdSalesforce":null,'
        +               '"Factor1":"475.000000",'
        +               '"DiscPrcnt":"1.500000",'
        +               '"Kilos":12'
        +            '}'
        +         '],'
        +         '"JrnlMemo":null,'
        +         '"IdSap":337764,'
        +         '"IdSalesforce":null,'
        +         '"DocDueDate":"2019-07-29",'
        +         '"DocDate":"2019-07-26",'
        +         '"DiscPrcnt":null,'
        +         '"Comments":"FAVOR DE ENVIAR, CARGA DIA 29",'
        +         '"CardCode":"256350",'
        +         '"BusUnit":"NU3"'
        +      '}'
        +   '],'
        +   '"Cantidad":9'
        +'}';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('Nuevos',  CRON_EXP, new ScheduleObtenerPedidos());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        
    }

    static testmethod void schedulerImprimirPedidosTest () {

        String body = '{"Pedidos":[{"Referencia":"12345","U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":13,"ShipToCode":null,"Series":59,"Project":"VPE002","Productos":[{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"8.220000","ItemCode":"22530","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"6.470000","ItemCode":"22230","IdSalesforce":null,"Factor1":"15.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"6.350000","ItemCode":"22290","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"6.170000","ItemCode":"22350","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"5.900000","ItemCode":"22420","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"8.850000","ItemCode":"22030","IdSalesforce":null,"Factor1":"10.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"9.750000","ItemCode":"22020","IdSalesforce":null,"Factor1":"10.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"5.350000","ItemCode":"26010","IdSalesforce":null,"Factor1":"35.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"3.920000","ItemCode":"28660","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"4.450000","ItemCode":"21480","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"7.550000","ItemCode":"23500","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"},{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"7.070000","ItemCode":"23340","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337755,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"VIENE POR EL","CardCode":"C8568","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":16,"ShipToCode":null,"Series":59,"Project":"VPE005","Productos":[{"TaxCode":null,"SlpCode":16,"Project":null,"Price":"4.150000","ItemCode":"29880","IdSalesforce":null,"Factor1":"75.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337756,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"viene por el","CardCode":"C12372","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":37,"ShipToCode":null,"Series":59,"Project":"AFI001","Productos":[{"TaxCode":"IVAT1601","SlpCode":37,"Project":null,"Price":"2,016.000000","ItemCode":"REC-GTS","IdSalesforce":null,"Factor1":"1.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337757,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"","CardCode":"C6058","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":122,"ShipToCode":null,"Series":59,"Project":"VMP022","Productos":[{"TaxCode":"IVAT1601","SlpCode":122,"Project":null,"Price":"0.011000","ItemCode":"50322-AD","IdSalesforce":null,"Factor1":"1.000000","DiscPrcnt":"100.000000"}],"JrnlMemo":null,"IdSap":337758,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"SOLICITA ANGEL CASTRO DE MATERIA PRIMA","CardCode":"C8284","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":"03","U_Tarifa":"0.400000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":"CD. GUZMAN JAL.","U_Flete":"01","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":16,"ShipToCode":null,"Series":59,"Project":"VPE005","Productos":[{"TaxCode":"IVAT0001","SlpCode":16,"Project":null,"Price":"22.000000","ItemCode":"50749-AQ","IdSalesforce":null,"Factor1":"20.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337759,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"FAVOR DE CONSOLIDAR CON PECUARIOS","CardCode":"C8140","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":"TOROS","U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":-1,"ShipToCode":null,"Series":59,"Project":null,"Productos":[{"TaxCode":"IVAT0001","SlpCode":-1,"Project":null,"Price":"20.100000","ItemCode":"29110","IdSalesforce":null,"Factor1":"1.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337760,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"F#76503","CardCode":"C10222","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":"03","U_Tarifa":"0.240000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":"CHAVINDA MICH.","U_Flete":"01","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":115,"ShipToCode":null,"Series":59,"Project":"VMP015","Productos":[{"TaxCode":"IVAT0001","SlpCode":115,"Project":null,"Price":"6.985000","ItemCode":"10246","IdSalesforce":null,"Factor1":"15.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337761,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"viende por el","CardCode":"C7403","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":"TOROS","U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":-1,"ShipToCode":null,"Series":59,"Project":null,"Productos":[{"TaxCode":"IVAT0001","SlpCode":-1,"Project":null,"Price":"4.970000","ItemCode":"10120-MP","IdSalesforce":null,"Factor1":"1.000000","DiscPrcnt":"0.000000"}],"JrnlMemo":null,"IdSap":337762,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"F#76528","CardCode":"C10222","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"LaFinanciera","Status":null,"SlpCode":57,"ShipToCode":null,"Series":59,"Project":"VGP018","Productos":[{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"37.170000","ItemCode":"50116-AD","IdSalesforce":null,"Factor1":"25.000000","DiscPrcnt":"37.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"53.810000","ItemCode":"50101-AD","IdSalesforce":null,"Factor1":"15.000000","DiscPrcnt":"50.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"52.700000","ItemCode":"50102-AD","IdSalesforce":null,"Factor1":"6.000000","DiscPrcnt":"50.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"55.950000","ItemCode":"50092-AD","IdSalesforce":null,"Factor1":"5.000000","DiscPrcnt":"50.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"39.450000","ItemCode":"50114-CA","IdSalesforce":null,"Factor1":"6.000000","DiscPrcnt":"37.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"60.220000","ItemCode":"50091-CA","IdSalesforce":null,"Factor1":"20.000000","DiscPrcnt":"50.000000"},{"TaxCode":"IVAT1601","SlpCode":130,"Project":null,"Price":"56.190000","ItemCode":"50081-CA","IdSalesforce":null,"Factor1":"10.000000","DiscPrcnt":"50.000000"}],"JrnlMemo":null,"IdSap":337763,"IdSalesforce":null,"DocDueDate":"2019-07-26","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"V\u00eda estafeta en un solo pallet","CardCode":"C7252","BusUnit":"NU3"},{"U_VentaDelCU":"S/A","U_Tipo":null,"U_Tarifa":"0.000000","U_TarCam":"0.000000","U_metodoDePagoCFD":"S/A","U_LE":null,"U_Flete":"02","U_EmpresaFinanciera":"MiEmpresa","Status":null,"SlpCode":13,"ShipToCode":null,"Series":59,"Project":"VPE002","Productos":[{"TaxCode":"IVAT0001","SlpCode":13,"Project":null,"Price":"5.750000","ItemCode":"21720","IdSalesforce":null,"Factor1":"475.000000","DiscPrcnt":"1.500000"}],"JrnlMemo":null,"IdSap":337764,"IdSalesforce":null,"DocDueDate":"2019-07-29","DocDate":"2019-07-26","DiscPrcnt":null,"Comments":"FAVOR DE ENVIAR, CARGA DIA 29","CardCode":"C10380","BusUnit":"NU3"}],"Cantidad":9}';        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('Impresos',  CRON_EXP, new ScheduleActualizarPedidos());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

            
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            

        Test.stopTest();
        
    }

    static testmethod void schedulerFacturarPedidosTest () {
		
        
        
        String body = '{ "Pedidos": [ { "IdFacSap": 2256349, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "21720", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.800000", "IdSalesforce": null, "Factor1": "375.000000", "Kilos": "15,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "11274.440000", "LineNum": 0 }, { "ItemCode": "21160", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "2954.500000", "LineNum": 1 }, { "ItemCode": "22130", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "9.550000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "652.810000", "LineNum": 2 }, { "ItemCode": "22350", "IdSAP": "344256", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.220000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "302.080000", "LineNum": 3 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "4,752.00", "Listadeprecios": "Lista de precios base", "Comments": "537816", "CardCode": "C739", "NumFactura": "256349", "Estatus": "O", "Cancelada": "Y", "BusUnit": "NU3" }, { "IdFacSap": 2256350, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "10153", "IdSAP": "344257", "Entrega": 319553, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.980000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "99.800000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "48.00", "Listadeprecios": "Lista de precios base", "Comments": "537817", "CardCode": "C739", "NumFactura": "256350", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256351, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "21160", "IdSAP": "344151", "Entrega": 319557, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000", "IdSalesforce": null, "Factor1": "200.000000", "Kilos": "8,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "4870.860000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "1,920.00", "Listadeprecios": "Lista de precios base", "Comments": "539733", "CardCode": "C749", "NumFactura": "256351", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256352, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "21610", "IdSAP": "344145", "Entrega": 319556, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.700000", "IdSalesforce": null, "Factor1": "300.000000", "Kilos": "12,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "8314.310000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "2,880.00", "Listadeprecios": "Lista de precios base", "Comments": "539734", "CardCode": "C12466", "NumFactura": "256352", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256353, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 9, "ShipToCode": null, "Series": 93, "Project": "VGP009", "Productos": [ { "ItemCode": "50589-AD", "IdSAP": "344094", "Entrega": 319555, "TaxCode": "IVAT1601", "SlpCode": 9, "Project": null, "Price": "13.180000", "IdSalesforce": null, "Factor1": "21,560.000000", "Kilos": "21,560.00", "DiscPrcnt": "0.000000", "GrssProfit": "95106.070000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-12-24", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "O.C.980405818 MONTERREY Basado en Pedidos de cliente 344094. Basado en Entregas 319555.", "CardCode": "C8423", "NumFactura": "256353", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256354, "U_VentaDelCU": "Materia Prima", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 27, "ShipToCode": null, "Series": 93, "Project": "VMP004", "Productos": [ { "ItemCode": "10223-MP", "IdSAP": "344496", "Entrega": 319559, "TaxCode": "IVAT0001", "SlpCode": 27, "Project": null, "Price": "7.950000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "1,195.00", "DiscPrcnt": "1.000000", "GrssProfit": "468.030000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539882", "CardCode": "C11790", "NumFactura": "256354", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256355, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 130, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "50091-CA", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "52.150000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "20.00", "DiscPrcnt": "40.000000", "GrssProfit": "258.120000", "LineNum": 0 }, { "ItemCode": "50101-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "49.190000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "8.00", "DiscPrcnt": "40.000000", "GrssProfit": "99.870000", "LineNum": 1 }, { "ItemCode": "50574-PCH", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "10.340000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "20.00", "DiscPrcnt": "44.000000", "GrssProfit": "13.530000", "LineNum": 2 }, { "ItemCode": "50573-PCH", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "10.340000", "IdSalesforce": null, "Factor1": "30.000000", "Kilos": "30.00", "DiscPrcnt": "44.000000", "GrssProfit": "20.490000", "LineNum": 3 }, { "ItemCode": "50575-PCH", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "10.340000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "20.00", "DiscPrcnt": "44.000000", "GrssProfit": "30.420000", "LineNum": 4 }, { "ItemCode": "50770-CA", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "131.470000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "8.00", "DiscPrcnt": "48.000000", "GrssProfit": "316.640000", "LineNum": 5 }, { "ItemCode": "50771-CA", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "116.380000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "12.00", "DiscPrcnt": "48.000000", "GrssProfit": "389.970000", "LineNum": 6 }, { "ItemCode": "50772-CA", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "114.940000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "12.00", "DiscPrcnt": "48.000000", "GrssProfit": "373.750000", "LineNum": 7 }, { "ItemCode": "50774-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "125.000000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "8.00", "DiscPrcnt": "48.000000", "GrssProfit": "272.500000", "LineNum": 8 }, { "ItemCode": "50775-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "113.500000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "12.00", "DiscPrcnt": "48.000000", "GrssProfit": "374.330000", "LineNum": 9 }, { "ItemCode": "50776-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "112.790000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "12.00", "DiscPrcnt": "48.000000", "GrssProfit": "379.850000", "LineNum": 10 }, { "ItemCode": "50778-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "135.780000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "8.00", "DiscPrcnt": "48.000000", "GrssProfit": "307.630000", "LineNum": 11 }, { "ItemCode": "50779-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "117.810000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "12.00", "DiscPrcnt": "48.000000", "GrssProfit": "387.020000", "LineNum": 12 }, { "ItemCode": "50780-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "133.620000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "4.00", "DiscPrcnt": "48.000000", "GrssProfit": "162.770000", "LineNum": 13 }, { "ItemCode": "50781-AD", "IdSAP": "343788", "Entrega": 319563, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "129.310000", "IdSalesforce": null, "Factor1": "8.000000", "Kilos": "16.00", "DiscPrcnt": "48.000000", "GrssProfit": "593.550000", "LineNum": 14 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "2 Basado en Pedidos de cliente 343788. Basado en Entregas 319563.", "CardCode": "C111", "NumFactura": "256355", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256356, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 130, "ShipToCode": null, "Series": 93, "Project": "VGP010", "Productos": [ { "ItemCode": "50783-AD", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-29.420000", "LineNum": 0 }, { "ItemCode": "50784-AD", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-33.460000", "LineNum": 1 }, { "ItemCode": "50785-AD", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-31.060000", "LineNum": 2 }, { "ItemCode": "50786-AD", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-32.220000", "LineNum": 3 }, { "ItemCode": "50782-AD", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-31.040000", "LineNum": 4 }, { "ItemCode": "50788-CA", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-32.550000", "LineNum": 5 }, { "ItemCode": "50787-CA", "IdSAP": "343901", "Entrega": 319567, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "1.20", "DiscPrcnt": "100.000000", "GrssProfit": "-33.280000", "LineNum": 6 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "PROMOCIONAL AUT X DULCE MKT Basado en Pedidos de cliente 343901. Basado en Entregas 319567.", "CardCode": "C111", "NumFactura": "256356", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256357, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 101, "ShipToCode": null, "Series": 93, "Project": "VPE011", "Productos": [ { "ItemCode": "4140-MKT", "IdSAP": "343353", "Entrega": 319047, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.100000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "100.000000", "GrssProfit": "-1160.620000", "LineNum": 0 }, { "ItemCode": "50778-AD", "IdSAP": "343353", "Entrega": 319566, "TaxCode": "IVAT1601", "SlpCode": 101, "Project": null, "Price": "0.100000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "4.00", "DiscPrcnt": "100.000000", "GrssProfit": "-128.600000", "LineNum": 1 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "Basado en Entregas 319047. 319566.", "CardCode": "C111", "NumFactura": "256357", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256358, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 12, "ShipToCode": null, "Series": 93, "Project": "VPE001", "Productos": [ { "ItemCode": "10153", "IdSAP": "344400", "Entrega": 319570, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "4.980000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.000000", "GrssProfit": "89.840000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539880", "CardCode": "C8368", "NumFactura": "256358", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256359, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 130, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "50747-AD", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "150.860000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "51.000000", "GrssProfit": "15.110000", "LineNum": 0 }, { "ItemCode": "50748-AD", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "150.860000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "51.000000", "GrssProfit": "15.110000", "LineNum": 1 }, { "ItemCode": "50593-PCH", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "18.090000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "51.000000", "GrssProfit": "-6.160000", "LineNum": 2 }, { "ItemCode": "59372", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "128.570000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": ".000000", "LineNum": 3 }, { "ItemCode": "59374", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "147.490000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "19.940000", "LineNum": 4 }, { "ItemCode": "59376", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "147.490000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "19.940000", "LineNum": 5 }, { "ItemCode": "59378", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "147.490000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "19.940000", "LineNum": 6 }, { "ItemCode": "59380", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "147.490000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "19.940000", "LineNum": 7 }, { "ItemCode": "50188-TR", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "71.970000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "51.000000", "GrssProfit": "64.260000", "LineNum": 8 }, { "ItemCode": "50314-TR", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "71.970000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "51.000000", "GrssProfit": "66.030000", "LineNum": 9 }, { "ItemCode": "50642-CA", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "232.330000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "-37.720000", "LineNum": 10 }, { "ItemCode": "50706-CA", "IdSAP": "343791", "Entrega": 319565, "TaxCode": "IVAT1601", "SlpCode": 130, "Project": null, "Price": "234.220000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "2.00", "DiscPrcnt": "51.000000", "GrssProfit": "-112.880000", "LineNum": 11 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "Basado en Pedidos de cliente 343791. Basado en Entregas 319565.", "CardCode": "C111", "NumFactura": "256359", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256360, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 12, "ShipToCode": null, "Series": 93, "Project": "VPE001", "Productos": [ { "ItemCode": "21980", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "5.955000", "IdSalesforce": null, "Factor1": "8.000000", "Kilos": "320.00", "DiscPrcnt": "1.500000", "GrssProfit": "239.190000", "LineNum": 0 }, { "ItemCode": "29880", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "4.225000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "150.990000", "LineNum": 1 }, { "ItemCode": "21110", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "5.180000", "IdSalesforce": null, "Factor1": "7.000000", "Kilos": "280.00", "DiscPrcnt": "1.500000", "GrssProfit": "278.690000", "LineNum": 2 }, { "ItemCode": "21480", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "4.500000", "IdSalesforce": null, "Factor1": "12.000000", "Kilos": "480.00", "DiscPrcnt": "1.500000", "GrssProfit": "259.340000", "LineNum": 3 }, { "ItemCode": "28660", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "3.970000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "184.370000", "LineNum": 4 }, { "ItemCode": "24070", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "6.050000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "120.00", "DiscPrcnt": "1.500000", "GrssProfit": "195.590000", "LineNum": 5 }, { "ItemCode": "22530", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "8.270000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "588.930000", "LineNum": 6 }, { "ItemCode": "22470", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "6.370000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "80.00", "DiscPrcnt": "1.500000", "GrssProfit": "52.480000", "LineNum": 7 }, { "ItemCode": "29650", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "5.170000", "IdSalesforce": null, "Factor1": "8.000000", "Kilos": "320.00", "DiscPrcnt": "1.500000", "GrssProfit": "105.860000", "LineNum": 8 }, { "ItemCode": "23150", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "120.00", "DiscPrcnt": "1.500000", "GrssProfit": "137.340000", "LineNum": 9 }, { "ItemCode": "23210", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "120.00", "DiscPrcnt": "1.500000", "GrssProfit": "131.140000", "LineNum": 10 }, { "ItemCode": "23010", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "7.320000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "120.00", "DiscPrcnt": "1.500000", "GrssProfit": "97.500000", "LineNum": 11 }, { "ItemCode": "23450", "IdSAP": "344399", "Entrega": 319569, "TaxCode": "IVAT0001", "SlpCode": 12, "Project": null, "Price": "6.200000", "IdSalesforce": null, "Factor1": "13.000000", "Kilos": "520.00", "DiscPrcnt": "1.500000", "GrssProfit": "420.600000", "LineNum": 12 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539879", "CardCode": "C8368", "NumFactura": "256360", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256361, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 126, "ShipToCode": null, "Series": 93, "Project": "VGP049", "Productos": [ { "ItemCode": "5AEDBNTRHB-04", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "35.180000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "59.290000", "LineNum": 0 }, { "ItemCode": "5AEDBNTB-04", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "33.600000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "57.090000", "LineNum": 1 }, { "ItemCode": "59368", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "75.000000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "3.00", "DiscPrcnt": "0.000000", "GrssProfit": "114.140000", "LineNum": 2 }, { "ItemCode": "59369", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "50.000000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "121.420000", "LineNum": 3 }, { "ItemCode": "59360", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "48.500000", "IdSalesforce": null, "Factor1": "13.000000", "Kilos": "13.00", "DiscPrcnt": "0.000000", "GrssProfit": "259.670000", "LineNum": 4 }, { "ItemCode": "59361", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "87.000000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "1.00", "DiscPrcnt": "0.000000", "GrssProfit": "35.140000", "LineNum": 5 }, { "ItemCode": "59338", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "130.000000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "1.00", "DiscPrcnt": "0.000000", "GrssProfit": "66.830000", "LineNum": 6 }, { "ItemCode": "59287", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "20.000000", "IdSalesforce": null, "Factor1": "6.000000", "Kilos": "6.00", "DiscPrcnt": "0.000000", "GrssProfit": "61.650000", "LineNum": 7 }, { "ItemCode": "59364", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "12.000000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "30.560000", "LineNum": 8 }, { "ItemCode": "59265", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "80.330000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "173.590000", "LineNum": 9 }, { "ItemCode": "59072", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "40.950000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "69.710000", "LineNum": 10 }, { "ItemCode": "59195", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "20.000000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "0.000000", "GrssProfit": "96.270000", "LineNum": 11 }, { "ItemCode": "59294", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "38.000000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "93.840000", "LineNum": 12 }, { "ItemCode": "59300", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "20.000000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "20.00", "DiscPrcnt": "0.000000", "GrssProfit": "197.620000", "LineNum": 13 }, { "ItemCode": "59301", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "20.000000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "20.00", "DiscPrcnt": "0.000000", "GrssProfit": "196.870000", "LineNum": 14 }, { "ItemCode": "59310", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "38.500000", "IdSalesforce": null, "Factor1": "6.000000", "Kilos": "6.00", "DiscPrcnt": "0.000000", "GrssProfit": "114.310000", "LineNum": 15 }, { "ItemCode": "59350", "IdSAP": "344510", "Entrega": 319568, "TaxCode": "IVAT1601", "SlpCode": 126, "Project": null, "Price": "15.000000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "36.100000", "LineNum": 16 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "AVE", "Comments": "227 refact Basado en Pedidos de cliente 344510. Basado en Entregas 319568.", "CardCode": "C8339", "NumFactura": "256361", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256362, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "28660", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "3.970000", "IdSalesforce": null, "Factor1": "19.000000", "Kilos": "760.00", "DiscPrcnt": "1.500000", "GrssProfit": "350.300000", "LineNum": 0 }, { "ItemCode": "21480", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.500000", "IdSalesforce": null, "Factor1": "15.000000", "Kilos": "600.00", "DiscPrcnt": "1.500000", "GrssProfit": "324.180000", "LineNum": 1 }, { "ItemCode": "23500", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "7.600000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "80.00", "DiscPrcnt": "1.500000", "GrssProfit": "86.040000", "LineNum": 2 }, { "ItemCode": "23450", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.200000", "IdSalesforce": null, "Factor1": "18.000000", "Kilos": "720.00", "DiscPrcnt": "1.500000", "GrssProfit": "582.370000", "LineNum": 3 }, { "ItemCode": "29880", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.225000", "IdSalesforce": null, "Factor1": "6.000000", "Kilos": "240.00", "DiscPrcnt": "1.500000", "GrssProfit": "90.600000", "LineNum": 4 }, { "ItemCode": "26010", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.400000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "160.00", "DiscPrcnt": "1.500000", "GrssProfit": "152.880000", "LineNum": 5 }, { "ItemCode": "23210", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "160.00", "DiscPrcnt": "1.500000", "GrssProfit": "174.850000", "LineNum": 6 }, { "ItemCode": "28670", "IdSAP": "344493", "Entrega": 319571, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.120000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "80.00", "DiscPrcnt": "1.500000", "GrssProfit": "126.570000", "LineNum": 7 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539876", "CardCode": "C12372", "NumFactura": "256362", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256363, "U_VentaDelCU": "Efectivo", "U_Tipo": "03", "U_Tarifa": "0.440000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SAN GABRIEL, JAL", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "50255-GP", "IdSAP": "343926", "Entrega": 319480, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "14.000000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "60.00", "DiscPrcnt": "15.000000", "GrssProfit": "342.810000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "26.40", "Listadeprecios": "Lista de precios base", "Comments": "537999", "CardCode": "C11296", "NumFactura": "256363", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256364, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 22, "ShipToCode": null, "Series": 93, "Project": "VMP001", "Productos": [ { "ItemCode": "28660", "IdSAP": "344507", "Entrega": 319573, "TaxCode": "IVAT0001", "SlpCode": 22, "Project": null, "Price": "3.970000", "IdSalesforce": null, "Factor1": "50.000000", "Kilos": "2,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "921.850000", "LineNum": 0 }, { "ItemCode": "28730", "IdSAP": "344507", "Entrega": 319573, "TaxCode": "IVAT0001", "SlpCode": 22, "Project": null, "Price": "4.745000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "256.950000", "LineNum": 1 }, { "ItemCode": "21480", "IdSAP": "344507", "Entrega": 319573, "TaxCode": "IVAT0001", "SlpCode": 22, "Project": null, "Price": "4.500000", "IdSalesforce": null, "Factor1": "50.000000", "Kilos": "2,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "1080.960000", "LineNum": 2 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539897", "CardCode": "C7504", "NumFactura": "256364", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256365, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.440000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SAN GABRIEL, JAL", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "28660", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "3.970000", "IdSalesforce": null, "Factor1": "85.000000", "Kilos": "3,400.00", "DiscPrcnt": "0.000000", "GrssProfit": "1769.620000", "LineNum": 0 }, { "ItemCode": "10891", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "45.000000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "0.000000", "GrssProfit": "135.000000", "LineNum": 1 }, { "ItemCode": "20020", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "25.200000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "100.00", "DiscPrcnt": "0.000000", "GrssProfit": "358.680000", "LineNum": 2 }, { "ItemCode": "10246", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "40.00", "DiscPrcnt": "0.000000", "GrssProfit": "61.100000", "LineNum": 3 }, { "ItemCode": "23040", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "7.470000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "800.00", "DiscPrcnt": "0.000000", "GrssProfit": "454.200000", "LineNum": 4 }, { "ItemCode": "27010", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.120000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "80.00", "DiscPrcnt": "0.000000", "GrssProfit": "92.280000", "LineNum": 5 }, { "ItemCode": "28670", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.120000", "IdSalesforce": null, "Factor1": "30.000000", "Kilos": "1,200.00", "DiscPrcnt": "0.000000", "GrssProfit": "2008.720000", "LineNum": 6 }, { "ItemCode": "31008-P", "IdSAP": "344314", "Entrega": 319562, "TaxCode": "IVAT1601", "SlpCode": 16, "Project": null, "Price": "32.000000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "10.00", "DiscPrcnt": "0.000000", "GrssProfit": "104.760000", "LineNum": 7 }, { "ItemCode": "23010", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "7.320000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "800.00", "DiscPrcnt": "0.000000", "GrssProfit": "737.860000", "LineNum": 8 }, { "ItemCode": "21480", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.500000", "IdSalesforce": null, "Factor1": "90.000000", "Kilos": "3,600.00", "DiscPrcnt": "0.000000", "GrssProfit": "2188.050000", "LineNum": 9 }, { "ItemCode": "24020", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.820000", "IdSalesforce": null, "Factor1": "25.000000", "Kilos": "1,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "1607.760000", "LineNum": 10 }, { "ItemCode": "28730", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.745000", "IdSalesforce": null, "Factor1": "50.000000", "Kilos": "2,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "1427.080000", "LineNum": 11 }, { "ItemCode": "29880", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "4.225000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "1763.420000", "LineNum": 12 }, { "ItemCode": "22230", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.520000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "147.620000", "LineNum": 13 }, { "ItemCode": "20022", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "32.680000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "75.00", "DiscPrcnt": "0.000000", "GrssProfit": "344.310000", "LineNum": 14 }, { "ItemCode": "23510", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "736.510000", "LineNum": 15 }, { "ItemCode": "10890", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "45.000000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "5.00", "DiscPrcnt": "0.000000", "GrssProfit": "67.530000", "LineNum": 16 }, { "ItemCode": "28159", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.620000", "IdSalesforce": null, "Factor1": "15.000000", "Kilos": "600.00", "DiscPrcnt": "0.000000", "GrssProfit": "690.360000", "LineNum": 17 }, { "ItemCode": "23440", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "7.350000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "420.010000", "LineNum": 18 }, { "ItemCode": "22130", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "9.550000", "IdSalesforce": null, "Factor1": "15.000000", "Kilos": "600.00", "DiscPrcnt": "0.000000", "GrssProfit": "979.220000", "LineNum": 19 }, { "ItemCode": "21626-P", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "22.000000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "40.00", "DiscPrcnt": "0.000000", "GrssProfit": "285.000000", "LineNum": 20 }, { "ItemCode": "23450", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.200000", "IdSalesforce": null, "Factor1": "35.000000", "Kilos": "1,400.00", "DiscPrcnt": "0.000000", "GrssProfit": "1262.590000", "LineNum": 21 }, { "ItemCode": "21140", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.700000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "0.000000", "GrssProfit": "332.920000", "LineNum": 22 }, { "ItemCode": "28480", "IdSAP": "343924", "Entrega": 319564, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.850000", "IdSalesforce": null, "Factor1": "3.000000", "Kilos": "120.00", "DiscPrcnt": "0.000000", "GrssProfit": "155.490000", "LineNum": 23 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "9,187.20", "Listadeprecios": "Lista de precios base", "Comments": "538000; 537997.", "CardCode": "C11296", "NumFactura": "256365", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256366, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.310000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "DOLORES HIDALGO", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 13, "ShipToCode": null, "Series": 93, "Project": "VPE002", "Productos": [ { "ItemCode": "29519", "IdSAP": "344228", "Entrega": 319575, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "6.480000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "21,545.00", "DiscPrcnt": "0.000000", "GrssProfit": "19536.760000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "6,678.95", "Listadeprecios": "Lista de precios base", "Comments": "538014", "CardCode": "C5079", "NumFactura": "256366", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256367, "U_VentaDelCU": "Materia Prima", "U_Tipo": "02", "U_Tarifa": "0.170000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "ECUANDUREO MICH.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 22, "ShipToCode": null, "Series": 93, "Project": "VMP001", "Productos": [ { "ItemCode": "01s54000001UiJQAA0", "IdSAP": "344430", "Entrega": 319578, "TaxCode": "IVAT0001", "SlpCode": 22, "Project": null, "Price": "4.350000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "9,040.00", "DiscPrcnt": "1.000000", "GrssProfit": "2171.730000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-16", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "1,536.80", "Listadeprecios": "Lista de precios base", "Comments": "535711", "CardCode": "C279", "NumFactura": "256367", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256368, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 2, "ShipToCode": null, "Series": 93, "Project": "VGP002", "Productos": [ { "ItemCode": "50241-AD", "IdSAP": "344426", "Entrega": 319560, "TaxCode": "IVAT1601", "SlpCode": 2, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "277.000000", "Kilos": "33.24", "DiscPrcnt": "100.000000", "GrssProfit": "-806.550000", "LineNum": 0 }, { "ItemCode": "50242-AD", "IdSAP": "344426", "Entrega": 319560, "TaxCode": "IVAT1601", "SlpCode": 2, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "481.000000", "Kilos": "57.72", "DiscPrcnt": "100.000000", "GrssProfit": "-2267.300000", "LineNum": 1 }, { "ItemCode": "4077-MKT", "IdSAP": "344426", "Entrega": 319574, "TaxCode": "IVAT1601", "SlpCode": 2, "Project": null, "Price": "0.100000", "IdSalesforce": null, "Factor1": "800.000000", "Kilos": "800.00", "DiscPrcnt": "100.000000", "GrssProfit": "-8.000000", "LineNum": 2 }, { "ItemCode": "4008-MKT", "IdSAP": "344426", "Entrega": 319574, "TaxCode": "IVAT1601", "SlpCode": 2, "Project": null, "Price": "0.100000", "IdSalesforce": null, "Factor1": "400.000000", "Kilos": "400.00", "DiscPrcnt": "100.000000", "GrssProfit": "-366.660000", "LineNum": 3 }, { "ItemCode": "4106-MKT", "IdSAP": "344426", "Entrega": 319574, "TaxCode": "IVAT1601", "SlpCode": 2, "Project": null, "Price": "0.100000", "IdSalesforce": null, "Factor1": "800.000000", "Kilos": "800.00", "DiscPrcnt": "100.000000", "GrssProfit": "-2944.000000", "LineNum": 4 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "Basado en Entregas 319560. 319574.", "CardCode": "C10", "NumFactura": "256368", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256369, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 123, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "29880", "IdSAP": "344275", "Entrega": 319577, "TaxCode": "IVAT0001", "SlpCode": 123, "Project": null, "Price": "4.225000", "IdSalesforce": null, "Factor1": "700.000000", "Kilos": "28,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "10569.440000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "538018", "CardCode": "C10540", "NumFactura": "256369", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256370, "U_VentaDelCU": "Materia Prima", "U_Tipo": "03", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 123, "ShipToCode": null, "Series": 93, "Project": "", "Productos": [ { "ItemCode": "10223-MP", "IdSAP": "344276", "Entrega": 319579, "TaxCode": "IVAT0001", "SlpCode": 123, "Project": null, "Price": "7.950000", "IdSalesforce": null, "Factor1": "300.000000", "Kilos": "12,000.00", "DiscPrcnt": "1.000000", "GrssProfit": "4611.310000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "538019", "CardCode": "C10540", "NumFactura": "256370", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256371, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 15, "ShipToCode": null, "Series": 93, "Project": "VPE004", "Productos": [ { "ItemCode": "21370", "IdSAP": "343567", "Entrega": 319582, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "5.430000", "IdSalesforce": null, "Factor1": "15.000000", "Kilos": "600.00", "DiscPrcnt": "1.500000", "GrssProfit": "302.050000", "LineNum": 0 }, { "ItemCode": "26010", "IdSAP": "343567", "Entrega": 319582, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "5.400000", "IdSalesforce": null, "Factor1": "50.000000", "Kilos": "2,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "1920.020000", "LineNum": 1 }, { "ItemCode": "21110", "IdSAP": "343567", "Entrega": 319582, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "5.180000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "800.00", "DiscPrcnt": "1.500000", "GrssProfit": "796.280000", "LineNum": 2 }, { "ItemCode": "21380", "IdSAP": "343567", "Entrega": 319582, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "5.480000", "IdSalesforce": null, "Factor1": "340.000000", "Kilos": "13,600.00", "DiscPrcnt": "1.500000", "GrssProfit": "9649.470000", "LineNum": 3 }, { "ItemCode": "21140", "IdSAP": "343567", "Entrega": 319582, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "6.700000", "IdSalesforce": null, "Factor1": "75.000000", "Kilos": "3,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "4692.270000", "LineNum": 4 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539738", "CardCode": "C8604", "NumFactura": "256371", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256372, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 15, "ShipToCode": null, "Series": 93, "Project": "VPE004", "Productos": [ { "ItemCode": "21380", "IdSAP": "343568", "Entrega": 319580, "TaxCode": "IVAT0001", "SlpCode": 15, "Project": null, "Price": "5.480000", "IdSalesforce": null, "Factor1": "550.000000", "Kilos": "22,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "15603.460000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539736", "CardCode": "C7528", "NumFactura": "256372", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256373, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SILAO GTO.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "21260", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.330000", "IdSalesforce": null, "Factor1": "175.000000", "Kilos": "7,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "4836.640000", "LineNum": 0 }, { "ItemCode": "23450", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.200000", "IdSalesforce": null, "Factor1": "175.000000", "Kilos": "7,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "5661.190000", "LineNum": 1 }, { "ItemCode": "21110", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.180000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "3981.390000", "LineNum": 2 }, { "ItemCode": "22030", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "8.900000", "IdSalesforce": null, "Factor1": "25.000000", "Kilos": "1,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "1879.730000", "LineNum": 3 }, { "ItemCode": "22480", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.200000", "IdSalesforce": null, "Factor1": "21.000000", "Kilos": "840.00", "DiscPrcnt": "1.500000", "GrssProfit": "856.380000", "LineNum": 4 }, { "ItemCode": "21140", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.700000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.500000", "GrssProfit": "312.820000", "LineNum": 5 }, { "ItemCode": "27090", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.550000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.500000", "GrssProfit": "263.500000", "LineNum": 6 }, { "ItemCode": "22420", "IdSAP": "344539", "Entrega": 319588, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.950000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "160.00", "DiscPrcnt": "1.500000", "GrssProfit": "191.720000", "LineNum": 7 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "4,896.00", "Listadeprecios": "Lista de precios base", "Comments": "538017", "CardCode": "C661", "NumFactura": "256373", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256374, "U_VentaDelCU": "Materia Prima", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 27, "ShipToCode": null, "Series": 93, "Project": "VMP004", "Productos": [ { "ItemCode": "10153-MP", "IdSAP": "344461", "Entrega": 319576, "TaxCode": "IVAT0001", "SlpCode": 27, "Project": null, "Price": "4.980000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "10,000.00", "DiscPrcnt": "1.000000", "GrssProfit": "6179.440000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-09-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539033", "CardCode": "C13241", "NumFactura": "256374", "Estatus": "C", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256375, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 13, "ShipToCode": null, "Series": 93, "Project": "VPE002", "Productos": [ { "ItemCode": "10223-P", "IdSAP": "344509", "Entrega": 319584, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "7.950000", "IdSalesforce": null, "Factor1": "1.000000", "Kilos": "515.00", "DiscPrcnt": "1.000000", "GrssProfit": "152.210000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539894", "CardCode": "C1115", "NumFactura": "256375", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256376, "U_VentaDelCU": "Pecuarios", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 13, "ShipToCode": null, "Series": 93, "Project": "VMP001", "Productos": [ { "ItemCode": "22230", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "6.520000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "256.130000", "LineNum": 0 }, { "ItemCode": "22350", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "6.220000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "264.760000", "LineNum": 1 }, { "ItemCode": "22500", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "5.440000", "IdSalesforce": null, "Factor1": "24.000000", "Kilos": "960.00", "DiscPrcnt": "1.500000", "GrssProfit": "880.980000", "LineNum": 2 }, { "ItemCode": "22510", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "5.340000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "800.00", "DiscPrcnt": "1.500000", "GrssProfit": "878.510000", "LineNum": 3 }, { "ItemCode": "26010", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "5.400000", "IdSalesforce": null, "Factor1": "25.000000", "Kilos": "1,000.00", "DiscPrcnt": "1.500000", "GrssProfit": "960.010000", "LineNum": 4 }, { "ItemCode": "23010", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "7.320000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.500000", "GrssProfit": "162.510000", "LineNum": 5 }, { "ItemCode": "23210", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "6.400000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "437.120000", "LineNum": 6 }, { "ItemCode": "28390", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "5.480000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.500000", "GrssProfit": "204.040000", "LineNum": 7 }, { "ItemCode": "21110", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "5.180000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "1.500000", "GrssProfit": "398.140000", "LineNum": 8 }, { "ItemCode": "28660", "IdSAP": "344546", "Entrega": 319592, "TaxCode": "IVAT0001", "SlpCode": 13, "Project": null, "Price": "3.970000", "IdSalesforce": null, "Factor1": "5.000000", "Kilos": "200.00", "DiscPrcnt": "1.500000", "GrssProfit": "92.480000", "LineNum": 9 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-03", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "539896", "CardCode": "C1115", "NumFactura": "256376", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256377, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 98, "ShipToCode": null, "Series": 93, "Project": "VGP046", "Productos": [ { "ItemCode": "50143-GA", "IdSAP": "343961", "Entrega": 319590, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "23.040000", "IdSalesforce": null, "Factor1": "60.000000", "Kilos": "900.00", "DiscPrcnt": "18.000000", "GrssProfit": "5271.490000", "LineNum": 0 }, { "ItemCode": "50147-GA", "IdSAP": "343961", "Entrega": 319590, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "4.000000", "Kilos": "60.00", "DiscPrcnt": "100.000000", "GrssProfit": "-782.130000", "LineNum": 1 }, { "ItemCode": "50274-AD", "IdSAP": "343961", "Entrega": 319590, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "13.000000", "IdSalesforce": null, "Factor1": "400.000000", "Kilos": "8,800.00", "DiscPrcnt": "18.000000", "GrssProfit": "25676.970000", "LineNum": 2 }, { "ItemCode": "50331-AD", "IdSAP": "343961", "Entrega": 319590, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "8.000000", "Kilos": "176.00", "DiscPrcnt": "100.000000", "GrssProfit": "-1362.620000", "LineNum": 3 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-10", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "Central de Abastos Canindo Zamora MANIOBRAS 2.5 PSS X SCO Basado en Pedidos de cliente 343961. Basado en Entregas 319590.", "CardCode": "C12996", "NumFactura": "256377", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256378, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 98, "ShipToCode": null, "Series": 93, "Project": "VGP046", "Productos": [ { "ItemCode": "50675-AD", "IdSAP": "344395", "Entrega": 319591, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "11.460000", "IdSalesforce": null, "Factor1": "50.000000", "Kilos": "1,200.00", "DiscPrcnt": "18.000000", "GrssProfit": "2548.280000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-10", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "MANIOBRAS 2.5 PSS X SCO Mercado de abastos canindo Zamora Basado en Pedidos de cliente 344395. Basado en Entregas 319591.", "CardCode": "C12996", "NumFactura": "256378", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256379, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 98, "ShipToCode": null, "Series": 93, "Project": "VGP046", "Productos": [ { "ItemCode": "50140-CA", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "24.270000", "IdSalesforce": null, "Factor1": "20.000000", "Kilos": "300.00", "DiscPrcnt": "18.000000", "GrssProfit": "2428.490000", "LineNum": 0 }, { "ItemCode": "50146-CA", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "30.00", "DiscPrcnt": "100.000000", "GrssProfit": "-354.190000", "LineNum": 1 }, { "ItemCode": "50143-GA", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "23.040000", "IdSalesforce": null, "Factor1": "30.000000", "Kilos": "450.00", "DiscPrcnt": "18.000000", "GrssProfit": "2635.750000", "LineNum": 2 }, { "ItemCode": "50147-GA", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "2.000000", "Kilos": "30.00", "DiscPrcnt": "100.000000", "GrssProfit": "-391.070000", "LineNum": 3 }, { "ItemCode": "50272-AD", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "12.860000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "2,500.00", "DiscPrcnt": "18.000000", "GrssProfit": "7697.820000", "LineNum": 4 }, { "ItemCode": "50301-AD", "IdSAP": "343947", "Entrega": 319587, "TaxCode": "IVAT1601", "SlpCode": 98, "Project": null, "Price": "0.010000", "IdSalesforce": null, "Factor1": "6.000000", "Kilos": "150.00", "DiscPrcnt": "100.000000", "GrssProfit": "-1119.910000", "LineNum": 5 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-10", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "MANIOBRAS 2.50 PSS X SCO Bloque C-1 Central de Abastos Zamora PRECIO NUEVO Basado en Pedidos de cliente 343947. Basado en Entregas 319587.", "CardCode": "C10609", "NumFactura": "256379", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" }, { "IdFacSap": 2256380, "U_VentaDelCU": "Grand Pet", "U_Tipo": "", "U_Tarifa": "0.000000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "", "U_Flete": "02", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 9, "ShipToCode": null, "Series": 93, "Project": "VGP009", "Productos": [ { "ItemCode": "50589-AD", "IdSAP": "344095", "Entrega": 319593, "TaxCode": "IVAT1601", "SlpCode": 9, "Project": null, "Price": "13.180000", "IdSalesforce": null, "Factor1": "21,560.000000", "Kilos": "21,560.00", "DiscPrcnt": "0.000000", "GrssProfit": "95092.660000", "LineNum": 0 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-12-24", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "0.00", "Listadeprecios": "Lista de precios base", "Comments": "O.C.980405818 MONTERREY Basado en Pedidos de cliente 344095. Basado en Entregas 319593.", "CardCode": "C8423", "NumFactura": "256380", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3" } ], "Cantidad": 32 }';        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('Facturados',  CRON_EXP, new ScheduleObtenerPedidosFacturados());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}