@isTest
public with sharing class PedidosControllerTest {

    @TestSetup
    static void setUpData(){
        
        Account a = new Account(Name = 'Prueba',Estatus_de_cuenta__c='Activo');
        insert a;

        Id pricebookId = Test.getStandardPricebookId();

        Order o = new Order(AccountId = a.Id,EffectiveDate = Date.today(),Descuento_general__c = 0.05,Descuento_por_forma_de_pago__c = 0.5,Status='Cotización',Pricebook2Id = pricebookId);
        insert o;

        Product2 p2 = new Product2(Name = 'Producto prueba', ProductCode = '123456');
        insert p2;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = p2.Id;
        pbe.IsActive = true;
        pbe.Pricebook2Id = pricebookId;
        pbe.UnitPrice = 10.00;
        insert pbe;

        Pricebook2 pb2 = new Pricebook2(Id= pbe.Pricebook2Id);
        pb2.IsActive = true;
        update pb2;
    }

    static testmethod void AddProductsPedidosController (){

        Order o = [SELECT Id FROM Order];
        PriceBookEntry pb = [SELECT Id FROM PriceBookEntry];

        ApexPages.StandardController sc = new ApexPages.StandardController(o);
		AddProductosPedidosController  obj = new AddProductosPedidosController(sc);

        obj.getProductos();
        obj.lstSelectProductos = '[{"Id":'+'\"'+ pb.Id +'\"'+',"cantidad":"1"}]';

        obj.loadSelectedProducts();
        obj.saveProducts();
		obj.cancelAction();
        obj.getselectValues();
        obj.next();
        obj.addSelectedProductos();
    }
    

}