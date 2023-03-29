@isTest private class ServicePedidosTest {
    
    @testSetup 
    private static void setupData () {
        
        
        Encuesta__c enc = new Encuesta__c();
        enc.Name = 'Encuesta de satisfacción';
        enc.pregunta__c = 'test';
        insert enc;
        
        Product2 p4 = new Product2(Name = 'Producto prueba4', ProductCode = '10153', Kilogramos_unidad__c = 10.9);
        insert p4;
        
        Id pricebookId = Test.getStandardPricebookId();
        

        
        PricebookEntry pbe4 = new PricebookEntry();
        pbe4.Product2Id = p4.Id;
        pbe4.IsActive = true;
        pbe4.UnitPrice = 1900.00;
        pbe4.Pricebook2Id = pricebookId;
        pbe4.Product2 = p4;
        insert pbe4;
        Id facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        
        Account cuenta4 = new Account(Name='Cuenta4',Estatus_de_cuenta__c='Activo');
        insert cuenta4;
        Order ord4 = new Order(
            RecordTypeId = facturasRT,
            AccountId = cuenta4.Id,
            EffectiveDate =  Date.newInstance(2019, 10, 27),
            Fecha_de_facturacion__c =  null,
            Comentarios__c = 'COMMENTARIO',
            Factura__c = 'idFacSap',
            Estatus_de_Factura__c = 'Factura',
            Status = 'Cotización',
            Empresa_Financiera__c = null,
            Serie_del_Documento2__c = '93', 
            Tipo_de_pago__c = 'Efectivo',
            Flete_Facturado__c = 10.00,
            Pricebook2Id = pricebookId,
            ID_Externo__c = 344146 + 'NU3'
        );
        insert ord4;
        
        ord4.Status = 'Enviado a SAP';
        
        
        //OrderItems 
        OrderItem item = new OrderItem(OrderId = ord4.Id, 
                                       UnitPrice = 9.0,
                                       Quantity = 12,
                                       Product2Id = pbe4.Product2Id, 
                                       PricebookEntryId = pbe4.Id,
                                       Descuento_SAP__c = 12.0
                                      );
        insert item;
        
        update ord4;
       
    }
    @isTest
    private static void test_Parse(){
        
        String json = '{ "Pedidos": [ '
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
        ServicePedidos.WSResponsePedidos res =  ServicePedidos.parse(json);
        System.debug('res---'+res);
    }
    @isTest
    private static void test_serviceObtener () {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.httpMethod = 'GET';
        
        RestContext.request = req;
	    RestContext.response = res;
        
        Test.startTest();          

        ServicePedidos.obtenerPedidos();
        Test.stopTest();
    }
    @isTest 
    private static void test_serviceActualizar(){
        
        String json = '{ "Pedidos": [ '
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
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueOf(json);
        
        RestContext.request = req;
	    RestContext.response = res;
        
        Test.startTest();  
        ServicePedidos.actualizarPedidos();
        Test.stopTest();
    }
}