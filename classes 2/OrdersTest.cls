@IsTest
public class OrdersTest {
    @IsTest
    static void whenCreateOrderUpdateDocumentSerieField(){
        /* Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; */
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema'];

        User usr = new User(
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
        
        System.runAs(usr){
            fflib_ApexMocks mocks = new fflib_ApexMocks(); 

            AccountsSelector accsSelector = (AccountsSelector) mocks.mock(AccountsSelector.class);
            PermissionSetAssignmentsSelector psaSelector = (PermissionSetAssignmentsSelector) mocks.mock(PermissionSetAssignmentsSelector.class);


            Id accountId = fflib_IDGenerator.generate(Account.SObjectType);

            PermissionSet ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'Encuestas'];

            Account acc = new Account(
                Id = accountId,
                Base_de_Datos__c = Constants.ACCOUNT_DATABASE_LAGOS
            );

            Order ord = new Order (
                AccountId = accountId,
                EffectiveDate = Date.today(),
                Descuento_general__c = 0.05,
                Status='Cotización',
                ID_Externo__c='123456',
                Admin_Ventas_MP__c = false,
                Gerente_MP__c = false,
                Gerente_Alimentos_Balanceados__c = false,
                Incluye_flete__c = true,
                Costo_flete__c =100.00,
                Factor_flete_SAP__c = 1,
                Tipo_de_Unidad__c ='Camioneta',
                Banda_asignada__c = '',
                And_n_asignado__c = '',
                OwnerId = UserInfo.getUserId()
            );

            PermissionSetAssignment psa = new PermissionSetAssignment(
                AssigneeId = UserInfo.getUserId(),
                PermissionSet = ps
            );

            mocks.startStubbing();

            mocks.when(accsSelector.SObjectType())
            .thenReturn(Account.SObjectType); 
            mocks.when(accsSelector.selectById(new Set<Id>{accountId}))
            .thenReturn(new List<Account>{acc});

            mocks.when(psaSelector.SObjectType())
            .thenReturn(PermissionSetAssignment.SObjectType); 
            mocks.when(psaSelector.selectByAssigneeIdWithPermissionSet(new Set<Id>{UserInfo.getUserId()}))
            .thenReturn(new List<PermissionSetAssignment>{psa});

            mocks.stopStubbing();

            Application.Selector.setMock(accsSelector);
            Application.Selector.setMock(psaSelector);


            fflib_SObjectDomain.Test.Database.onInsert(new Order[] { ord } );
            fflib_SObjectDomain.triggerHandler(Orders.class);

        }
    }

    @IsTest
    static void whenUpdateOrderNotifyAndCreateEncuestas(){

/*         fflib_ApexMocks mocks = new fflib_ApexMocks(); 

        RegistroChoferesPedidosSelector rcpSelector = (RegistroChoferesPedidosSelector) mocks.mock(RegistroChoferesPedidosSelector.class); */

        /* Id rcpId = fflib_IDGenerator.generate(Registro_Choferes_Pedidos__c.SObjectType); */
        Id pricebookId = Test.getStandardPricebookId();


        
        Encuesta__c enc  = new Encuesta__c(
            Name = 'Encuesta de satisfacción',
            pregunta__c ='isTest?'
        );

        insert enc;

        Account acc = new Account(
            Name = 'testAcocunt',
            Estatus_de_cuenta__c = 'Activo',
            Phone = '1234567892'
        );
        insert acc;

        System.debug('Account: '+acc.Id);
        
        Order ord = new Order(
            AccountId = acc.Id,
            EffectiveDate =  Date.newInstance(1960, 2, 17),
            Fecha_de_facturacion__c =  null,
            Comentarios__c = 'COMMENTARIO',
            Status = 'Cotización',
            Empresa_Financiera__c = null,
            Serie_del_Documento2__c = '93', 
            Tipo_de_pago__c = 'Efectivo',
            Flete_Facturado__c = 10.00,
            ID_Externo__c = 344257 + 'NU3',
            Pricebook2Id = pricebookId

        );
        insert ord;


        Product2 p1 = new Product2(
            Name = 'Producto prueba', 
            ProductCode = '21720',
            Kilogramos_unidad__c=24);

        insert p1;

        Pricebook2 pb1 = new Pricebook2(
            Name='Custom Pricebook', 
            isActive=true
        );
        insert pb1;


        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p1.Id;
        pbe.IsActive = true;
        pbe.PriceBook2 = pb1;
        pbe.UnitPrice = 10.00;
        pbe.Pricebook2Id = pricebookId;

        insert pbe;

/*         Contact ctc = new Contact();
        ctc.LastName = 'LastName test';
        ctc.MobilePhone = '+527713830985';
        ctc.AccountId = acc.Id;
        insert ctc;

        Registro_Choferes_Pedidos__c rcp = new Registro_Choferes_Pedidos__c(
            Id = rcpId,
            Pedido__r = ord,
            Chofer__c = ctc.Id,
            Estatus__c = 'Pendiente de confirmación'
        );

        mocks.startStubbing();
        mocks.when(rcpSelector.SObjectType())
        .thenReturn(Registro_Choferes_Pedidos__c.SObjectType); 
        mocks.when(rcpSelector.selectToControlRCP())
        .thenReturn(new List<Registro_Choferes_Pedidos__c>{rcp});

        mocks.stopStubbing(); */

        OrderItem orderItem = new OrderItem();        
        orderItem.OrderId = ord.Id;
        orderItem.UnitPrice = 9.0;
        orderItem.Quantity = 1200;
        orderItem.PricebookEntryId = pbe.Id;
        orderItem.Descuento_SAP__c = 12.0;

        insert orderItem;

/*         ord.Status = 'Revisado';

        update ord; */
        /* Application.Selector.setMock(rcpSelector); */


        String body = '{"success":true}';
        
        MockHttpResponseGenerator mockMicroSer = new MockHttpResponseGenerator(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Test.startTest();

        System.debug('pedido status: '+ord.Status);

        ord.Status = 'Facturado';
        update ord;

        Test.stopTest();


    }
}