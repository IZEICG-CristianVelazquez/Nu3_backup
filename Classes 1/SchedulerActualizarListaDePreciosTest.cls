@isTest
private class SchedulerActualizarListaDePreciosTest {

    @testSetup
    private static void testData () {
        
        Pricebook2 pb = new Pricebook2();
        
        pb.Lista_de_precios_SAP__c = 1;
        pb.Base_de_Datos__c = 'NU3';
        pb.Name = 'nu3';
        
        insert pb;
        
        Product2 prod = new Product2();
        prod.Name = '234';
        prod.ProductCode = '71012-AC';
        
        insert prod;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 12;
        
        insert pbe;
        
        pbe = new PricebookEntry();
        pbe.Pricebook2Id = pb.Id;
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 12;
        
        insert pbe;
    }
    
    @isTest
    private static void testScheduler () {
        
        
        
        String body = '{"Listadeprecios": "2.0","BusUnit": "NU3","Articulos": [{"ItemCode": "71012-AC","Price": 78.43}]}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        try {
            
            Test.startTest();
            
            SchedulerActualizarListaDePrecios sch = new SchedulerActualizarListaDePrecios();
            sch.execute(null);
            
            Test.stopTest();
            
        } catch (Exception e) {
            
        }
        
        
    }
    
    
    @isTest
    private static void testSchedulerFail () {
        	
        
        String body = '<null';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Test.startTest();
        
        SchedulerActualizarListaDePrecios sch = new SchedulerActualizarListaDePrecios();
        sch.execute(null);
        
        Test.stopTest();
        
      
            
        
        
        
    }
    
    
}