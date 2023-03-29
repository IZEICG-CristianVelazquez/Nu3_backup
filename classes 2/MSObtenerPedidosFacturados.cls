public class MSObtenerPedidosFacturados {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/facturas/';
    
    //https://apispruebas.gruponu3.com/facturas/?horainicial=100000&horafinal=110000

    public FacturasJSON obtenerPedidos (String horaInicial, String horaFinal) {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        String endPointParams = ENDPOINT + '?horainicial=' + horaInicial + '&horafinal=' + horaFinal;
        cliente.setEndpoint(endPointParams);
		
        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);
       // String body = '{ "Pedidos": [ { "IdFacSap": 9090909, "U_VentaDelCU": "Pecuarios", "U_Tipo": "03", "U_Tarifa": "0.240000", "U_TarCam": "0.000000", "U_metodoDePagoCFD": "Efectivo", "U_LE": "SN JULIAN JAL.", "U_Flete": "01", "U_EmpresaFinanciera": "MiEmpresa", "Status": null, "SlpCode": 16, "ShipToCode": null, "Series": 93, "Project": "VPE005", "Productos": [ { "ItemCode": "21720", "IdSAP": "707070", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.800000", "IdSalesforce": null, "Factor1": "375.000000", "Kilos": "15,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "11274.440000", "LineNum": 0 }, { "ItemCode": "21160", "IdSAP": "707070", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "5.980000", "IdSalesforce": null, "Factor1": "100.000000", "Kilos": "4,000.00", "DiscPrcnt": "0.000000", "GrssProfit": "2954.500000", "LineNum": 1 }, { "ItemCode": "22130", "IdSAP": "707070", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "9.550000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "652.810000", "LineNum": 2 }, { "ItemCode": "22350", "IdSAP": "707070", "Entrega": 319554, "TaxCode": "IVAT0001", "SlpCode": 16, "Project": null, "Price": "6.220000", "IdSalesforce": null, "Factor1": "10.000000", "Kilos": "400.00", "DiscPrcnt": "0.000000", "GrssProfit": "302.080000", "LineNum": 3 } ], "JrnlMemo": null, "IdSalesforce": null, "DocDueDate": "2019-10-25", "DocDate": "2019-09-25", "UpdateDate": "2019-09-25", "DiscPrcnt": null, "Flete": "4,752.00", "Listadeprecios": "Lista de precios base", "Comments": "537816", "CardCode": "C739", "NumFactura": "256349", "Estatus": "O", "Cancelada": "N", "BusUnit": "NU3"} ], "Cantidad": 1 }';
        FacturasJSON result = FacturasJSON.parse(res.getBody());
        return result;

    }

}