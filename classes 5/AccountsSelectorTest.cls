@isTest
public class AccountsSelectorTest {
    @IsTest
    static void whenSelectByIdReturnRecords(){
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        AccountsSelector.newInstance().selectById(new Set<Id>{accountId});
    }

    @IsTest
    static void whenSelectRecentlyUpdated(){
        AccountsSelector.newInstance().selectRecentlyUpdated(10);
        
    }

    @IsTest
    static void whenSelectByExternalIdReturnRecords(){
        AccountsSelector.newInstance().selectByExternalId(new Set<String>{'test'}, 10);
        
    }
}