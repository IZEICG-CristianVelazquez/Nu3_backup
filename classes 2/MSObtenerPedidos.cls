public class MSObtenerPedidos {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/pedidosnuevossap/';

    public PedidosJSON obtenerPedidos(String horaInicial, String horaFinal) {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        String endPointParams = ENDPOINT + '?horainicial=' + horaInicial + '&horafinal=' + horaFinal;
        cliente.setEndpoint(endPointParams);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);
        //String body = '{"Pedidos":[{"U_VentaDelCU": "N/A","U_Tipo": "S/A","U_Tarifa": "0.000000","U_TarCam": null,"U_metodoDePagoCFD": null,"U_LE": "Union de San Antonio","U_Flete": "","U_EmpresaFinanciera": "MiEmpresa","Status": null,"SlpCode": 25,"ShipToCode": null,"Series": 9,"Project": "16","Productos": [{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "6.150000","ItemCode": "21950","IdSalesforce": null,"Factor1": "87.000000","Kilos": "1,890.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "7.080000","ItemCode": "22230","IdSalesforce": null,"Factor1": "5.000000","Kilos": "2.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "6.060000","ItemCode": "21940","IdSalesforce": null,"Factor1": "21.000000","Kilos": "840.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "5.230000","ItemCode": "21070","IdSalesforce": null,"Factor1": "3.000000","Kilos": "120.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "5.800000","ItemCode": "21040","IdSalesforce": null,"Factor1": "1.000000","Kilos": "40.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "6.800000","ItemCode": "22350","IdSalesforce": null,"Factor1": "1.000000","Kilos": "40.00","DiscPrcnt": "0.000000"},{"TaxCode": "IVAT0001","SlpCode": 25,"Project": null,"Price": "4.960000","ItemCode": "21890","IdSalesforce": null,"Factor1": "11.000000","Kilos": "440.00","DiscPrcnt": "0.000000"}],"JrnlMemo": null,"IdSap": 55015,"IdSalesforce": null,"DocDueDate": "2019-12-11","DocDate": "2019-12-11","DiscPrcnt": null,"Comments": "","CardCode": "c11991","BusUnit": "NU3_AgropecuariaPiedadense_LAGOS","Referencia": "191852"}],"Cantidad":167}],"Cantidad":167}';

        PedidosJSON result = PedidosJSON.parse(res.getBody());

        return result;

    }

}