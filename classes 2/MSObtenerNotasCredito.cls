public with sharing class MSObtenerNotasCredito {
    private static final String GET = 'GET';
    private static final String ENDPOINT = '/nc/';

    public NotasCreditoJSON obtenerNotasCredito () {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);
        System.debug(JSON.serialize(res.getBody()));
             NotasCreditoJSON result = NotasCreditoJSON.parse(res.getBody());

        return result;

    }
}