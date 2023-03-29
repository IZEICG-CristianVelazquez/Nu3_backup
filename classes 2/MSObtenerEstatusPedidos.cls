public class MSObtenerEstatusPedidos {

    private static final String GET = 'GET';
    private static final String ENDPOINT = '/impresos/';

    public PedidosActualizadosJSON obtenerPedidos () {

        ClienteSap cliente = new ClienteSap();
        cliente.setMethod(GET);
        cliente.setEndpoint(ENDPOINT);

        HttpRequest req = cliente.crearRequest(null);

        HttpResponse res = cliente.enviarRequest(req);

        PedidosActualizadosJSON result = PedidosActualizadosJSON.parse(res.getBody());
        
        return result;

    }

}