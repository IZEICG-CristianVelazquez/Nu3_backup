trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(Accounts.class);
}