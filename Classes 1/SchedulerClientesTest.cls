@isTest
public with sharing class SchedulerClientesTest {

    static String CRON_EXP = '0 0 0 15 3 ? *';
    

    @testSetup 
    private static void setupData () {
		
		Account acc = new Account();
		acc.Name = 'Test123';
		acc.Id_SAP__c = 'C0';
		acc.Clave_cliente__c = 'INPROC0';
		insert acc;
    }

    static testmethod void schedulerActualizarClientes ()  {
        String body = getRequest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('ActualizarClientes',  CRON_EXP, new SchedulerActualizarclientes());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }

	static testmethod void schedulerActualizarClientesWithGroup ()  {
        String body = getRequest().replace('INPRO', 'test');

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('ActualizarClientes',  CRON_EXP, new SchedulerActualizarclientes());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }

     
    private static String getRequest(){
		return '{'+
		'  \"Clientes\": ['+
		'    {'+
		'      \"CardCode\": \"C0\",'+
		'      \"CardName\": \"Abarrotera Fuentes SA de CV\",'+
		'      \"ListNum\": 1,'+
        '      \"Email\": "test@gmail.com",'+
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
		'      \"BusUnit\": \"INPRO\"'+
		'    }'+
		']'+
		'}';
	}
}