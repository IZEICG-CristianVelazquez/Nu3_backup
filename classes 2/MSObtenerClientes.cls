public with sharing class MSObtenerClientes {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/clientes/';

    public ClientesJSON obtenerClientes () {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);
      
        ClientesJSON result = ClientesJSON.parse(res.getBody());

        return result;

    }
}