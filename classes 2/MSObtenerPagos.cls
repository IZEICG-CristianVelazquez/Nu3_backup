public class MSObtenerPagos {
    
    private static final String GET = 'GET';
    private static final String ENDPOINT = '/cobranza/';

    public JSONPagosResponse obtenerPagos() {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        String endPointParams = ENDPOINT;
        cliente.setEndpoint(endPointParams);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);

        JSONPagosResponse result = JSONPagosResponse.parse(res.getBody());

        return result;

    }

}