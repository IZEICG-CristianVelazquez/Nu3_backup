public class ClienteSAP {

    private final String BASE_URL = 'https://apis.gruponu3.com';
    private final String URI = '';
    private final String APP_JSON = 'application/json';
    private final String CONT_TYPE = 'Content-Type';
    private final Integer TIME_OUT = 120000;
    private String endpoint = '/pedidosnuevossap/';
    private String method = 'GET';


    public ClienteSAP () {
       
    }

    
    public void setEndpoint (String endpoint) {
        
        this.endpoint = endpoint;

    }

    public void setMethod (String method) {
        
        this.method = method;

    }
    

    public HttpRequest crearRequest (Map<String, String> params) {
              
        String url = BASE_URL + endpoint;
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);

        if (params != null && !params.isEmpty()) {

            req.setBody(JSON.serialize(params));

        }
        
        req.setMethod(method);
        req.setTimeout(TIME_OUT);
        req.setHeader(CONT_TYPE, APP_JSON);
       
        System.debug('REQ: ' + req);
        System.debug('req.getBody():  ' + req.getBody() );
        return req;

    }

    public HttpResponse enviarRequest (HttpRequest req) {

        Http http = new Http();
        return http.send(req);

    }

}