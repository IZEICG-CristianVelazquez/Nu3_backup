@isTest
private class TwilioSendMessageActionTest {

    @isTest
    private static void sendMessages () {
        
        Contact cont = new Contact(LastName = 'TEST', Mobilephone = '4424000000');
        insert cont;
		
		String body = '{"success":true}';

        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Test.startTest();
        
        TwilioSendMessageAction.RecordActionData rd = new TwilioSendMessageAction.RecordActionData();
        rd.messageBody = 'Prueba';
		rd.recordId = cont.Id;
		rd.toPhonefield = 'Mobilephone';
        TwilioSendMessageAction.sendMessages(new List<TwilioSendMessageAction.RecordActionData>{rd});
        
        Test.stopTest();

    }
}