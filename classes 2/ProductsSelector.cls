public class ProductsSelector extends fflib_SObjectSelector implements IProductsSelector {
    
    public static IProductsSelector newInstance() {
		return (IProductsSelector) Application.Selector.newInstance(Product2.SObjectType);
	}
     
    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Product2.Id,
                Product2.Name,
                Product2.ProductCode,
                Product2.QuantityUnitOfMeasure,
                Product2.Codigo_Impuesto__c,
                Product2.Kilogramos_unidad__c,
                Product2.Grupo_Articulos_M2001__c,
                Product2.Grupo_Art_culos_Lagos__c,
                Product2.Grupo_de_art_culos_veracruz__c
            };

    }

    public Schema.SObjectType getSObjectType() {

        return Product2.sObjectType;

    }
    public List<Product2> selectById(Set<ID> idSet) {

        return (List<Product2>) selectSObjectsById(idSet);

    }

    public List<Product2> selectByProductCode(Set<String> productCode, Integer recordLimit) {

        return (List<Product2>) Database.query(
            /**
            Query factory has been pre-initialised by calling
            getSObjectFieldList(), getOrderBy() for you.
            */
            newQueryFactory().
            /**
            Now focus on building the remainder of the
            query needed for this method.
            */
            setCondition('ProductCode IN: productCode AND IsActive = true').
            setLimit(recordLimit).
            // Finally build the query to execute
            toSOQL());
    }


}