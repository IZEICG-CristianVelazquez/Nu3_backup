public class MSObtenerProductos {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/productos/';

    public ProductosJSON obtenerProductos () {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);

        //String body = '{ "Articulos": [ { "ItemCode": "6401-0100-0001", "ItemName": "Cuota de Produccion - Gastos Estimados", "SalFactor2": 1, "U_IvaVenta": "", "SalUnitMsr": "", "BusUnit": "NU3_CabNutres_Veracruz" } ] }';

        ProductosJSON result = ProductosJSON.parse(res.getBody());

        return result;

    }

}