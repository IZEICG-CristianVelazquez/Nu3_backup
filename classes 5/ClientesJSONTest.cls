@isTest
public with sharing class ClientesJSONTest {
    @isTest
    static void testParse() {
		String json = '{'+
		'  \"Clientes\": ['+
		'    {'+
		'      \"CardCode\": \"C1\",'+
		'      \"CardName\": \"Abarrotera Fuentes SA de CV\",'+
		'      \"ListNum\": 1,'+
		'      \"Direcciones\": ['+
		'        {'+
		'          \"ID de direccion\": \"Direccion Fiscal\",'+
		'          \"Street\": \"Carr Fed Mexico Cuautla No. 151 Bod. Int 13 y 14 Nave A\",'+
		'          \"City\": \"Tetelcingo, Cuautla\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": \"62751\",'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"B\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"GALEANA\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"GALEANA (ZACATEPEC)\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"IXTLA\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"IXTLA(MORELOS)\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"JOJUTLA\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"JOJUTLA (MORELOS)\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"PLAZA DEL SOL\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"CUERNAVACA\",'+
		'          \"State\": \"\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"ZACATEPEC\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"ZACATEPEC MORELOS\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"CIUDAD AZTECA\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"CIUDAD AZTECA\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"CUAUTLA\",'+
		'          \"Street\": \"Carr Fed Mexico Cuautla No. 151 Bod. Int 13 y 14 Nave A\",'+
		'          \"City\": \"Tetelcingo, Cuautla\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": \"62751\",'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        },'+
		'        {'+
		'          \"ID de direccion\": \"CUERNAVACA\",'+
		'          \"Street\": \"\",'+
		'          \"City\": \"CUERNAVACA(MORELOS)\",'+
		'          \"State\": \"MOR\",'+
		'          \"ZipCode\": null,'+
		'          \"Country\": \"MX\",'+
		'          \"AdresType\": \"S\"'+
		'        }'+
		'      ],'+
		'      \"LicTradNum\": \"AFU920102U58\",'+
		'      \"Phone\": \"01 735 35 3 18 07\",'+
		'      \"SlpCode\": 110,'+
		'      \"ProjectCod\": \"VGP048\",'+
		'      \"Activo\": \"Y\",'+
		'      \"ClienteSalesForce\": \"\",'+
		'      \"Grupo\": 114,'+
		'      \"Flete\": 114,'+
		'      \"Balance\": 114,'+
		'      \"CreditLine\": 114,'+
		'      \"BusUnit\": \"NU3\"'+
		'    }'+
		']'+
		'}';
		ClientesJSON obj = ClientesJSON.parse(json);
		System.assert(obj != null);

	}

}