@IsTest
public class AccountsTest {
    @IsTest
    static void initializeDomain(){
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Accounts.newInstance(new List<Account>());
        Accounts.newInstance(new Set<Id>{accountId});

        String key = Accounts.generateAccountKey('test', '123');
        System.assertEquals('TEST123', key);
    }
}