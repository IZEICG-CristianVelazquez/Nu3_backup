public class OrderItems extends fflib_SObjectDomain{
    
    public OrderItems(List<OrderItem> sObjectList) {
        super(sObjectList);
        
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new OrderItems(sObjectList);
        }
    }
    
    public void insertValuesAfterInsert(fflib_SObjectUnitOfWork uow,List<OrderItem> lstOrderItem,Decimal kgTotales){
        
        System.debug('Entra a insertValuesAfterInsert');
        
        for(OrderItem oi : lstOrderItem){
            
            Decimal kgRollup = 0;
            
            if(oi.Order.RecordTypeId != Schema.SObjectType.Order.getRecordTypeInfosByName().get('Nota de Crédito').getRecordTypeId()){
                
                Decimal descLinea = oi.Descuento_por_l_nea__c != null ? (oi.Descuento_por_l_nea__c/100) : 0;
                Decimal precioLista2 = oi.Precio_de_lista_2__c != null ? oi.Precio_de_lista_2__c : 0;
                Decimal costoFlete = oi.Order.Costo_flete_Ton__c != null ? oi.Order.Costo_flete_Ton__c : 0;
                Decimal kilogramos = oi.Kilogramos__c != null ? oi.Kilogramos__c : 0;
                Decimal kgTotalesRollup = (oi.Order.Kilogramos_totales_Rollup__c != null && oi.Order.Kilogramos_totales_Rollup__c != 0.00) ? (oi.Order.Kilogramos_totales_Rollup__c + kgTotales) : kgTotales;
                Decimal precioTotal = (oi.Quantity * oi.UnitPrice);
                Decimal precioTotalFlete = ((kilogramos/kgTotalesRollup)*costoFlete) + precioTotal;
                Decimal kgUnidad = oi.Product2.Kilogramos_unidad__c != null ? oi.Product2.Kilogramos_unidad__c : 0;
                String codigoImp = String.IsNotBlank(oi.Product2.Codigo_Impuesto__c) ? oi.Product2.Codigo_Impuesto__c : '';
                oi.Kilogramos_copia__c = kilogramos;
                
                
                if(oi.Precio_de_lista_2__c != null || oi.Descuento__c != null || oi.Descuento_por_l_nea__c != null || oi.Descuento_SAP__c != null){
                    
                    oi.UnitPrice = (1 - descLinea) * precioLista2;
                    
                }
                
                
                
                
                oi.IVA_copia__c = 0.00;
                
                if(oi.UnitPrice != null && oi.Quantity != null && codigoImp == 'IVAT1601'){
                    
                    if(oi.Order.Lugar_de_entrega__c != null){
                        oi.IVA_copia__c = (((1 - descLinea)*precioLista2*oi.Quantity) * 0.16) + (((kgUnidad*oi.Quantity/1000)*oi.Order.Costo_flete_Ton__c)*0.16);
                    }else{
                        oi.IVA_copia__c = (((1 - descLinea)*precioLista2*oi.Quantity) * 0.16) + ((precioTotalFlete - precioTotal)*0.16);
                    }
                    
                    System.debug(oi.IVA_copia__c);
                    
                }
                
                oi.Kg_totales_facturados_copia__c = oi.Kilogramos_totales_facturados__c != null ? oi.Kilogramos_totales_facturados__c : 0;
                
                oi.Precio_total_facturado_copia__c = oi.Precio_total_facturado__c != null ? oi.Precio_total_facturado__c : 0;
                
            }
            
            System.debug('ORDER ITEM TRIGGER ' + oi);
            
            
            uow.registerDirty(oi);
            
        }
        
    }
    
    public void modificarCampos(fflib_SObjectUnitOfWork uow,Map<Id,SObject> existingRecords,List<OrderItem> lstOrderItem,Decimal kgTotales){
        
        map<Id,OrderItem>mapAux = new map<Id,OrderItem>(lstOrderItem);
        
        for(OrderItem oi :  (List<OrderItem>) Records){
            
            System.debug('Records ' + oi.TotalPrice);
            System.debug('lstOrderItem ' + (mapAux.get(oi.Id)).TotalPrice);
            System.debug('existingRecords ' + ((OrderItem)existingRecords.get(oi.Id)).TotalPrice);
            
            oi.Order = mapAux.get(oi.Id).Order;
            oi.Product2 = mapAux.get(oi.Id).Product2;
            
            
            if(oi.Order.RecordTypeId != Schema.SObjectType.Order.getRecordTypeInfosByName().get('Nota de Crédito').getRecordTypeId()){
                
                Decimal descLinea = oi.Descuento_por_l_nea__c != null ? (oi.Descuento_por_l_nea__c/100) : 0;
                Decimal precioLista2 = oi.Precio_de_lista_2__c != null ? oi.Precio_de_lista_2__c : 0;
                Decimal kgUnidad = oi.Product2.Kilogramos_unidad__c != null ? oi.Product2.Kilogramos_unidad__c : 0;
                Decimal costoFlete = oi.Order.Costo_flete_Ton__c != null ? oi.Order.Costo_flete_Ton__c : 0;
                Decimal kilogramos = oi.Kilogramos__c != null ? oi.Kilogramos__c : 0;
                Decimal precioTotal = (oi.Quantity * oi.UnitPrice);
                Decimal kgTotalesRollup = (oi.Order.Kilogramos_totales_Rollup__c != null && oi.Order.Kilogramos_totales_Rollup__c != 0.00) ? (oi.Order.Kilogramos_totales_Rollup__c + kgTotales) : kgTotales;
                Decimal precioTotalFlete = ((kilogramos/kgTotalesRollup)*costoFlete) + precioTotal;
                String codigoImp = String.IsNotBlank(oi.Product2.Codigo_Impuesto__c) ? oi.Product2.Codigo_Impuesto__c : '';
                OrderItem existingOI = (OrderItem) existingRecords.get(oi.Id);
                
                oi.UnitPrice = (1 - descLinea) * precioLista2;
                oi.Kilogramos_copia__c = oi.Kilogramos__c;
                
                
                oi.IVA_copia__c = 0.00;
                
                if(oi.UnitPrice != null && oi.Quantity != null && codigoImp == 'IVAT1601'){
                    
                    if(oi.Order.Lugar_de_entrega__c != null){
                        System.debug('lugar de entrega if ' + oi.Order.Lugar_de_entrega__c);
                        
                        oi.IVA_copia__c = (((1 - descLinea)*precioLista2*oi.Quantity) * 0.16) + (((kgUnidad*oi.Quantity/1000)*oi.Order.Costo_flete_Ton__c)*0.16);
                    }else{
                        System.debug('lugar de entrega else ' + oi.Order.Lugar_de_entrega__c);
                        
                        oi.IVA_copia__c = (((1 - descLinea)*precioLista2*oi.Quantity) * 0.16) + ((precioTotalFlete - precioTotal)*0.16);
                        
                    }
                    
                    System.debug('oi.IVA_copia__c ' + oi.IVA_copia__c);
                    
                    
                }
                
                oi.Kg_totales_facturados_copia__c = oi.Kilogramos_totales_facturados__c;
                
                oi.Precio_total_facturado_copia__c = oi.Precio_total_facturado__c;
                System.debug('ORDER ITEM TRIGGER ' + oi);
                
                
                
                uow.registerDirty(oi);
            }
        }
        
        
    }
    
    public void actualizarGrupoArticulos (fflib_SObjectUnitOfWork uow){
        System.debug('<---------Entra a actualizarGrupoArticulos------->');
        map<id,Order> mapOrders = new map<id,Order>();
        
        for(OrderItem item : (List<OrderItem>)Records){
            System.debug('Orderitems'+item);	
            //Seleccionar check-box de acuerdo a grupo de productos
            Order current;
            if(mapOrders.containskey(item.OrderId)){
                current = mapOrders.get(item.OrderId);
            }else{
                current = new Order(id=item.OrderId);
                mapOrders.put(current.Id,current);
                
            }
            System.debug('Este es el GA del item a comparar'+ item.Grupo_de_art_culo_formula__c);
            switch on item.Grupo_de_art_culo_formula__c{
                when '101'{
                    System.debug('Caso 101');
                    current.Admin_Ventas_MP__c = true;
                    current.Gerente_MP__c = true;
                    System.Debug('Admin_Ventas_MP__c: '+current.Admin_Ventas_MP__c);
                    System.debug('Gerente_MP__c: '+current.Gerente_MP__c);
                } 
                when '109'{
                    System.debug('Caso 109');
                    current.Gerente_Alimentos_Balanceados__c = true;
                    System.debug('Gerente_Alimentos_Balanceados__c: '+current.Gerente_Alimentos_Balanceados__c);
                }
                when '110'{
                    System.debug('Caso 110');
                    current.Gerente_GrandPet__c = true;
                    System.debug('Gerente_GrandPet__c: '+current.Gerente_GrandPet__c);
                }
                when '116'{
                    System.debug('Caso 116');
                    current.Agente_Ventas_INPRO__c = true;
                    current.Gerente_INPRO__c = true;
                    System.debug('Agente_Ventas_INPRO__c: '+current.Agente_Ventas_INPRO__c);
                    System.debug('Gerente_INPRO__c: '+current.Gerente_INPRO__c);
                }
                when '118'{
                    System.debug('Caso 118');
                    current.Boutique__c = true;
                    System.debug('Boutique__c: '+current.Boutique__c);
                }
                when '122'{
                    System.debug('Caso 122');
                    current.Gerente_AquaNU3__c	 = true;
                    System.debug('Gerente_INPRO__c: '+current.Gerente_AquaNU3__c);
                }
            }
        }
        
        System.debug('mapOrders--------------------->'+System.JSON.serializePretty(mapOrders));
        uow.registerdirty(mapOrders.values());
    }
    
    public void validarCantidad(Map<Id,SObject> existingRecords,fflib_SObjectUnitOfWork uow){
        
        Set<Id> setOrderIds = new Set<Id>();
        
        for(OrderItem oi : (List<OrderItem>)Records){
            
            OrderItem orderItemOld = (OrderItem)existingRecords.get(oi.Id);
            if(oi.Promocion__c == null && (orderItemOld.Quantity != null) && (oi.Quantity == null || oi.Quantity < orderItemOld.Quantity)){
                
                setOrderIds.Add(oi.OrderId);
            }
            
        }
        
        uow.registerDeleted([Select Id FROM OrderItem WHERE OrderId in : setOrderIds AND Promocion__c != null]);

    }
    
    public override void onAfterInsert(){
        
        System.debug('After Insert');
        
        Set<Id> oItemsIds = new Set<Id>();
        Decimal kgTotales = 0;
        
        for(OrderItem oi : (List<OrderItem>)Records){
            System.debug(oi.Id);
            oItemsIds.add(oi.Id);
            kgTotales += oi.Kilogramos__c; 

        }
        
        System.debug('kgTotales------->'+kgTotales);
        
        List<OrderItem> lstOrderItem = new OrderItemsSelector().selectByIdWithOrderFields(oItemsIds);
        System.debug('lstOrderItem---->'+lstOrderItem);
        
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { OrderItem.SObjectType,Order.SObjectType });
        
        insertValuesAfterInsert(uow,lstOrderItem,kgTotales);
        //Comprobación Grupos Articulos
        actualizarGrupoArticulos(uow);

        uow.commitWork();
        
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { OrderItem.SObjectType ,Order.SObjectType});
        
        //Comprobación Grupos Articulos
        actualizarGrupoArticulos(uow);
        validarCantidad(existingRecords,uow);
        
        uow.commitWork();
        
    }
    
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        
        System.debug('entra a ejecutar lo del trigger');
        
        Set<Id> oItemsIds = new Set<Id>();
        Decimal kgTotales = 0;
        
        for(OrderItem oi : (List<OrderItem>)Trigger.new){
            
            oItemsIds.add(oi.Id);
            kgTotales += oi.Kilogramos__c;
            
        }
        
        
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { 
            OrderItem.SObjectType,
                OrderItem.Order.SObjectType
                });
        
        List<OrderItem> lstOrderItem = new OrderItemsSelector().selectByIdWithOrderFields(oItemsIds);
        
        
        OrderItems orderItems = new OrderItems(Records);
        
        
        orderItems.modificarCampos(uow,existingRecords,lstOrderItem,kgTotales);
        
        
    }
    
}