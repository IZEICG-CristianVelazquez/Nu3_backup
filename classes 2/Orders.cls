public inherited sharing class Orders extends fflib_SObjectDomain implements IOrders{
    
    private List<Order> orderWP;
    private Map<id,Registro_Choferes_Pedidos__c> MapRCPByOrder;
    private final static String PEDIDO_FACTURADO = 'Facturado';
    private static List <Encuesta__c> lstEnc = new List<Encuesta__c>();
    static Map <String,Detalle_de_encuesta__c> oldEncuesta;
    private static List<Detalle_de_encuesta__c> detallesEncuesta = new List<Detalle_de_encuesta__c>();
    
    public class dataRCP{
        @AuraEnabled public String orderNumber;
        @AuraEnabled public String nombreChofer;
        @AuraEnabled public String banda;
        @AuraEnabled public String anden;
        
    }
    
    public Orders(List<Order> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            
            return new Orders(sObjectList);
        }
    }
    
    public void loadMapRCPByOrder(){
        
        if(MapRCPByOrder == null){
            
            MapRCPByOrder = new Map<Id,Registro_Choferes_Pedidos__c>();
            System.debug('test: '+ new RegistroChoferesPedidosSelector().selectToControlRCP());
            for (Registro_Choferes_Pedidos__c rcp : RegistroChoferesPedidosSelector.newInstance().selectToControlRCP()){
                System.debug('rcp pedido id: '+rcp.Pedido__r.Id);
                if(rcp.Pedido__r.Id != null){
                    
                    MapRCPByOrder.put(rcp.Pedido__r.Id, rcp);
                    
                }
                
            }
            
        }
        
    }
    
    private static void loadEncuestas(){
        
        oldEncuesta = new Map<String, Detalle_de_encuesta__c>();
        Date hoy = date.today();
        lstEnc = [SELECT id,Name,pregunta__c FROM Encuesta__c WHERE Name = 'Encuesta de satisfacción' Limit 1];  
        
        for(Detalle_de_encuesta__c item :[SELECT Encuesta__c,
                                          order_Relacionada__c,
                                          order_Relacionada__r.Kilogramos_totales_Rollup__c,
                                          Account_relacionada__c,
                                          fecha_de_cambio_Status__c 
                                          FROM Detalle_de_encuesta__c 
                                          WHERE fecha_de_cambio_Status__c =: hoy ]){
                                              
                                              if(item != null){
                                                  
                                                  String key = String.valueOf(item.Account_relacionada__c);
                                                  oldEncuesta.put(key,item);
                                              }
                                              
                                              
                                          }    
        
        
        System.debug('oldEncuesta '+oldEncuesta);
        
    }
    
    public void modificarCamposOrderItems(fflib_ISObjectUnitOfWork uow,Map<Id,SObject> existingRecords, List<Order> orderList){
        
        for(Order o : orderList){
            
            
            if(o.RecordTypeId != Schema.SObjectType.Order.getRecordTypeInfosByName().get('Nota de Crédito').getRecordTypeId()){
                
                Order existingOrder = (Order) existingRecords.get(o.Id);
                
                if(o.Descuento_general__c != existingOrder.Descuento_general__c || o.Descuento_por_forma_de_pago__c != existingOrder.Descuento_por_forma_de_pago__c ||
                   o.Tipo_de_Unidad__c != existingOrder.Tipo_de_Unidad__c || o.Lugar_de_entrega__c != existingOrder.Lugar_de_entrega__c){
                       
                       System.debug(existingOrder.Descuento_general__c);
                       System.debug(o.Descuento_general__c);
                       
                       if(!o.OrderItems.isEmpty()){
                           
                           for(OrderItem oi : o.OrderItems){
                               
                               oi.Descuento_por_flete_copia__c = o.Descuento_general__c;
                               oi.Descuento_por_forma_de_pago_copia__c = o.Descuento_por_forma_de_pago__c;
                               
                               uow.registerDirty(oi);
                               
                           }
                           
                       }
                       
                   }
                
            }
            
        }
        
    }
    
    public void crearDetalleDeEncuestas(fflib_ISObjectUnitOfWork uow,Map<Id,SObject> existingRecords,Set<Id> orderIds){
        
        for(Order ord : new OrdersSelector().selectByIdWithAccountInfo(orderIds)){
            
            if(ord.RecordTypeId == Schema.SObjectType.Order.getRecordTypeInfosByName().get('Pedido').getRecordTypeId()){
                
                Order oldOrder = (Order)existingRecords.get(ord.Id);
                
                if(oldOrder != null && oldOrder.Status != PEDIDO_FACTURADO && ord.Status == PEDIDO_FACTURADO && !lstEnc.isEmpty() && String.isNotBlank(ord.Account.Phone)){
                    
                    String keyToSearch = String.valueOf(ord.AccountId);
                    Boolean prev = oldEncuesta.containsKey(keyToSearch)? true : false;
                    Detalle_de_encuesta__c oldDetEnc = (prev)? oldEncuesta.get(keyToSearch): null;
                    Decimal kg = oldDetEnc != null && oldDetEnc.order_Relacionada__r != null ? oldDetEnc.order_Relacionada__r.Kilogramos_totales_Rollup__c : 0;
                    
                    Detalle_de_encuesta__c detEnc = prev ? oldDetEnc :
                    new Detalle_de_encuesta__c(
                        Account_relacionada__c = ord.Account.Id,
                        fecha_de_cambio_Status__c = date.today(),
                        estatus_de_env_o__c = 'pendiente de enviar',
                        Encuesta__c = lstEnc.get(0).Id,
                        Tel_fono_destino__c =  TwilioClient.checkFormatNumber(ord.Account.Phone)
                    );
                    
                    Boolean mayorPeso = (ord.Kilogramos_totales_Rollup__c  > kg) ? true : false;
                    
                    
                    if(oldDetEnc != null){
                        detEnc.order_Relacionada__c = (mayorPeso) ? ord.Id : oldDetEnc.order_Relacionada__c;
                    }
                    
                    if(oldDetEnc == null){
                        detEnc.order_Relacionada__c = ord.Id;    
                    }    
                    
                    
                    detallesEncuesta.add(detEnc);
                    
                    
                }
            }
        }
        
        if(!detallesEncuesta.IsEmpty()){
            System.debug('Detalle de encuesta: '+detallesEncuesta);
            uow.registerUpsert(detallesEncuesta);
        }
        
    }
    
    private void notificarPedidoAndenBanda(Map<Id,SObject> existingRecords) {
        
        List<RecordChange__e> lstEvent = new List<RecordChange__e>();
        loadMapRCPByOrder();
        
        if(!MapRCPByOrder.isEmpty()){
            
            for (Order ord : (List<Order>) Records ) {
                
                Order oldOrder = (Order)existingRecords.get(ord.Id);
                
                Registro_Choferes_Pedidos__c rcp = (MapRCPByOrder.containsKey(ord.Id))? MapRCPByOrder.get(ord.Id):null;
                
                if(rcp != null){
                    dataRCP dataOrd = new dataRCP();
                    dataOrd.orderNumber = (rcp.Pedido__r.OrderNumber != null)? rcp.Pedido__r.OrderNumber :'';
                    dataOrd.nombreChofer = (rcp.Chofer__r.Name != null)? rcp.Chofer__r.Name:'';
                    dataOrd.banda = (ord.Banda_asignada__c != null)? ord.Banda_asignada__c :'';
                    dataOrd.anden = (ord.And_n_asignado__c != null)? ord.And_n_asignado__c :'';
                    
                    if (String.isBlank(oldOrder.Banda_asignada__c) && String.isNotBlank(ord.Banda_asignada__c)) {
                        
                        lstEvent.add(new RecordChange__e(RecordId__c='BANDA', Record__c = System.JSON.serializePretty(dataOrd))  );
                        
                    } else if (String.isBlank(oldOrder.And_n_asignado__c) && String.isNotBlank(ord.And_n_asignado__c)) {
                        
                        lstEvent.add(new RecordChange__e(RecordId__c='ANDEN', Record__c = System.JSON.serializePretty(dataOrd))  );
                        
                    }
                }
                
                
            }
            
            if(!lstEvent.IsEmpty()){
                // Call method to publish events
                List<Database.SaveResult> results = EventBus.publish(lstEvent);
            }
                            
            
        }
        
        
        
    }

    public void updateDocumentSerieField(List<Order> ordersList){
        Set<Id> accountsIds = new Set<Id>();
        /* Set<Id> assigneeIds = new Set<Id>();

        Map<Id,Set<String>> permissionSetNameByUserId = new Map<Id,Set<String>>(); */


        for(Order pedido : ordersList){
            if(pedido.AccountId != null){
                accountsIds.add(pedido.AccountId);
                /* assigneeIds.add(pedido.OwnerId); */
            }
        }

        
        Map<Id,Account> accountsById = new Map<Id,Account>(AccountsSelector.newInstance().selectById(accountsIds));

        /* for(PermissionSetAssignment psa : PermissionSetAssignmentsSelector.newInstance()
                                            .selectByAssigneeIdWithPermissionSet(assigneeIds)){

            Set<String> permissionSetNames = permissionSetNameByUserId.containsKey(psa.AssigneeId) ? 
                                                permissionSetNameByUserId.get(psa.AssigneeId) : new Set<String>();

            permissionSetNames.add(psa.PermissionSet.Name);
            permissionSetNameByUserId.put(psa.AssigneeId,permissionSetNames);
        } */
        
        for(Order pedido : ordersList){
            if(!pedido.Integraci_n__c){

                Account cuentaDelPedido = accountsById.get(pedido.AccountId);

                if(cuentaDelPedido != null && cuentaDelPedido.Base_de_Datos__c != null && Constants.ACCOUNT_DATABASE_PICKLIST.contains(cuentaDelPedido.Base_de_Datos__c)){
                    pedido.Serie_del_Documento2__c = cuentaDelPedido.Base_de_Datos__c == Constants.ACCOUNT_DATABASE_LAGOS ? '9'     :      '74';
                    pedido.Serie_del_Documento__c  = cuentaDelPedido.Base_de_Datos__c == Constants.ACCOUNT_DATABASE_LAGOS ? 'LAGOS' : 'CAB-Nu3';
                }
            }
        }
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        
        
        Set<Id> orderIds = new Set<Id>();
        for(Order o : (List<Order>)Records){
            
            orderIds.add(o.Id);
            
        }
        
        notificarPedidoAndenBanda(existingRecords);
        loadEncuestas();
        
        // Se hace el Query sin usar el Selector por bug en WS que se consume desde Twilio
        //orderWP = new OrdersSelector().selectByIdWithProducts(orderIds);
        orderWP = [SELECT Tipo_de_Unidad__c,
                   Descuento_general__c,
                   RecordTypeId,
                   Descuento_por_forma_de_pago__c ,
                   Lugar_de_entrega__c,
                   Status,
                   (SELECT Descuento_por_flete_copia__c,
                    Descuento_por_forma_de_pago_copia__c
                    FROM OrderItems)
                   FROM Order 
                   WHERE Id IN : orderIds ];
        
        System.debug(orderWP);
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        Orders orders = new Orders(Records);
        orders.modificarCamposOrderItems(uow,existingRecords,orderWP);
        orders.crearDetalleDeEncuestas(uow,existingRecords,orderIds);

        uow.commitWork();
        
        
    }

    public override void onBeforeInsert(){
        updateDocumentSerieField((List<Order>)this.Records);
    }

    
    
}