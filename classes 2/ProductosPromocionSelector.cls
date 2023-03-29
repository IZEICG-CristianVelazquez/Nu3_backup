public class ProductosPromocionSelector extends fflib_SObjectSelector {

     public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Promocion__c.Id,
                Promocion__c.Name,
                Promocion__c.Cantidad_Disponible_Promocion__c
            };

    }

    public Schema.SObjectType getSObjectType() {

        return Promocion__c.sObjectType;

    }
    public List<Promocion__c> selectById(Set<ID> idSet) {

        return (List<Promocion__c>) selectSObjectsById(idSet);

    }

   /* public List<Product2> selectByProductCode(Set<String> productCode, Integer recordLimit) {

        return (List<Product2>) Database.query(
            
            newQueryFactory().
            setCondition('ProductCode IN: productCode').
            setLimit(recordLimit).
            // Finally build the query to execute
            toSOQL());
    }*/


}