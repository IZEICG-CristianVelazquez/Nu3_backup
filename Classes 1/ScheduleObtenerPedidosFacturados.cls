public with sharing class ScheduleObtenerPedidosFacturados implements Schedulable, Database.AllowsCallouts {
    
    // https://apispruebas.gruponu3.com/facturas/ PRUEBAS 
    
    private final static String PEDIDO_FACTURA = 'Factura';
    private final static String PEDIDO_FACTURADO = 'Facturado';
    
    private final static String PEDIDO_CANCELADO = 'Cancelado';
    private final static String CANCELADA = 'Y';
    
    private static Map<String, Order> mapOrdersByExternalID;
    private static List<Order> listOrdersByExternalID;
    private static List<Order> listFacOrdersByExternalID;
    
    
    
    private static Map<String, Order> mapFacOrdersByExternalID;
    
    static Map<Id, Map<String, PricebookEntry>> mapaPBEntries;
    static Map<String, Account> mapCuentasIdExterno;
    static Set<String> idCuentas;
    
    static List<Order> orders;
    static List<OrderItem> orderItems;
    
    static Set<String> externalIds;
    static Set<String> facExternalIds;
    
    private static Id facturasRT;
    static List<Pricebook2> stdPbk;
    
    
    private static void init (FacturasJSON res) {
        
        listOrdersByExternalID = new List<Order>();
        listFacOrdersByExternalID = new List<Order>();
        stdPbk = [select Id, Name, IsActive from PriceBook2 where IsStandard=True LIMIT 1];
        
        
        orders = new List<Order>();
        orderItems = new List<OrderItem>();
        
        Set<String> codigos = new Set<String>();
        externalIds = new Set<String>();
        facExternalIds = new Set<String>();
        idCuentas = new Set<String>();
        facturasRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
        
        for (FacturasJSON.Pedido pedido : res.pedidos) { 
            
            String idFacSAP = pedido.IdFacSap != null ? String.valueOf(pedido.IdFacSap) : '';
            
            if (String.isNotBlank(idFacSAP)) {
                facExternalIds.add(idFacSAP + pedido.BusUnit.toUpperCase());
            }
            
            for (FacturasJSON.Producto producto : pedido.Productos) {
                
                String idSAP = producto.IdSap != null ? String.valueOf(producto.IdSap) : '';
                
                codigos.add(producto.ItemCode);
                
                if (String.isNotBlank(idSAP)) {
                    externalIds.add(idSAP + pedido.BusUnit.toUpperCase());
                }
                
                if (String.isNotBlank(pedido.CardCode) && pedido.SlpCode != null && String.isNotBlank(pedido.BusUnit) ) {
                    idCuentas.add(pedido.BusUnit.toUpperCase() + String.valueOf(pedido.SlpCode).toUpperCase() + pedido.CardCode.toUpperCase());
                }
            }
        }
        cargarOrdenesSF(externalIds);
        cargarFacOrdenesSF(facExternalIds);
        cargarProductos(codigos);
        cargarCuentas();
        
    }
    
    private static void cargarOrdenesSF (Set<String> externalIds) {
        
        mapOrdersByExternalID = new Map<String, Order>();
        
        for (Order ord : new OrdersSelector().selectByExternalId(externalIds)) {
            mapOrdersByExternalID.put(ord.ID_Externo__c, ord);
        }
      	system.debug('set id order'+externalIds);
        System.debug('mapOrdersByExternalID' + mapOrdersByExternalID);
        
    }
    
    private static void cargarFacOrdenesSF (Set<String> facExternalIds) {
        
        mapFacOrdersByExternalID = new Map<String, Order>();
        
        for (Order ord : new OrdersSelector().selectByExternalIdWithProducts(facExternalIds)) {
            mapFacOrdersByExternalID.put(ord.ID_Externo__c, ord);
        }
        
        System.debug('mapFacOrdersByExternalID' + facExternalIds);
        
    }
    
    private static void cargarProductos (Set<String> codigos) {
        
        mapaPBEntries = new Map<Id, Map<String, PricebookEntry>>();        
        
        for (PricebookEntry pbe : new PriceBookEntriesSelector().selectByProductCode(CODIGOS, 15000)) { 
            
            if (mapaPBEntries.containsKey(pbe.PriceBook2Id)) {

                mapaPBEntries.get(pbe.PriceBook2Id).put(pbe.ProductCode, pbe);
            } else {

                mapaPBEntries.put(pbe.PriceBook2Id, new Map<String, PricebookEntry>{ pbe.ProductCode => pbe });
            }        
        } 
        
        System.debug('mapaPBEntries cliente' + mapaPBEntries);
        
    }
    
    private static void cargarCuentas () {
        
        mapCuentasIdExterno = new Map<String, Account>();
        
        for (Account acct : new AccountsSelector().selectByExternalId(idCuentas, 15000)) {
            mapCuentasIdExterno.put(acct.Clave_cliente__c, acct);
        }
         System.debug('Set Cuentas: '+idCuentas);
    }
    
    
   
    public void execute (SchedulableContext sc) {
        
        processScheduler();
        
    }
    
    @future(callout = true)
    private static void processScheduler () {
        try{
            Datetime dtNow = Datetime.now();
            Integer dtHora = dtNow.hour();
            Integer dtMinutos = dtNow.minute();
    
            Integer intHoraInicial = dtHora - 1;
            Integer intMinutosInicial = intHoraInicial < 0 ? 0 : dtMinutos;
            intHoraInicial = intHoraInicial < 0 ? 0 : intHoraInicial;
    
            String horaInicial = String.valueOf(intHoraInicial) + String.valueOf(intMinutosInicial) + '00';
            String horaFinal = String.valueOf(dtHora) + String.valueOf(dtMinutos) + '00';
            
            horaInicial = horaInicial.equals('240000') ? '235960' : horaInicial;
            horaFinal = horaFinal.equals('240000') ? '235960' : horaFinal;
            
            system.debug(horaInicial+'  '+ horaFinal);
            MSObtenerPedidosFacturados servicio = new MSObtenerPedidosFacturados();
            FacturasJSON res = servicio.obtenerPedidos(horaInicial,horaFinal);
            
            if (res.pedidos != null ) {
                
                init(res);
                
                for (FacturasJSON.Pedido pedido : res.pedidos) {
                    
                    String cardcode = pedido.CardCode != null ? String.valueOf(pedido.CardCode).toUpperCase() : '';           
                    String busUnit = pedido.BusUnit != null ? String.valueOf(pedido.BusUnit).toUpperCase() : '';
                    String slpCode = pedido.SlpCode != null ? String.valueOf(pedido.SlpCode).toUpperCase() : '';
                    String claveCliente = busUnit + slpCode + cardcode;
                    String esCancelada = pedido.Cancelada;
                    String docDueDate = pedido.DocDueDate;
                    
                    System.debug('cardcode: '+cardcode);
                    System.debug('busUnit: '+busUnit);
                    System.debug('slpCode: '+slpCode);
                    System.debug('claveCliente: '+claveCliente);
                    System.debug('esCancelada: '+esCancelada);
                   
                    Account cliente = mapCuentasIdExterno.containsKey(claveCliente) ? mapCuentasIdExterno.get(claveCliente):null;
                    System.debug('cliente = ' + cliente);
                    
                    if(cliente != null){
                        
                        //se revisa cada producto en en el pedido
                        for (FacturasJSON.Producto producto : pedido.Productos) {
                            
                            String idSAP = producto.idSap != null ? String.valueOf(producto.idSap) : '';
                            System.debug('ENTONCES BUSCO A (IDSAP) [' + idSAP +']'+ pedido.BusUnit.toUpperCase());
                            
                            //el pedido debe cambiar a facturado independientemente de los valores de CANCELADA
                            if(mapOrdersByExternalID.containsKey(idSAP + pedido.BusUnit.toUpperCase())){
                                
                                System.debug('VALOR ACTUAL --------' + mapOrdersByExternalID.get(idSAP + pedido.BusUnit.toUpperCase()).Status);
                                mapOrdersByExternalID.get(idSAP + pedido.BusUnit.toUpperCase()).Status = PEDIDO_FACTURADO;
                                mapOrdersByExternalID.get(idSAP + pedido.BusUnit.toUpperCase()).Fecha_Vencimiento_Factura__c  =  String.IsNotBlank(docDueDate) ? Date.valueOf(docDueDate) : null;
                                System.debug('ENTONCES CAMBIO STATUS DE PEDIDO A (Facturado) --------' + mapOrdersByExternalID.get(idSAP + pedido.BusUnit.toUpperCase()).Status);
                                 
                                
                            } 
                            
                        } 
                        
                        //Los valores de CANCELADA afectan sólo a la factura
                        String idFacSAP = pedido.idFacSap != null ? String.valueOf(pedido.idFacSap) : '';                
                        System.debug('BUSCAR --------' + idFacSAP + pedido.BusUnit.toUpperCase());
                        
                        if(mapFacOrdersByExternalID.containsKey(idFacSAP + pedido.BusUnit.toUpperCase())){
                            
                            if(pedido.Cancelada == CANCELADA){
                                
                                System.debug('SI ES CANCELADA');
                                mapFacOrdersByExternalID.get(idFacSAP + pedido.BusUnit.toUpperCase()).Status = PEDIDO_CANCELADO;
                                System.debug('ENTONCES CAMBIO STATUS DE FACTURA A CANCELADO --------' + mapFacOrdersByExternalID.get(idFacSAP + pedido.BusUnit.toUpperCase()).Status);
                                
                            }
    
                            OrderItem ordItemUpd;
                            Order OrderExistente = mapFacOrdersByExternalID.get(idFacSAP + pedido.BusUnit.toUpperCase());                        
                            System.debug('OrderExistente-------'+OrderExistente);
                            
                            for (FacturasJSON.Producto producto : pedido.Productos) {
                                
                                System.debug('producto-------'+producto.ItemCode);
                                System.debug('OrderExistente.orderItems-------'+OrderExistente.orderItems);
                                
                                Boolean existeEnSalesforce = false;
                                for(OrderItem item : OrderExistente.orderItems){
                                    
                                    System.debug('Existe item ' + item);
                                    System.debug('Comparando Id de productos para verificar existencia¡¡');
                                    System.debug('item.PricebookEntry.Product2.ProductCode:'+item.PricebookEntry.Product2.ProductCode+'producto.ItemCode:'+ producto.ItemCode);
                                    
                                    if (item.PricebookEntry.Product2.ProductCode == producto.ItemCode) {
                                    
                                        System.debug('item.PricebookEntry.Product2.ProductCode ' + item.PricebookEntry.Product2.ProductCode);
                                        System.debug('item.PricebookEntry'+item.PricebookEntry);
                                        existeEnSalesforce = true;
                                        ordItemUpd = item;
                                        break;
                                    }
                                }
                                System.debug('Id que envío ---->'+idFacSAP+pedido.BusUnit.toUpperCase());
                                
                                if (existeEnSalesforce==false) {  
                                    
                                    Order externalOrder = new Order(ID_Externo__c = idFacSAP+pedido.BusUnit.toUpperCase());
                                    crearProducto(producto,cliente,String.valueOf(pedido.idFacSap),externalOrder); 
                                }
                                
                            }
                            
                            
                            
                        }else{
                            
                            //CREAR NUEVA ORDER Y DE SUS PRODUCTOS OBTENER EL ORDER (idSap) Y CAMBIARLE STATUS A FACTURADO
                            System.debug('ENTRA A CREAR ORDER');
                            crearOrden(pedido, cliente, idFacSAP);
                            
                            for (FacturasJSON.Producto producto : pedido.Productos) {
                            
                                String idSAP = producto.idSap != null ? String.valueOf(producto.idSap) : '';                
                                System.debug('busca ' + idSAP + pedido.BusUnit.toUpperCase());
                                
                                if(mapOrdersByExternalID.containsKey(idSAP + pedido.BusUnit.toUpperCase())){
                                
                                    mapOrdersByExternalID.get(idSAP + pedido.BusUnit.toUpperCase()).Status = PEDIDO_FACTURA;
                                }  
                            } 
                        }
                        
                    }else{
                        
                        String idFacSAP = pedido.idFacSap != null ? String.valueOf(pedido.idFacSap) : '';                
                        System.debug('NO EXISTE EL CLIENTE' + idFacSAP);
                    }
                }
                
                listOrdersByExternalID.addall(mapOrdersByExternalID.values());
                listFacOrdersByExternalID.addall(mapFacOrdersByExternalID.values());
                
                System.debug('::::orderItems: ' + orderItems.size());
                System.debug('::::orders: ' + orders.size());
                System.debug('::::listOrdersByExternalID: ' + listOrdersByExternalID.size());
                System.debug('::::listFacOrdersByExternalID: ' + listFacOrdersByExternalID.size());
               
              
                DMLUtils.insertRecords(orders, false);
                DMLUtils.insertRecords(orderItems, false);
                DMLUtils.updateRecords(listOrdersByExternalID, false);
                DMLUtils.updateRecords(listFacOrdersByExternalID, false);    
            }
        } catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }
        

        
    }
    
    private static void crearOrden(FacturasJSON.Pedido pedido, Account cliente, String IdFacSap){
        
        System.debug('CREANDO ORDEN');
        Decimal flete = pedido.Flete != null ? Decimal.valueOf(pedido.Flete.replace(',', '')).setScale(5) : 0;
        
        
        
        Order ord = new Order(
            RecordTypeId = facturasRT,
            AccountId = cliente.Id,
            EffectiveDate = pedido.DocDate != null ? Date.valueOf(pedido.DocDate) : null,
            Fecha_de_facturacion__c = pedido.DocDate != null ? Date.valueOf(pedido.DocDate) : null,
            Fecha_Vencimiento_Factura__c = pedido.DocDueDate != null ? Date.valueOf(pedido.DocDueDate) : null,
            Comentarios__c = pedido.Comments,
            Factura__c = String.valueof(pedido.IdFacSap),
            Estatus_de_Factura__c = pedido.Estatus,
            Status = PEDIDO_FACTURA,
            Empresa_Financiera__c = pedido.U_EmpresaFinanciera,
            Serie_del_Documento2__c = String.valueof(pedido.Series), 
            Tipo_de_pago__c = pedido.U_metodoDePagoCFD,
            Flete_Facturado__c = flete,
            ID_Externo__c = idFacSAP + pedido.BusUnit.toUpperCase()
        );
        
        
        if (String.isBlank(cliente.Lista_de_Precio__c)) {
            ord.PriceBook2Id = !stdPbk.isEmpty() ? stdPbk.get(0).Id : null;
        }
        
        orders.add(ord);
        
        
        Order externalOrder = new Order(ID_Externo__c = idFacSAP + pedido.BusUnit.toUpperCase());
        
        for (FacturasJSON.Producto producto : pedido.Productos) {
            
            crearProducto(producto, cliente, idFacSAP, externalOrder);
            
        }
        
    }
    
    private static void crearProducto(FacturasJSON.Producto producto, Account cliente, String idFacSap, Order externalOrder){
        
        System.debug('cliente ' + cliente);
        System.debug('mapaPBEntries ' + mapaPBEntries);
        System.debug('producto ' + producto);
        
        /*
        PricebookEntry pbe = mapaPBEntries.containsKey(cliente.Lista_de_Precio__c) &&
            mapaPBEntries.get(cliente.Lista_de_Precio__c).containsKey(producto.ItemCode) &&
            cliente != null? 
            mapaPBEntries.get(cliente.Lista_de_Precio__c).get(producto.ItemCode) : (!stdPbk.isEmpty() ? mapaPBEntries.get(stdPbk.get(0).Id).get(producto.ItemCode) : null);
*/
        PricebookEntry pbe;
        if(mapaPBEntries.containsKey(cliente.Lista_de_Precio__c) && mapaPBEntries.get(cliente.Lista_de_Precio__c).containsKey(producto.ItemCode) && cliente != null){
            
            pbe = mapaPBEntries.get(cliente.Lista_de_Precio__c).get(producto.ItemCode);
        }else if (!stdPbk.isEmpty()){
            
            pbe = mapaPBEntries.get(stdPbk.get(0).Id).get(producto.ItemCode);
        }
        
        System.debug('pbe--->'+pbe);
        Decimal price = producto.Price != null ? Decimal.valueOf(producto.Price.replace(',', '')).setScale(5) : 0;
        Decimal disc = producto.DiscPrcnt != null ? Decimal.valueOf(producto.DiscPrcnt.replace(',', '')).setScale(5) : 0;
        Decimal grssProfit = producto.GrssProfit != null ? Decimal.valueOf(producto.GrssProfit.replace(',', '')).setScale(5) : 0;
        Decimal precioDescuento =  price - (price * (disc/100));
        
        if (pbe != null ) {                
            Decimal kilos = String.isNotBlank(producto.Kilos) ? Decimal.valueOf( producto.Kilos.replaceAll(',', '')) : null;
            
            OrderItem item = new OrderItem(
                Precio_Unitario_Facturado__c = price, 
                Precio_SAP__c = price * pbe.Product2.Kilogramos_unidad__c,
                UnitPrice = price * pbe.Product2.Kilogramos_unidad__c,
                Quantity = kilos != null && pbe.Product2.Kilogramos_unidad__c != null && kilos > 0 && pbe.Product2.Kilogramos_unidad__c > 0 ?  (kilos / pbe.Product2.Kilogramos_unidad__c) : 0,
                Cantidad_Facturada__c = kilos != null && pbe.Product2.Kilogramos_unidad__c != null && kilos > 0 && pbe.Product2.Kilogramos_unidad__c > 0 ?  (kilos / pbe.Product2.Kilogramos_unidad__c) : 0,
                Descuento_Facturado__c = disc,
                Descuento_SAP__c = disc,
                ID_SAP_Pedido__c = producto.IdSAP,
                Ganancia_Bruta__c = grssProfit,
                ID_SAP_Factura__c = idFacSAP, 
                Entrega__c = producto.Entrega,
                LineNum__c = producto.LineNum,
                
                Product2Id = pbe.Product2Id, 
                PricebookEntryId = pbe.Id,
                
                
                Order = externalOrder
            );
            
            orderItems.add(item); 
            
        }
    }
    
}