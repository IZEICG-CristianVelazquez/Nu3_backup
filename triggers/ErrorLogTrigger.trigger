trigger ErrorLogTrigger on Error_Log__c (before insert,after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(ErrorLog.class);
}