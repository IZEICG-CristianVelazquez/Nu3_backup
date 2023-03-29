@IsTest
public class ProductosDeFacturaSelectorTest {
    @IsTest
    static void whenSelectByIdReturnRecords(){
        Id productoID = fflib_IDGenerator.generate(Producto_de_Factura__c.SObjectType);
        ProductosDeFacturaSelector.newInstance().selectById(new Set<Id>{productoID});
        
    }
}