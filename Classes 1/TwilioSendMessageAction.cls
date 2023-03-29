global class TwilioSendMessageAction {

    @InvocableMethod(label='Send Messages SMS' description='Send Messages From Process Builder' category='Messaging')
    global static void sendMessages (RecordActionData[] recordDatas) {

        // Get the sObject token from the first ID
        // (the List contains IDs of sObjects of the same type).
        Id recordIdType = recordDatas[0].recordId;
        Schema.SObjectType token = recordIdType.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();

        Set<Id> setIds = new Set<Id>();

        for (RecordActionData actionData : recordDatas) {
            setIds.add(actionData.recordId);
        }

        String queryString = 'SELECT Id, ' + recordDatas[0].toPhonefield; 
        queryString += ' FROM ' + dr.getName() + 
                        ' WHERE Id IN: setIds';
        
        System.debug('Query String ' + queryString);

        Map<Id, SObject> mapRecordsById = new Map<Id, SObject>((List<SObject>) Database.query(queryString) );

        for (RecordActionData actionData : recordDatas) {

            SObject record = mapRecordsById.get(actionData.recordId);
            System.debug('toPhoneNumber: ' + record.get(actionData.toPhonefield));
            System.debug('messageBody' + actionData.messageBody);
            
            TwilioClient.sendSimpleSMSAsync(String.valueOf(record.get(actionData.toPhonefield)),actionData.messageBody);
        }
    }
	
    @testVisible
    global class RecordActionData {

        @InvocableVariable(required=true)
        global String recordId;
        
        @InvocableVariable(required=true)
        global String toPhonefield;
        
        @InvocableVariable(required=true)
        global String messageBody;
        
    }
}