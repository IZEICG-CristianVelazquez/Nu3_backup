public inherited sharing class OrdersSelector extends fflib_SObjectSelector implements IOrdersSelector {

    public static IOrdersSelector newInstance() {
		return (IOrdersSelector) Application.Selector.newInstance(Order.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Order.Id,
                Order.EffectiveDate,
                Order.CreatedDate,
                Order.Serie_del_Documento__c,
                Order.Serie_del_Documento2__c,
                Order.Comentarios__c,
                Order.Tipo_de_pago__c,
                Order.Empresa_Financiera__c,
                Order.Incluye_flete__c,
                Order.Tipo_de_Unidad__c,
                Order.C_digo_Tipo_de_Unidad__c,
                Order.Costo_flete__c,
                Order.Descuento_general__c,
                Order.Costo_de_flete2__c,
                Order.Factor_tarifa_camioneta__c,
                Order.ID_SAP__c,
                Order.ID_Externo__c,
                Order.Status,
                Order.OrderNumber,
                Order.Pricebook2Id,
                Order.Referencia_SAP__c,
                Order.Lista_de_Precios__c,
                Order.RecordTypeId,
                Order.Factura__c,
                Order.Descuento_por_forma_de_pago__c ,
                Order.Lugar_de_entrega__c,
                Order.Name,
                Order.Kilogramos_totales_Rollup__c,
                Order.Fecha_Vencimiento_Factura__c                    
            };

    }
   
    public Schema.SObjectType getSObjectType() {

        return Order.sObjectType;

    }
    public List<Order> selectById(Set<ID> idSet) {

        return (List<Order>) selectSObjectsById(idSet);

    }
    public List<Order> selectByIdWithAccountInfo (Set<ID> idSet) {
        
        return Database.query(
            newQueryFactory(true).
            selectField('Account.Base_de_Datos__c').
            selectField('Account.Lista_de_precio__r.Name'). 
            selectField('Account.Disponible_para_encuestas__c'). 
            selectField('Account.Phone').
            selectField('Account.Name').
            selectField('Account.Id').
            
            
            setCondition('id in :idSet').
            toSOQL());
        
    }
    public List<Order> selectByExternalId(Set<String> idSet) {


        return Database.query(
            newQueryFactory(true).
            selectField('Account.Base_de_Datos__c').
            selectField('Account.Lista_de_precio__r.Name'). 
            selectField('Account.Phone').
            selectField('Account.Name').
            selectField('Account.Id').
            setCondition('ID_Externo__c in :idSet').
            toSOQL());

    }
    public List<Order> selectByIdWithProducts (Set<ID> idSet) {
        // Query Factory for this Selector (Order)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();
        ordersQueryFActory.selectField('Account.Lista_de_precio__r.Name');   
        ordersQueryFActory.selectField('Account.Clasificacion__c');   
        // Add a query subselect via the Query Factory for the Order Items
        fflib_QueryFactory productsQueryFactory = new 
            OrderItemsSelector().addQueryFactorySubselect(ordersQueryFactory);

        // Set the condition and build the query
        return (List<Order>) Database.query(
            
            ordersQueryFactory.setCondition('id in :idSet').
            toSOQL());
    }
    public List<Order> selectByExternalIdWithProducts (Set<String> idSet) {

        // Query Factory for this Selector (Order)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();
        // Add a query subselect via the Query Factory for the Order Items
        fflib_QueryFactory productsQueryFactory = new 
        OrderItemsSelector().addQueryFactorySubselect(ordersQueryFactory);

        new PricebookEntriesSelector().configureQueryFactoryFields(productsQueryFactory, 'PricebookEntry');
        new ProductsSelector().configureQueryFactoryFields(productsQueryFactory, 'PricebookEntry.Product2');
        
        // Set the condition and build the query

       //System.debug('selectByExternalIdWithProducts ' + ordersQueryFactory.setCondition('ID_Externo__c in :idSet').toSOQL());

        return (List<Order>) Database.query(
            ordersQueryFactory.setCondition('ID_Externo__c in :idSet').toSOQL());
    }

    public List<Order> selectRecentlyUpdatedWithOrderItems (Integer recordLimit) {

        List<String> ordersSchema = new List<String>();
        List<String> orderItemsSchema = new List<String>();

        for(Schema.SObjectField sfield : getSObjectFieldList()) {
            ordersSchema.add(''+sfield);
        }

         for(Schema.SObjectField sfield : new OrderItemsSelector().getSObjectFieldList()) {
            orderItemsSchema.add(''+sfield);
        }
        
        Datetime lastCheck = Datetime.now().addHours(1);
        String enviadoASap = 'Enviado a SAP';

        String query = String.format(
            'SELECT {0} from {1} ' +
            //'WHERE SystemModstamp = TODAY ' +
            //'AND SystemModstamp  >= :lastCheck ' +
            'WHERE Status =: enviadoASap ' +
            'ORDER by {2} limit {3}',
             
            new List<Object> {
                (String.join(ordersSchema, ',') + ', Account.Proyecto__c, Account.ID_SAP__c, Account.ID_Agente__c, Account.Tarifa_flete__c, '+
                                                    'Account.Owner.ID_SAP__c, Account.Owner.Proyecto__c, Account.Owner.Division, '+
                                                    'Account.Base_de_Datos__c, Account.BillingPostalCode, Account.BillingAddress, '+
                                                    'Lugar_de_entrega__r.Name, Lugar_de_entrega__r.Factor__c, '+
                                                    'Pricebook2.Centro_de_Utilidad__c, ( select Product2.ProductCode, '+
                                                    'Product2.Codigo_Impuesto__c, ' + String.join(orderItemsSchema, ',') + ' from OrderItems)' ),
                getSObjectName(),
                getOrderBy(),
                String.valueOf(recordLimit)
            } 
        );

        System.debug('query ' + query);

        return (List<Order>) Database.query(query);
    }

/*     public List<Order> selectByIdWithInfo(){
        return Database.query(
            newQueryFactory()
            .selectField(field)
            );
    } */
}