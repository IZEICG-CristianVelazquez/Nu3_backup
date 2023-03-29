public class PriceBooksSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

            return new List<Schema.SObjectField> {

                PriceBook2.Id,
                PriceBook2.Base_de_Datos__c,
                PriceBook2.Centro_de_Utilidad__c,
                PriceBook2.Lista_de_precios_SAP__c

            };

    }
    public Schema.SObjectType getSObjectType() {

        return PriceBook2.sObjectType;

    }

    public List<PriceBook2> selectByIDWithPriceBookEntries (Set<ID> idSet) {

        // Query Factory for this Selector (PriceBook2)
        fflib_QueryFactory pbsQueryFactory = newQueryFactory().setCondition('Id in :idSet');

        // Add a query sub-select via the Query Factory for the Order Items
        fflib_QueryFactory pbesQueryFactory = new 
        PricebookEntriesSelector().addQueryFactorySubselect(pbsQueryFactory);

        new ProductsSelector().configureQueryFactoryFields(pbesQueryFactory, 'Product2');
        
        // Set the condition and build the query

        System.debug('selectWithPriceBookEntries ' + pbsQueryFactory.toSOQL());

        return (List<PriceBook2>) Database.query(pbsQueryFactory.toSOQL());
    }


    public List<PriceBook2> selectById(Set<ID> idSet) {

        return (List<PriceBook2>) selectSObjectsById(idSet);

    }
    
    public Database.QueryLocator selectListaPreciosSap () {
        

        return Database.getQueryLocator(
            newQueryFactory()
            .setCondition('Lista_de_precios_SAP__c != null AND Base_de_Datos__c != null')
            .toSOQL()
        );
            
            
    }
    
  

}