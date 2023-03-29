public with sharing class MSObtenerLugaresDeEntrega {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/lugaresdeentrega/';

    public LugaresDeEntregaJSON obtenerLugaresDeEntrega () {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);
      
        LugaresDeEntregaJSON result = LugaresDeEntregaJSON.parse(res.getBody());

        return result;

    }

}