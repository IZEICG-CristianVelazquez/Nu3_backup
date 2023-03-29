@IsTest
public class FacturasSelectorTest {
    @IsTest
    static void whenSelectByIdReturnRecords(){
        Id facturaId = fflib_IDGenerator.generate(Factura__c.SObjectType);
        FacturasSelector.newInstance().selectById(new Set<Id>{facturaId});

    }

    @IsTest
    static void whenSelectByIdExternoReturnRecords(){
        FacturasSelector.newInstance().selectByIdExterno(new Set<String>{'test'});

    }

    @IsTest
    static void whenSelectByExternalIdWithProductsReturnRecords(){
        FacturasSelector.newInstance().selectByExternalIdWithProducts(new Set<String>{'test'});

    }


}