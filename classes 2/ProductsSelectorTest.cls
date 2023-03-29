@IsTest
public class ProductsSelectorTest {
    @IsTest
    static void whenSelectByIdReturnRecords(){
        Id productId = fflib_IDGenerator.generate(Product2.SObjectType);
        ProductsSelector.newInstance().selectById(new Set<Id>{productId});
    }

    @IsTest
    static void whenSelectByProductCodeReturnRecords(){
        ProductsSelector.newInstance().selectByProductCode(new Set<String>{'test'},10);
        
    }
}