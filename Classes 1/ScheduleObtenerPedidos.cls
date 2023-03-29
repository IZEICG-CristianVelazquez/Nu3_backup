public class ScheduleObtenerPedidos implements Schedulable, Database.AllowsCallouts {
    
    static final Map<String, String> mapTipoUnidad = new Map<String, String>{'01' => 'Camioneta', '02' => 'Rabón', '03' => 'Torton', '04' => 'Trailer'};
        static Map<String, Lugar_de_entrega__c> mapaLE;
    static Map<Id, Map<String, PricebookEntry>> mapaPBEntries;
    static Map<String, Account> mapCuentasIdExterno;
    static Map<String,Id> agenteSellerIdByExternalId; // Added By Oscar
    static Map<String,String> agentesIdsByOrderExternalId; // Added By oscar
    static Set<String> codigos;
    static Set<String> idCuentas;
    private static final String CAPTURADO = 'Capturado en SAP';
    private static final String REVISADO = 'Revisado';
    private static final String COTIZACION = 'Cotización';
    private final static String PEDIDO_FACTURADO = 'Facturado';
    private static Map<String, Order> mapOrdersByExternalID;
    private static final List<String> PEDIDOS_MODIFICABLES = new List<String>{CAPTURADO,REVISADO};
    static fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    static Set<String> newExternalIds = new Set<String>();
    static Map<String,List<OrderItem>> orderItemsByExtId = new Map<String,List<OrderItem>>();
    static List<String> errors = new List<String>();
    static List<OrderItem> orderItemsToUpdate = new List<OrderItem>();
    static List<OrderItem> orderItemsToInsert = new List<OrderItem>();

        private static void init (PedidosJSON res) {
            
            codigos = new Set<String>();
            idCuentas = new Set<String>();
            Set<String> externalIds = new Set<String>();
            agentesIdsByOrderExternalId = new Map<String,String>(); //Added by Oscar
            Set<String> agentesExternalIds = new Set<String>(); // Added By Oscar

            // Modified by Oscar
            for (PedidosJSON.Pedido pedido : res.pedidos) {
                String idSap = pedido.IdSap != null ? String.valueOf(pedido.IdSap) : '';

                /* if (String.isNotBlank(pedido.CardCode) && pedido.SlpCode != null && String.isNotBlank(pedido.BusUnit) ) {
                        idCuentas.add(pedido.BusUnit.toUpperCase() + String.valueOf(pedido.SlpCode) + pedido.CardCode);
                    } */

                // Added By Oscar
                if (String.isNotBlank(pedido.CardCode) && String.isNotBlank(pedido.BusUnit) ) {
                    idCuentas.add(Accounts.generateAccountKey(pedido.BusUnit,pedido.CardCode));
                }
                
                if (String.isNotBlank(idSap) && String.isNotBlank(pedido.BusUnit)) {
                    String externalKey = idSap+pedido.BusUnit.toUpperCase();
                    externalIds.add(externalKey);

                    if(pedido.SlpCode != null){
                        agentesIdsByOrderExternalId.put(externalKey,String.valueOf(pedido.SlpCode));
                        agentesExternalIds.add(String.valueOf(pedido.SlpCode));
                    }
                }

                for (PedidosJSON.Producto producto : pedido.Productos) {
                    codigos.add(producto.ItemCode.toUpperCase());
                }
            }
            
            getAgentes(agentesExternalIds);
            cargarOrdenesSF(externalIds);
            cargarCuentas();
            cargarLugaresEntrega();
            cargarProductos();
            
        }
    
    //Added By Oscar
    private static void getAgentes(Set<String> agentesExternalIds){
        agenteSellerIdByExternalId = new Map<String,Id>();
        for(Agente__c agente : AgentesSelector.newInstance().selectByIdDeAgente(agentesExternalIds)){
            agenteSellerIdByExternalId.put(agente.ID_Base_de_Datos__c,agente.Vendedor__c);
        }
    }

    private static void cargarOrdenesSF (Set<String> externalIds) {
        
        mapOrdersByExternalID = new Map<String, Order>();
        
        for (Order ord : OrdersSelector.newInstance().selectByExternalIdWithProducts(externalIds)) {
            
            mapOrdersByExternalID.put(ord.ID_Externo__c, ord);
            
        }
        
        
    }
    
    private static void cargarCuentas () {
        
        mapCuentasIdExterno = new Map<String, Account>();
        
        for (Account acct : new AccountsSelector().selectByExternalId(idCuentas, 15000)) {
            
            mapCuentasIdExterno.put(acct.Clave_cliente__c, acct);
            
        }
        
    }
    
    
    private static void cargarLugaresEntrega () {
        
        mapaLE = new Map<String, Lugar_de_entrega__c>();
        
        for (Lugar_de_entrega__c le : new LugaresDeEntregaSelector().selectAll('25000')) {
            
            mapaLE.put(le.Name + le.Tipo_de_unidad__c, le);
            
        }
        
        
    }
    
    private static void cargarProductos () {
        
        mapaPBEntries = new Map<Id, Map<String, PricebookEntry>>();        
        
        for (PricebookEntry pbe : new PriceBookEntriesSelector().selectByProductCode(codigos, 15000)) {
            
            if (mapaPBEntries.containsKey(pbe.PriceBook2Id)) {
                
                mapaPBEntries.get(pbe.PriceBook2Id).put(String.valueOf(pbe.ProductCode).toUpperCase(), pbe);
                
            } else {
                
                mapaPBEntries.put(pbe.PriceBook2Id, new Map<String, PricebookEntry>{ String.valueOf(pbe.ProductCode).toUpperCase() => pbe });
                
            }
            
        }
        
        
    }
    
    public void execute (SchedulableContext sc) {
        
        processScheduler();
    }
    
    @future(callout=true) 
    private static void processScheduler () {

        try{
            System.debug('Entro a ScheduleObtenerPedidos -processScheduler');
            Cadena_MS__mdt tiempoEnHoras = [SELECT Cadena__c FROM Cadena_MS__mdt WHERE DeveloperName = 'MSPedidosTiempoHoras' LIMIT 1];
            Integer intTiempoHoras = Integer.valueOf(tiempoEnHoras.Cadena__c);

            Datetime dtNow = Datetime.now();
            Integer dtHora = dtNow.hour();
            Integer dtMinutos = dtNow.minute();

            Integer intHoraInicial = dtHora - intTiempoHoras;
            Integer intMinutosInicial = intHoraInicial < 0 ? 0 : dtMinutos;
            intHoraInicial = intHoraInicial < 0 ? 0 : intHoraInicial;

            String horaInicial = String.valueOf(intHoraInicial) + String.valueOf(intMinutosInicial) + '00';
            String horaFinal = String.valueOf(dtHora) + String.valueOf(dtMinutos) + '00';

            horaInicial = horaInicial.equals('240000') ? '235960' : horaInicial;
            horaFinal = horaFinal.equals('240000') ? '235960' : horaFinal;
            
            MSObtenerPedidos servicio = new MSObtenerPedidos();
            PedidosJSON res = servicio.obtenerPedidos(horaInicial, horaFinal);
            List<Order> ordersToUpdate = new List<Order>();
            List<Order> ordersToInsert = new List<Order>();
            List<OrderItem> items = new List<OrderItem>();
            /* Map<Id, OrderItem> unicosItems = new Map<Id, OrderItem>(); */
            Map<Id, OrderItem> deleteItems = new Map<Id, OrderItem>();
            
            System.debug('obtener orders ' + res);

            List<Pricebook2> stdPbk = [select Id, Name, IsActive from PriceBook2 where IsStandard=True LIMIT 1];
            
            if (res.pedidos != null) {
            
            init(res);

            List<String> pedidosEnIntegracion = new List<String>();

            Set<String> orderItemsToUpdateIds = new Set<String>();
            for (PedidosJSON.Pedido pedido : res.pedidos) {
                
                System.debug('pedido----'+pedido);
                /* 

                Mapeo de campos

                String Series = ord.Serie_del_Documento2__c;
                Date DocDueDate = ord.EffectiveDate;
                String Comments = ord.Comentarios__c;
                Decimal DiscPrcnt = ord.Descuento_general__c;
                String U_metodoDePagoCFD = ord.Tipo_de_pago__c;
                String U_EmpresaFinanciera = ord.Empresa_Financiera__c;
                String U_Flete = (ord.Incluye_flete__c ? '01' : '02');
                String U_Tipo = ord.C_digo_Tipo_de_Unidad__c;
                Decimal U_TarCam = ord.Factor_tarifa_camioneta__c;

                */
                
                String tipoUnidad = mapTipoUnidad.get(pedido.U_Tipo);
                // TODO mover llave externa a usar metodo de llave el Accounts
                /* String llaveExterna = String.isNotBlank(pedido.CardCode) && 
                    pedido.SlpCode != null && 
                    String.isNotBlank(pedido.BusUnit) ?
                    pedido.BusUnit.toUpperCase() + String.valueOf(pedido.SlpCode) + pedido.CardCode : null; */

                String llaveExterna = Accounts.generateAccountKey(pedido.BusUnit,pedido.CardCode); // Added By Oscar

                //SlpCode 2 cardcode 256350 BusUnit NU3
                Account cuenta = String.isNotBlank(llaveExterna) && mapCuentasIdExterno.containsKey(llaveExterna) ? 
                                    mapCuentasIdExterno.get(llaveExterna) : null;

                System.debug('cuenta-----'+cuenta);
                String idSap = pedido.IdSap != null ? String.valueOf(pedido.IdSap) : '';
                
                /*
                * TODO generar Error log no trae cuenta 
                */
                
                if (cuenta != null) {
                    System.debug(idSap+'------'+pedido.BusUnit);
                    Order ord;                    

                    // Added By Oscar
                    String orderExternalId = idSap+pedido.BusUnit.toUpperCase();
                    String agenteId = agentesIdsByOrderExternalId.containsKey(orderExternalId) ? agentesIdsByOrderExternalId.get(orderExternalId) : null;
                    agenteId = String.isNotBlank(pedido.BusUnit) ?  agenteId + pedido.BusUnit.toUpperCase() : null;

                    if (mapOrdersByExternalID.containsKey(orderExternalId) && 
                        !mapOrdersByExternalID.get(orderExternalId).Status.equals(PEDIDO_FACTURADO) ) {

                            ord = mapOrdersByExternalID.get(orderExternalId);
                            ord.Lugar_de_entrega__c = ( mapaLE.containsKey(pedido.U_LE+tipoUnidad) ? mapaLE.get(pedido.U_LE+tipoUnidad).Id : null);
                            ord.Tipo_de_unidad__c = tipoUnidad;
                            ord.Factor_flete_SAP__c = String.isNotBlank(pedido.U_Tarifa) ? Decimal.valueOf(pedido.U_Tarifa.replace(',','')) : 0;
                            ord.Referencia_SAP__c = pedido.Referencia;
                            ord.Integraci_n__c = true;
                            
                            /* if(String.isNotBlank(agenteId) && agenteSellerIdByExternalId.containsKey(agenteId)){
                                ord.OwnerId = agenteSellerIdByExternalId.get(agenteId);
                            } else{
                                ord.OwnerId = cuenta.OwnerId;
                            } */
                            
                            uow.registerDirty(ord);
                            // validar los productos que aun existen
                            for (OrderItem item : ord.OrderItems) {
                                
                                Boolean existeOrder = false;
                                
                                for (PedidosJSON.Producto producto : pedido.Productos) {
                                    
                                    if (producto.ItemCode.toUpperCase() == item.PricebookEntry.Product2.ProductCode.toUpperCase()) {
                                        
                                        existeOrder = true;
                                        break;
                                        
                                    }
                                    
                                }
                                
                                if (!existeOrder) {
                                    
                                    deleteItems.put(item.Id, item); 
                                    
                                }
                                
                            }
                            
                            // iterar productos
                            for (PedidosJSON.Producto producto : pedido.Productos) {
                                
                                // modificar campos de Item y agregar a lista para upsert
                                Decimal kilos = String.isNotBlank(producto.Kilos) ? Decimal.valueOf( producto.Kilos.replaceAll(',', '')) : null;                                
                                Decimal price = producto.Price != null ? Decimal.valueOf(producto.Price.replace(',', '')).setScale(2) : 0;
                                Decimal disc = producto.DiscPrcnt != null ? Decimal.valueOf(producto.DiscPrcnt.replace(',', '')).setScale(2) : 0;
                                Decimal precioDescuento =  price - (price * (disc/100));
                                
                                PricebookEntry pbe = mapaPBEntries.containsKey(ord.PriceBook2Id) && mapaPBEntries.get(ord.PriceBook2Id).containsKey(producto.ItemCode.toUpperCase()) ? 
                                    mapaPBEntries.get(ord.PriceBook2Id).get(producto.itemCode.toUpperCase()) : (!stdPbk.isEmpty() ? mapaPBEntries.get(stdPbk.get(0).Id).get(producto.ItemCode.toUpperCase()) : null);

                                        
                                Boolean existeEnSalesforce = false;
                                OrderItem ordItemUpd;
                                
                                for (OrderItem item : ord.OrderItems) {
                                    
                                    if (item.PricebookEntry.Product2.ProductCode.toUpperCase() == producto.ItemCode.toUpperCase()) {
                                        
                                        System.debug('item ' + item);
                                        
                                        existeEnSalesforce = true;
                                        
                                        // asignar producto existente
                                        ordItemUpd = item;
                                        break;
                                        
                                    }
                                    
                                    
                                    
                                }
                                //imprimir por separado
                                if (!existeEnSalesforce && pbe != null) {
                                    
                                    Order externalOrder = new Order(ID_Externo__c = idSap+pedido.BusUnit.toUpperCase());
                                    // crear nuevo producto
                                    ordItemUpd = new OrderItem(Order = new Order(ID_Externo__c = ord.ID_Externo__c), 
                                                               Product2Id = pbe.Product2Id, 
                                                               PricebookEntryId = pbe.Id,
                                                               Precio_SAP__c = price * pbe.Product2.Kilogramos_unidad__c
                                                              );
                                    
                                } 
                                
                                if (ordItemUpd != null && pbe != null) {
                                    
                                    if(pbe.Pricebook2Id != ord.Pricebook2Id){
                                        errors.add('El producto '+ pbe.ProductCode +' no pertenece a la lista de precios: '+ord.Lista_de_Precios__c+'  del pedido: '+ord.OrderNumber);
                                    }

                                    if(Constants.ORDER_STATUS.contains(ord.Status)){
                                        errors.add('No se puede agregar el producto '+ pbe.ProductCode+ ' al pedido ' +ord.OrderNumber+ ' ya que se encuentra activado');
                                    }

                                    ordItemUpd.Quantity = kilos != null && pbe.Product2.Kilogramos_unidad__c != null && kilos > 0 && pbe.Product2.Kilogramos_unidad__c > 0 ?  (kilos / pbe.Product2.Kilogramos_unidad__c) : 0;
                                    ordItemUpd.UnitPrice = pbe != null && pbe.Product2.Kilogramos_unidad__c != null ? precioDescuento * pbe.Product2.Kilogramos_unidad__c : 0;
                                    ordItemUpd.Descuento_SAP__c = String.isNotBlank(producto.DiscPrcnt) ? Decimal.valueOf(producto.DiscPrcnt.replace(',', '')) : 0;
                                    ordItemUpd.Integraci_n__c = true;
                                    
                                    if (String.isNotBlank(ordItemUpd.Id) && !orderItemsToUpdateIds.contains(ordItemUpd.Id)) {
                                        
                                        orderItemsToUpdate.add(ordItemUpd);
                                        orderItemsToUpdateIds.add(ordItemUpd.Id);
                                        /* unicosItems.put(ordItemUpd.Id, ordItemUpd); */
                                        /* uow.registerDirty(ordItemUpd); */
                                        
                                    } else if(ordItemUpd.Id == null) {
                                        
                                        /* System.debug('ordItemUpd.ID_Externo__c ' + ordItemUpd.Order); */
                                        orderItemsToInsert.add(ordItemUpd);
                                        /* items.add(ordItemUpd); */
                                        /* uow.registerNew(ordItemUpd); */
                                        
                                    }
                                    
                                }                            
                                
                            }
                            
                            ordersToUpdate.add(ord);
                            
                        } else if (!mapOrdersByExternalID.containsKey(idSap+pedido.BusUnit.toUpperCase())) {
                            String newExtId = String.isNotBlank(String.valueOf(pedido.IdSap)) && String.isNotBlank(pedido.BusUnit) ? 
                                                String.valueOf(String.valueOf(pedido.IdSap)) +  pedido.BusUnit.toUpperCase() : null;
                            ord = new Order(
                                Serie_del_Documento2__c = pedido.Series != null ? String.valueOf(pedido.Series) : null,
                                EffectiveDate = pedido.DocDueDate != null ? Date.valueOf(pedido.DocDueDate) : null,
                                Comentarios__c = pedido.Comments,
                                Descuento_general__c = pedido.DiscPrcnt != null ? Decimal.valueOf( pedido.DiscPrcnt.replace(',', '')).setScale(2) : 0,
                                Tipo_de_pago__c = pedido.U_metodoDePagoCFD,
                                Empresa_Financiera__c = pedido.U_EmpresaFinanciera,
                                Incluye_flete__c = pedido.U_Flete == '01' ? true : false,
                                AccountId = cuenta.Id,
                                Tipo_de_unidad__c = tipoUnidad,
                                Lugar_de_entrega__c = ( mapaLE.containsKey(pedido.U_LE+tipoUnidad) ? mapaLE.get(pedido.U_LE+tipoUnidad).Id : null),
                                Status = COTIZACION,
                                ID_SAP__c = String.valueOf(pedido.IdSap),
                                ID_Externo__c = newExtId,
                                Factor_flete_SAP__c = String.isNotBlank(pedido.U_Tarifa) ? Decimal.valueOf(pedido.U_Tarifa.replace(',', '')) : 0,
                                Referencia_SAP__c = pedido.Referencia,
                                Integraci_n__c = true
                                
                            );
                            
                            if (String.isBlank(cuenta.Lista_de_Precio__c)) {
                                ord.PriceBook2Id = !stdPbk.isEmpty() ? stdPbk.get(0).Id : null;
                            }

                            // Added By Oscar
                            if(String.isNotBlank(agenteId) && agenteSellerIdByExternalId.containsKey(agenteId)){
                                ord.OwnerId = agenteSellerIdByExternalId.get(agenteId);
                            }else{
                                ord.OwnerId = cuenta.OwnerId;
                            }
                            
                            uow.registerNew(ord);
                            /* Order externalOrder = new Order(ID_Externo__c = String.valueOf(pedido.IdSap)+pedido.BusUnit.toUpperCase()); */

                            for (PedidosJSON.Producto producto : pedido.Productos) {
                                
                                //String productoId = mapaCodigoProductos.containsKey(producto.ItemCode) ? mapaCodigoProductos.get(producto.itemCode).Id : null;
                                
                                /* PricebookEntry pbe = mapaPBEntries.containsKey(cuenta.Lista_de_Precio__c) && mapaPBEntries.get(cuenta.Lista_de_Precio__c).containsKey(producto.ItemCode) ? 
                                    mapaPBEntries.get(cuenta.Lista_de_Precio__c).get(producto.itemCode) : (!stdPbk.isEmpty() ? mapaPBEntries.get(stdPbk.get(0).Id).get(producto.ItemCode) : null); */

                                PricebookEntry pbe = mapaPBEntries.containsKey(ord.PriceBook2Id) && mapaPBEntries.get(ord.PriceBook2Id).containsKey(producto.ItemCode.toUpperCase()) ? 
                                    mapaPBEntries.get(ord.PriceBook2Id).get(producto.itemCode.toUpperCase()) : (!stdPbk.isEmpty() ? mapaPBEntries.get(stdPbk.get(0).Id).get(producto.ItemCode.toUpperCase()) : null);
                                


                                Decimal price = producto.Price != null ? Decimal.valueOf(producto.Price.replace(',', '')).setScale(2) : 0;
                                Decimal disc = producto.DiscPrcnt != null ? Decimal.valueOf(producto.DiscPrcnt.replace(',', '')).setScale(2) : 0;
                                
                                Decimal precioDescuento =  price - (price * (disc/100));
                                                                
                                if (pbe != null ) {
                                    List<OrderItem> orderItemsList = orderItemsByExtId.containsKey(newExtId) ? orderItemsByExtId.get(newExtId) : new List<OrderItem>();

                                    Decimal kilos = String.isNotBlank(producto.Kilos) ? Decimal.valueOf( producto.Kilos.replaceAll(',', '')) : null;

                                    OrderItem item = new OrderItem(Product2Id = pbe.Product2Id, 
                                                                   Quantity = kilos != null && pbe.Product2.Kilogramos_unidad__c != null && kilos > 0 && pbe.Product2.Kilogramos_unidad__c > 0 ? 
                                                                                 (kilos / pbe.Product2.Kilogramos_unidad__c) : 0,
                                                                   /* Order = externalOrder, */
                                                                   
                                                                   UnitPrice = precioDescuento * pbe.Product2.Kilogramos_unidad__c,
                                                                   PricebookEntryId = pbe.Id,
                                                                   Precio_SAP__c = price * pbe.Product2.Kilogramos_unidad__c,
                                                                   Integraci_n__c = true// necesario si no no se puede insertar
                                                                  );

                                    if(pbe.Pricebook2Id != ord.Pricebook2Id){
                                        errors.add('El producto '+ pbe.ProductCode +' no pertenece a la lista de precios: '+ord.Lista_de_Precios__c+'  del pedido: '+ord.OrderNumber);
                                    }

                                    if(item != null){
                                        orderItemsList.add(item);
                                        orderItemsByExtId.put(newExtId,orderItemsList);
                                    }
                                    
                                }
                                
                            }
                            
                            ordersToInsert.add(ord);
                            
                        }
                    
                }
                
            }

            uow.commitWork();
            
            if(!orderItemsToInsert.isEmpty()){
                insert orderItemsToInsert;
            }

            if(!orderItemsToUpdate.isEmpty()){
                update orderItemsToUpdate;
            }
            
            

            List<OrderItem> orderItemsToInsertWithNewOrder = new List<OrderItem>();

            for(String extId : orderItemsByExtId.keySet()){
                for(OrderItem entry : orderItemsByExtId.get(extId)){
                    
                    entry.Order = new Order(ID_Externo__c = extId);
                    /* entry.OrderId = newOrdersbyExtId.get(extId).Id; */
                    orderItemsToInsertWithNewOrder.add(entry);
                }

            }


            /* DMLUtils.insertRecords(orderItemsToInsert,false); */
            insert orderItemsToInsertWithNewOrder;
           /*  DMLUtils.insertRecords(items, false); */
            
            /* List<OrderItem> oiAux = new List<OrderItem>(); */
            /* oiAux.addAll(unicosItems.values()); */

            /* List<Orderitem> itemsToUpdate = unicosItems.values(); */
            /* List<Orderitem> itemsToInsert = new List<Orderitem>();

            for(OrderItem item : items){
                if(String.isNotBlank(item.Id)){
                    itemsToUpdate.add(item);
                } else{
                    itemsToInsert.add(item);
                }
               
            } */
            
            /* List<OrderItem> upsertItems = new List<OrderItem>();
            upsertItems.addAll(oiAux);
            upsertItems.addAll(items); */
            
            /* List<Database.UpsertResult> upsertResults = Database.upsert(orders, Order.ID_Externo__c, false); */

            /* insert ordersToInsert; */

            /* DMLUtils.insertRecords(ordersToInsert, false); */
            /* update ordersToUpdate; */

            /* DMLUtils.updateRecords(ordersToUpdate, false); */

            /* update itemsToUpdate;
            insert itemsToInsert; */

            /* List<Database.UpsertResult> upsertResultsItems = Database.upsert(upsertItems, false); */
            

            

            List<Order> cotizaciones = new List<Order>();

            List<Order> orders = new List<Order>();
            orders.addAll(ordersToInsert);
            orders.addAll(ordersToUpdate);

            for (Order ord : orders ) {
                
                if (ord.Status.equals(COTIZACION)) {
                    
                    ord.Status = CAPTURADO;
                    cotizaciones.add(ord);
                }
                                
            }


            update cotizaciones;
            /* DMLUtils.updateRecords(cotizaciones, false); */
            DMLUtils.deleteRecords(deleteItems.values(), false);

            }
        } catch(Exception e){
            System.debug('ERROR: '+e.getMessage());
            uow = Application.UnitOfWork.newInstance();
            Error_Log__c errLog;

            if(errors.isEmpty()){
                errLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
            } else{
                String errStr = '';
                for(String err : errors){
                    errStr += err + '\n';
                }
                errLog = ErrorLog.log(errStr, e.getStackTraceString(), e.getLineNumber()); 
            }
             
            errLog.Integration__c = true;

            uow.registerNew(errLog);
            uow.commitWork();
        }
        
    }
    
}