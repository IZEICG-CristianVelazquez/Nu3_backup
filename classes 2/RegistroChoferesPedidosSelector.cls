public without sharing class RegistroChoferesPedidosSelector extends fflib_SObjectSelector implements IRegistroChoferesPedidosSelector {
    
    public static IRegistroChoferesPedidosSelector newInstance() {
		return (IRegistroChoferesPedidosSelector) Application.Selector.newInstance(Registro_Choferes_Pedidos__c.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {
        
        return new List<Schema.SObjectField> {
            Registro_Choferes_Pedidos__c.Id,
                Registro_Choferes_Pedidos__c.Name,
                Registro_Choferes_Pedidos__c.Estatus__c,
                Registro_Choferes_Pedidos__c.Pedido__c,   
                Registro_Choferes_Pedidos__c.Unidad_de_negocio__c,
                Registro_Choferes_Pedidos__c.lastmodifieddate, 
                Registro_Choferes_Pedidos__c.Lugar_de_entrega__c, 
                Registro_Choferes_Pedidos__c.And_n_Banda__c,
                Registro_Choferes_Pedidos__c.Hora_estimada_de_fin_de_carga__c
                };
                    }
    
    public Schema.SObjectType getSObjectType() {
        
        return Registro_Choferes_Pedidos__c.sObjectType;
        
    }
    
    public List<Registro_Choferes_Pedidos__c> selectById(Set<ID> idSet) { 
/*         return Database.query(
            newQueryFactory()
            .selectField('Pedido__r.Status')
            .setCondition('Id IN: idSet').toSOQL()
        ); */
        return (List<Registro_Choferes_Pedidos__c>) selectSObjectsById(idSet);
        
    }
    
    public List<Registro_Choferes_Pedidos__c> selectAll (Integer recordLimit) {
        
        return (List<Registro_Choferes_Pedidos__c>) Database.query( 
            newQueryFactory(true)
            .setLimit(recordLimit)
            .toSOQL()
        );
    }
    
    public  List<Registro_Choferes_Pedidos__c> selectRCPWithRelatedData(String phone, String phoneComplete) { 
       
        Date hoy = Date.today();
        // Query Factory for this Selector (Registro_Choferes_Pedidos__c)
        fflib_QueryFactory RCPQueryFactory = newQueryFactory();
        RCPQueryFactory.selectField('Chofer__r.Name');
        RCPQueryFactory.selectField('Chofer__r.MobilePhone');
        RCPQueryFactory.selectField('Pedido__r.Name');
        RCPQueryFactory.selectField('Pedido__r.OrderNumber');
        RCPQueryFactory.selectField('Pedido__r.Status');
		phoneComplete = TwilioClient.checkFormatNumber(phoneComplete);
        System.debug('[Selector] #Completo: '+phone);
        System.debug('[Selector] #10 Dígitos: '+phoneComplete);
        
        String query = ' (Chofer__r.MobilePhone LIKE \''+phone+'\' '
            +'OR Chofer__r.MobilePhone = \''+phoneComplete+'\') '
            +'AND Estatus__c = \'Pendiente de confirmación\' '
            +'AND Pedido__r.Status != \'Presupuesto\' AND Pedido__r.Status != \'Cotización\' '
            +'AND Pedido__r.Status != \'Enviado a SAP\' AND Pedido__r.Status != \'Cargado\' '
            +'AND Pedido__r.Status != \'Facturado\' AND Pedido__r.Status != \'Entregado\' '
            +'AND Pedido__r.Status != \'Factura\' AND Pedido__r.Status != \'Nota de Crédito\' '
            +'AND Pedido__r.Status != \'Cancelado\' AND CALENDAR_YEAR(lastmodifieddate) = '+ hoy.year()
            +'AND CALENDAR_MONTH(lastmodifieddate) ='+ hoy.month() +'AND DAY_IN_MONTH(lastmodifieddate) = '+ hoy.day();
     
        RCPQueryFactory.setCondition(query);
        RCPQueryFactory.addOrdering('lastmodifieddate', fflib_QueryFactory.SortOrder.DESCENDING);
        RCPQueryFactory.setLimit(1);
            	
        
        
        System.debug('query--->'+RCPQueryFactory.toSOQL());
        // Set the condition and build the query
        return (List<Registro_Choferes_Pedidos__c>) Database.query(
        RCPQueryFactory.toSOQL());    
        
    }
    
    public List<Registro_Choferes_Pedidos__c> selectByIdWithRelatedData(Set<ID> idSet) { 
        
        // Query Factory for this Selector (Registro_Choferes_Pedidos__c)
        fflib_QueryFactory RCPQueryFactory = newQueryFactory();
        RCPQueryFactory.selectField('Chofer__r.Name');
        RCPQueryFactory.selectField('Pedido__r.Name');
        RCPQueryFactory.selectField('Pedido__r.OrderNumber');
        RCPQueryFactory.selectField('Chofer__r.MobilePhone');
        RCPQueryFactory.selectField('Pedido__r.Kilogramos_totales_Rollup__c');   
        RCPQueryFactory.selectField('Pedido__r.Lugar_de_entrega__c.Name'); 
        RCPQueryFactory.selectField('Chofer__r.MobilePhone');
        RCPQueryFactory.selectField('Pedido__r.Referencia_SAP__c');
        RCPQueryFactory.selectField('Pedido__r.Banda_asignada__c');
        
        // Set the condition and build the query
        return (List<Registro_Choferes_Pedidos__c>) Database.query(
            RCPQueryFactory.setCondition('id in :idSet').
            toSOQL());
    }
    
    public List<Registro_Choferes_Pedidos__c> selectToControlRCP() {

        Date hoy = Date.today();
        
        fflib_QueryFactory RCPQueryFactory = newQueryFactory();
        RCPQueryFactory.selectField('Chofer__r.Name');
        RCPQueryFactory.selectField('Pedido__r.Name');
        RCPQueryFactory.selectField('Pedido__r.Status');
        RCPQueryFactory.selectField('Pedido__r.Banda_asignada__c');
        RCPQueryFactory.selectField('Pedido__r.And_n_asignado__c');
        RCPQueryFactory.selectField('Pedido__r.Id');
        RCPQueryFactory.selectField('Pedido__r.OrderNumber');
        RCPQueryFactory.selectField('Pedido__r.lastmodifieddate');
   		
        String condicion = ' Pedido__c != \'\' AND Pedido__r.Status  != \'Facturado\' '
            +'AND Pedido__r.Status  != \'Cancelado\' '
            +'AND CALENDAR_YEAR(Pedido__r.lastmodifieddate)  = '+ hoy.year()
            +'AND CALENDAR_MONTH(Pedido__r.lastmodifieddate) = '+ hoy.month() 
            +'AND DAY_IN_MONTH(Pedido__r.lastmodifieddate)   = '+ hoy.day();
     
        RCPQueryFactory.setCondition(condicion);
        RCPQueryFactory.addOrdering('Pedido__r.lastmodifieddate', fflib_QueryFactory.SortOrder.DESCENDING);
        RCPQueryFactory.setLimit(50);
        
        return (List<Registro_Choferes_Pedidos__c>) Database.query(
            RCPQueryFactory.toSOQL());
    }
    
    public Registro_Choferes_Pedidos__c selectByOrderIdRCP(String IdPedido){
        
        fflib_QueryFactory RCPQueryFactory = newQueryFactory();
        RCPQueryFactory.selectField('Chofer__r.Name');
        RCPQueryFactory.selectField('Pedido__r.Id');
        RCPQueryFactory.selectField('Pedido__r.Name');
        RCPQueryFactory.selectField('Pedido__r.Status');
        RCPQueryFactory.selectField('Pedido__r.OrderNumber');
        RCPQueryFactory.selectField('Pedido__r.Banda_asignada__c');
        RCPQueryFactory.selectField('Pedido__r.And_n_asignado__c');
   		
        String condicion = ' Pedido__r.Id = \''+IdPedido+'\' ';
        RCPQueryFactory.setCondition(condicion);
        RCPQueryFactory.addOrdering('lastmodifieddate', fflib_QueryFactory.SortOrder.DESCENDING);
        
        return (Registro_Choferes_Pedidos__c) Database.query(
            RCPQueryFactory.toSOQL());
    }
    
}