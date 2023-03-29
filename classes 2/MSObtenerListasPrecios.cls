public with sharing class MSObtenerListasPrecios {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/listadeprecios/';
    private static final String PRICE_LIST = 'PriceList';
    private static final String BUS_UNIT = 'BusUnit';

    public ListasPreciosJSON obtenerListasPrecios (String priceList, String busUnit) {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT + '?' + PRICE_LIST + '=' + priceList + '&&' + BUS_UNIT + '=' + busUnit);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);

        //String body = '{ "Articulos": [ { "ItemCode": "6401-0100-0001", "ItemName": "Cuota de Produccion - Gastos Estimados", "SalFactor2": 1, "U_IvaVenta": "", "SalUnitMsr": "", "BusUnit": "NU3_CabNutres_Veracruz" } ] }';

        ListasPreciosJSON result = ListasPreciosJSON.parse(res.getBody());

        return result;

    }

}