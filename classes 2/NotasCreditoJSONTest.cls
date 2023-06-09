//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class NotasCreditoJSONTest {
	
	static testMethod void testParse() {
		String json = '{ \"Pedidos\": [ { \"U_VentaDelCU\": \"Grand Pet\", \"U_Tipo\": \"\", \"U_Tarifa\": \"0.000000\", \"U_TarCam\": \"0.000000\", \"U_metodoDePagoCFD\": \"S\\/A\", \"U_LE\": \"\", \"U_Flete\": \"02\", \"U_EmpresaFinanciera\": \"MiEmpresa\", \"Status\": null, \"SlpCode\": 110, \"ShipToCode\": null, \"Series\": 94, \"Project\": \"VGP020\", \"Productos\": [ { \"IdFacSap\": 0, \"TaxCode\": \"IVAT1601\", \"SlpCode\": 110, \"Project\": null, \"Price\": \"1,265.980000\", \"ItemCode\": \"4200-0300-0002\", \"IdSalesforce\": null, \"Factor1\": \"1.000000\", \"Kilos\": \"1.00\", \"DiscPrcnt\": \"0.000000\", \"GrssProfit\": \"1,265.980000\" } ], \"JrnlMemo\": null, \"DocumentoBase\": null, \"IdNCSap\": 2044476, \"IdSalesforce\": null, \"DocDueDate\": \"2019-10-09\", \"DocDate\": \"2019-10-09\", \"UpdateDate\": \"2019-10-09\", \"DiscPrcnt\": null, \"Flete\": \"0.00\", \"Listadeprecios\": \"Lista de precios base\", \"Comments\": \"2% PP FACTURA 256618.\", \"CardCode\": \"C5050\", \"NumNC\": \"44476\", \"Estatus\": \"C\", \"CANCELED\": \"N\", \"BusUnit\": \"NU3\" } ], \"Cantidad\": 1 }';
		NotasCreditoJSON obj = NotasCreditoJSON.parse(json);
		System.assert(obj != null);
	}
}