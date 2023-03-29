/**
* Test Method de la clase ScheduleObtenerProductos
*
* @author  Mauricio Rosales
* @version 1.0
* @since   2020-07-31
*/
@isTest
public class ScheduleObtenerProductosTest {

    static String CRON_EXP = '0 0 0 15 3 ? *';

    @testSetup 
    private static void setupData() {

        Product2 producto2 = new Product2();
        producto2.Name = 'Producto prueba';
        producto2.ProductCode = '6401-0100-0002';
        producto2.Kilogramos_unidad__c = 123.0;
        producto2.Codigo_Impuesto__c = 'IVAT1601';
        producto2.Grupo_de_art_culos__c='101';
        producto2.IsActive = true;
        insert producto2;
    }

    @isTest
    private static void ScheduleObtenerProductos(){

        String body = '{ "Articulos": [ { "ItemCode": "6401-0100-0001", "ItemName": "Cuota de Produccion - Gastos Estimados", "SalFactor2": 1, "U_IvaVenta": "", "SalUnitMsr": "", "BusUnit": "NU3_CabNutres_Veracruz" }, ';
        body += '{ "ItemCode": "6401-0100-0002", "ItemName": "Cuota de Produccion - Gastos Estimados2", "SalFactor2": 2, "U_IvaVenta": "", "SalUnitMsr": "", "BusUnit": "NU3_CabNutres_Veracruz" } ] }';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(body));

        Test.startTest();

            String jobId = System.schedule('ActualizarProductos',  CRON_EXP, new ScheduleObtenerProductos());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}