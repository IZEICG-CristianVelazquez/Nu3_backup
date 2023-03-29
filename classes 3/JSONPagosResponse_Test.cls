//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class JSONPagosResponse_Test {
	
    public static String getJson () {
        return '{ \"TotalPagosSAP\": [  { \"#Pago\": 370593, \"Cancelada\": \"N\", \"EstatusFactura\": \"C\", \"#Factura\": 2289497, \"FechaPago\": \"02-10-2020\", \"FechaVencimientoFactura\": \"02-10-2020\", \"CardCode\": \"C110\", \"TotalPago\": \"350.97\", \"TotalFactura\": \"350.97\", \"TotalPagadoFactura\": \"350.97\", \"BaseDatos\": \"NU3\" } ], \"TotalRegistros\": 40 }';
    }
    
	static testMethod void testParse() {
		String json = getJson();
        JSONPagosResponse obj = JSONPagosResponse.parse(json);
        
        for (JSONPagosResponse.TotalPagosSAP pago : obj.TotalPagosSAP) {
            System.debug('obj ' + pago.Pago);
        	System.debug('obj ' + pago.Factura);
        }
        
		System.assert(obj != null);
	}
}