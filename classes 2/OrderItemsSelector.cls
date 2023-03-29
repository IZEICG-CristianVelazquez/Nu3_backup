public inherited sharing class OrderItemsSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                OrderItem.Id,
                OrderItem.ListPrice,
                OrderItem.UnitPrice,
                OrderItem.Quantity,
                OrderItem.Kilogramos__c,
                OrderItem.Descuento__c,
                OrderItem.Precio_kg__c,
                OrderItem.Descuento_por_l_nea__c,
                OrderItem.Product2Id,
                OrderItem.Unidad_de_Medida__c,
                OrderItem.Precio_total_con_flete__c,
                OrderItem.Precio_de_lista_2__c,
                OrderItem.Kilogramos_copia__c,
                OrderItem.Kilogramos_totales_facturados__c,
                OrderItem.Precio_total_facturado_copia__c,
                OrderItem.Precio_total_facturado__c,
                OrderItem.TotalPrice,
                OrderItem.Descuento_SAP__c,
                OrderItem.IVA_copia__c,
                OrderItem.Promocion__c,
                OrderItem.OrderId
            };

    }

    public Schema.SObjectType getSObjectType() {

        return OrderItem.sObjectType;

    }
    public List<OrderItem> selectById(Set<ID> idSet) {

        return (List<OrderItem>) selectSObjectsById(idSet);

    }

    public List<OrderItem> selectByIdWithOrderFields(Set<ID> idSet){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory orderItemsQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<OrderItem>) Database.query(
            orderItemsQueryFactory.setCondition('Id in :idSet').
            selectField('Order.RecordTypeId').
            selectField('Product2.Codigo_Impuesto__c').
            selectField('Product2.Categor_a__c').
            selectField('Product2.Kilogramos_unidad__c').
            selectField('Order.Kilogramos_totales_Rollup__c').
            selectField('Order.Costo_de_flete2__c').
            selectField('Order.Total_de_productos__c').
            selectField('Order.Lugar_de_entrega__c').
            selectField('Order.Costo_flete_Ton__c').
            selectField('Order.Kilogramos_totales_Rollup__c').
            toSOQL());

    }

    public List<OrderItem> selectByOrder(String orderId){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory orderItemsQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<OrderItem>) Database.query(
            orderItemsQueryFactory.setCondition('OrderId = :orderId').toSOQL());

    }

    public List<OrderItem> selectByOrderWithNotPromotionCondition(String orderId){

        // Query Factory for this Selector (PriceBookEntry)
        fflib_QueryFactory orderItemsQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<OrderItem>) Database.query(
            orderItemsQueryFactory.setCondition('OrderId = :orderId And Promocion__c = null').
            toSOQL());

    }

    public List<OrderItem> selectByOrderIdWithDiscountCondition (String orderId) {

        return Database.query(
            newQueryFactory(true).
                setCondition('OrderId = :orderId AND Descuento__c = 100 AND Promocion__c != null'). 
                toSOQL());

    }

    public List<AggregateResult> selectWithProductPromotionCondition (Set<ID> idSet) {

        String query = 
            'SELECT Product2Id, product2.Name,  sum(quantity) totalQuantity from OrderItem ' +
            'where Product2Id  IN :idSet AND Descuento__c = 100 AND Promocion__c != null Group By Product2Id, Product2.Name';

        return  Database.query(query);

    }



}