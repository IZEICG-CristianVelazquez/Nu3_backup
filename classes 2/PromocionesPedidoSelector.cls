public class PromocionesPedidoSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Promocion__c.Id,
                Promocion__c.Canal__c,
                Promocion__c.Cantidad_Compra_Base__c,
                Promocion__c.Cantidad_Disponible_Promocion__c,
                Promocion__c.Fecha_Fin__c,
                Promocion__c.Fecha_Inicio__c,
                Promocion__c.Producto_base__c,
                Promocion__c.Producto_promocion__c,
                Promocion__c.Name
            };

    }
    public Schema.SObjectType getSObjectType() {

        return Promocion__c.sObjectType;

    }
    public List<Promocion__c> selectById(Set<ID> idSet) {

        return (List<Promocion__c>) selectSObjectsById(idSet);

    }
    public List<Promocion__c> selectByIdWithProductoBaseCondition (Set<ID> idSet, Date effDate, String pbName, String clasCliente) {
		System.debug('pbName recibido para comparar: '+pbName);
        return Database.query(
            newQueryFactory(true).
                selectField('Producto_base__c.Name').
                selectField('Producto_promocion__c.Name').
                setCondition('Producto_base__c in :idSet AND Fecha_Inicio__c <= :effDate AND Fecha_Fin__c >= :effDate AND Canal__c includes(:pbName) AND Clasificaci_n_cliente__c includes(:clasCliente)').            
                toSOQL());
    }

}