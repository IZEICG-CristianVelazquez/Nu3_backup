public class PriceBookEntriesSelector extends fflib_SObjectSelector implements IPriceBookEntriesSelector {

    public static IPriceBookEntriesSelector newInstance() {
		return (IPriceBookEntriesSelector) Application.Selector.newInstance(PriceBookEntry.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {

                PriceBookEntry.Id,
                PriceBookEntry.IsActive,
                PriceBookEntry.Name,
                PriceBookEntry.Pricebook2Id,
                PriceBookEntry.Product2Id,
                PriceBookEntry.ProductCode,
                PriceBookEntry.UnitPrice

            };

    }
    public Schema.SObjectType getSObjectType() {

        return PriceBookEntry.sObjectType;

    }
    public List<PriceBookEntry> selectById(Set<ID> idSet) {

        return (List<PriceBookEntry>) selectSObjectsById(idSet);

    }
    public List<PriceBookEntry> selectByIdWithCustomFields(Set<ID> idSet){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('Id in :idSet').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Product2.QuantityUnitOfMeasure').
            selectField('Product2.Categor_a__c').
            toSOQL());

    }
    public List<PriceBookEntry> selectByPriceBookNameWithCustomFields(String priceBookName){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('Pricebook2.Name = :priceBookName').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Product2.QuantityUnitOfMeasure').
            selectField('Product2.Name').
            selectField('Product2.Categor_a__c').
            toSOQL());

    }
    public List<PriceBookEntry> selectByPBNameAndCategoryWithCustomFields(String priceBookName, String category){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('Pricebook2.Name = :priceBookName AND Es_promocion__c = false AND IsActive = true').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Product2.QuantityUnitOfMeasure').
            selectField('Product2.Name').
            selectField('Product2.Categor_a__c').
            toSOQL());

    }
    public List<PriceBookEntry> selectByProductCode (Set<String> codes, Integer recordLimit) {

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('ProductCode in :codes').
            selectField('Product2.Kilogramos_unidad__c').
             selectField('Product2.Categor_a__c').
            setLimit(recordLimit).toSOQL());
    }

    public List<PriceBookEntry> selectByProductCodeAndPriceBookId(Set<String> codes, Set<String> priceBookId) {

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('ProductCode IN : codes AND Pricebook2 IN : priceBookId').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Product2.Categor_a__c').
            toSOQL());
    }

    public List<PriceBookEntry> selectByPriceBookNameAndProduct2Id (String priceBookName, Set<String> codes) {

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        System.debug(ordersQueryFactory.setCondition('Pricebook2.Name = :priceBookName AND Product2Id in :codes').
                     selectField('Product2.Kilogramos_unidad__c').
                     selectField('Product2.Name').
                      selectField('Product2.Categor_a__c').
                     toSOQL());

        return (List<PriceBookEntry>) Database.query(
            ordersQueryFactory.setCondition('Pricebook2.Name = :priceBookName AND Product2Id in :codes').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Product2.Name').
            selectField('Product2.Categor_a__c').
            toSOQL());
    }


}