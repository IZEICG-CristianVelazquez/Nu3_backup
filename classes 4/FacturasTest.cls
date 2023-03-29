@IsTest
public class FacturasTest {
    
    @IsTest
    static void whenCreateFacturaUpdateAccountAndFacturaFields(){
        fflib_ApexMocks mocks = new fflib_ApexMocks(); 

        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        AccountsSelector accsSelector = (AccountsSelector) mocks.mock(AccountsSelector.class);

        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id accountWithDateId = fflib_IDGenerator.generate(Account.SObjectType);

        Account acc = new Account(
            Id = accountId
        );

        Account accWithDate = new Account(
            Id = accountWithDateId,
            Fecha_Primer_Factura__c = System.today()
        );
        
        Factura__c factura = new Factura__c(
            Fecha_de_Facturaci_n__c = System.today(),
            Nombre_de_la_Cuenta__c = accountId,
            RecordTypeId = Constants.FACT_RT_FACTURA_ID
        );

        Factura__c facturaWithAccountWithDate = new Factura__c(
            Fecha_de_Facturaci_n__c = System.today(),
            Nombre_de_la_Cuenta__c = accountWithDateId,
            RecordTypeId = Constants.FACT_RT_FACTURA_ID
        );

        mocks.startStubbing();

        mocks.when(accsSelector.SObjectType())
            .thenReturn(Account.SObjectType); 
        mocks.when(accsSelector.selectById(new Set<Id>{accountId,accountWithDateId}))
            .thenReturn(new List<Account>{acc,accWithDate});

        mocks.stopStubbing();

        Application.Selector.setMock(accsSelector);
        Application.UnitOfWork.setMock(mockUow);

        fflib_SObjectDomain.Test.Database.onInsert(new Factura__c[] { factura,facturaWithAccountWithDate } );
        fflib_SObjectDomain.triggerHandler(Facturas.class);

        ((AccountsSelector) mocks.verify(accsSelector, 2))
            .selectById(new Set<Id>{accountId,accountWithDateId}); 
    }
}