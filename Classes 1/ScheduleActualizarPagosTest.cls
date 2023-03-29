@isTest
private class ScheduleActualizarPagosTest {
    
    @isTest
    private static void runSchedule () {
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(JSONPagosResponse_Test.getJson()));
        
        Test.startTest();
        ScheduleActualizarPagos sch = new ScheduleActualizarPagos();
        sch.execute(null);
        Test.stopTest();
        
    }

}