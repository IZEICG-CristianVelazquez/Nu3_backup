@isTest
public with sharing class SchedulerInsertarNotasCreditoTest {
    static String CRON_EXP = '0 0 0 15 3 ? *';
    static String body = '{ \"Pedidos\": [{\"U_VentaDelCU\": \"Grand Pet\",\"U_Tipo\": \"\",'
    +'\"U_Tarifa\": \"0.000000\",\"U_TarCam\": \"0.000000\",\"U_metodoDePagoCFD\": \"S\\/A\",'
    +'\"U_LE\": \"\",\"U_Flete\": \"02\",\"U_EmpresaFinanciera\": \"MiEmpresa\",\"Status\": null,'
    +'\"SlpCode\": 9,\"ShipToCode\": null,\"Series\": 94,\"Project\": \"VGP009\",'
    +'\"Productos\": [{\"TaxCode\": \"IVAT1601\",\"SlpCode\": 9,\"Project\": null,'
    +'\"Price\": \"13.180000\",\"ItemCode\": \"50589\",\"IdSalesforce\": null,'
    +'\"Factor1\": \"490.000000\",\"Kilos\": \"490.00\",\"DiscPrcnt\": \"0.000000\"}],'
    +'\"JrnlMemo\": null,\"DocumentoBase\": 2252816,\"IdNCSap\": 2043491,'
    +'\"IdSalesforce\": null,\"DocDueDate\": \"2019-08-26\",\"DocDate\": \"2019-08-26\",'
    +'\"DiscPrcnt\": null,\"Flete\": \"0.00\",\"Listadeprecios\": \"Lista de precios base\",'
    +'\"Comments\": \"DEVOL. SACOS ROTOS, APT, FOLIO 008180 Facturas clientes 2252816.\",'
    +'\"CardCode\": \"C8423\",\"NumNC\": \"43491\",\"Estatus\": \"C\",\"CANCELED\": \"Y\",\"BusUnit\": \"NU3\",\"CreateTS\": 170000}]}';
    @testSetup 
    private static void setupData () {

      Product2 product = new Product2(
        ProductCode = '50589',
         Name = 'TestProduct',
         IsActive = true
      );
      insert product;
      

      /* Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; */
      Profile profile = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];


      User usr = new User(
          Alias = 'sysad', 
          Email='test@test.com',
          EmailEncodingKey='UTF-8', 
          LastName='Testing', 
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          ProfileId = profile.Id,
          TimeZoneSidKey='America/Los_Angeles',
          UserName='test@test.com'+DateTime.now().getTime()
      );

      insert usr;

      Agente__c agent = new Agente__c(
          ID_de_Agente__c = '9',
          Vendedor__c = usr.Id,
          Canal__c = 'test'
      );

      insert agent;

      Account acc = new Account(Name = 'Test',Clave_cliente__c='NU3C8423'); 
      insert acc;
    }


        
     static testmethod void schedulerInsertarNC ()  {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('InsertarNotasCredito',  CRON_EXP, new SchedulerInsertarNotasCredito());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
           //SchedulerInsertarNotasCredito.prueba();


        Test.stopTest();
     }

}