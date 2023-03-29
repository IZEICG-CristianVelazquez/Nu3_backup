@Istest
public class FacturaServiceTest {

    @IsTest
    static void whenCallSAPUpsertInvoices(){
        fflib_ApexMocks mocks = new fflib_ApexMocks(); 

        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        AccountsSelector accountsSel    = (AccountsSelector) mocks.mock(AccountsSelector.class);
        AgentesSelector agentesSel      = (AgentesSelector) mocks.mock(AgentesSelector.class);
        OrdersSelector ordersSel        = (OrdersSelector) mocks.mock(OrdersSelector.class);
        ProductsSelector productsSel    = (ProductsSelector) mocks.mock(ProductsSelector.class);
        FacturasSelector facturasSel    = (FacturasSelector) mocks.mock(FacturasSelector.class);

        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id account2Id = fflib_IDGenerator.generate(Account.SObjectType);
        Id agenteId = fflib_IDGenerator.generate(Agente__c.SObjectType);
        Id orderId = fflib_IDGenerator.generate(Order.SObjectType);
        Id facturaId = fflib_IDGenerator.generate(Factura__c.SObjectType);
        Id productoId = fflib_IDGenerator.generate(Product2.SObjectType);
        Id userId = fflib_IDGenerator.generate(User.SObjectType);


        Account acc = new Account(
            Id = accountId,
            Clave_cliente__c = 'NU3C8568'
        );

        Account acc2 = new Account(
            Id = account2Id,
            Clave_cliente__c = 'NU3C7252'
        );

        /* Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; */
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];


        User usr = new User(
            Id = userId,
            Alias = 'sysad', 
            Email='test@test.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='test@test.com'+DateTime.now().getTime()
        );

        Agente__c agent = new Agente__c(
            ID_de_Agente__c = '57',
            Vendedor__c = usr.Id
        );

        Order ord = new Order(
            ID_Externo__c = 344146 + 'NU3',
            Account = acc
        );

        Factura__c fac = new Factura__c(
            ID_Externo__c = '1344146NU3'
        );

        Product2 product = new Product2(
            Id = productoId,
            ProductCode = '22530',
            IsActive = true
        );

        Product2 producto2 = new Product2(
            Id = productoId,
            ProductCode = '50116-AD',
            IsActive = true
        );

        mocks.startStubbing();

        mocks.when(accountsSel.SObjectType())
            .thenReturn(Account.SObjectType); 
        mocks.when(accountsSel.selectByExternalId(new Set<String>{'NU3C8568','NU3C7252'},15000))
            .thenReturn(new List<Account>{acc,acc2});

        mocks.when(agentesSel.SObjectType())
            .thenReturn(Agente__c.SObjectType); 
        mocks.when(agentesSel.selectByIdDeAgente(new Set<String>{'13','57'}))
            .thenReturn(new List<Agente__c>{agent});
        
        mocks.when(ordersSel.SObjectType())
            .thenReturn(Order.SObjectType); 
        mocks.when(ordersSel.selectByExternalId(new Set<String>{'344146NU3','337763NU3'}))
            .thenReturn(new List<Order>{ord});

        mocks.when(facturasSel.SObjectType())
            .thenReturn(Factura__c.SObjectType); 
        mocks.when(facturasSel.selectByIdExterno(new Set<String>{'1344146NU3','1337763NU3'}))
            .thenReturn(new List<Factura__c>{fac});
 
        mocks.when(productsSel.SObjectType())
            .thenReturn(Product2.SObjectType); 
        mocks.when(productsSel.selectByProductCode(new Set<String>{'22530','50116-AD'},15000))
            .thenReturn(new List<Product2>{product,producto2});

        mocks.stopStubbing();
        
        Application.Selector.setMock(accountsSel);
        Application.Selector.setMock(agentesSel);
        Application.Selector.setMock(ordersSel);
        Application.Selector.setMock(facturasSel);
        Application.Selector.setMock(productsSel);
        Application.UnitOfWork.setMock(mockUow);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(getResponse()));
        FacturaService.syncInvoicesSap();

    }

    private static String getResponse(){
        return '{'
                +   '"Pedidos":['
                +      '{'
                +         '"Referencia":"12345",'
                +         '"U_VentaDelCU":"S/A",'
                +         '"U_Tipo":null,'
                +         '"U_Tarifa":"0.000000",'
                +         '"U_TarCam":"0.000000",'
                +         '"U_metodoDePagoCFD":"S/A",'
                +         '"U_LE":null,'
                +         '"U_Flete":"02",'
                +         '"U_EmpresaFinanciera":"MiEmpresa",'
                +         '"Status":null,'
                +         '"SlpCode":13,'
                +         '"ShipToCode":null,'
                +         '"Series":59,'
                +         '"Project":"VPE002",'
                +         '"Productos":['
                +            '{'
                +               '"TaxCode":"IVAT0001",'
                +               '"SlpCode":13,'
                +               '"Project":null,'
                +               '"Price":"8.220000",'
                +               '"ItemCode":"22530",'
                +               '"IdSalesforce":null,'
                +               '"Factor1":"5.000000",'
                +               '"DiscPrcnt":"0.000000",'
                +               '"IdSap":344146'
                +            '}'
                +         '],'
                +         '"JrnlMemo":null,'
                +         '"IdFacSap":1344146,'
                +         '"IdSalesforce":null,'
                +         '"DocDueDate":"2019-07-26",'
                +         '"DocDate":"2019-07-26",'
                +         '"DiscPrcnt":null,'
                +         '"Comments":"VIENE POR EL",'
                +         '"CardCode":"C8568",'
                +         '"BusUnit":"NU3"'
                +      '},'
                +      '{'
                +         '"U_VentaDelCU":"S/A",'
                +         '"U_Tipo":null,'
                +         '"U_Tarifa":"0.000000",'
                +         '"U_TarCam":"0.000000",'
                +         '"U_metodoDePagoCFD":"S/A",'
                +         '"U_LE":null,'
                +         '"U_Flete":"02",'
                +         '"U_EmpresaFinanciera":"LaFinanciera",'
                +         '"Status":null,'
                +         '"SlpCode":57,'
                +         '"ShipToCode":null,'
                +         '"Series":59,'
                +         '"Project":"VGP018",'
                +         '"Productos":['
                +            '{'
                +               '"TaxCode":"IVAT1601",'
                +               '"SlpCode":130,'
                +               '"Project":null,'
                +               '"Price":"37.170000",'
                +               '"ItemCode":"50116-AD",'
                +               '"IdSalesforce":null,'
                +               '"Factor1":"25.000000",'
                +               '"DiscPrcnt":"37.000000",'
                +               '"IdSap":337763'
                +            '}'
                +         '],'
                +         '"JrnlMemo":null,'
                +         '"IdFacSap":1337763,'
                +         '"IdSalesforce":null,'
                +         '"DocDueDate":"2019-07-26",'
                +         '"DocDate":"2019-07-26",'
                +         '"DiscPrcnt":null,'
                +         '"Comments":"V\u00eda estafeta en un solo pallet",'
                +         '"CardCode":"C7252",'
                +         '"BusUnit":"NU3"'
                +      '}'
                +   ']'
            +'}';
    }

}