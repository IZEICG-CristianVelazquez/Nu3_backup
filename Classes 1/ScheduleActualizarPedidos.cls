public class ScheduleActualizarPedidos implements Schedulable, Database.AllowsCallouts {
    
    private final static String ESTATUS_CANCELADO = 'Y';
    private final static String PEDIDO_CANCELADO = 'Cancelado';
    private final static String SI = 'si';
    private final static String PEDIDO_CAPTURADO = 'Capturado en SAP';
    private final static String PEDIDO_LIBERADO = 'Liberado';
    private final static String PEDIDO_REVISADO = 'Revisado';

    private static Map<String, Order> mapOrdersByExternalID;

    private static void cargarPedidos (PedidosActualizadosJSON container) {

        Set<String> orderIds = new Set<String>();
        
        if (container.Pedidos != null) {
            for (PedidosActualizadosJSON.Pedido pedido : container.Pedidos) {

                if (pedido != null && String.isNotBlank(pedido.BusUnit) && pedido.DocNum != null) {

                    orderIds.add(pedido.DocNum+pedido.BusUnit.toUpperCase());

                }

            }

            mapOrdersByExternalID = new Map<String, Order>();

            for (Order ord : new OrdersSelector().selectByExternalId(orderIds)) {

                mapOrdersByExternalID.put(ord.ID_Externo__c, ord);

            }

        }
        

    }

    public void execute (SchedulableContext sc) {

        processScheduler();
        
    }

    @future(callout=true)
    private static void processScheduler () {
        
        try{
            MSObtenerEstatusPedidos servicio = new MSObtenerEstatusPedidos();
            PedidosActualizadosJSON res = servicio.obtenerPedidos();
            List<Order> orders = new List<Order>();
    
            cargarPedidos(res);
            if (res.Pedidos != null) {
    
                for (PedidosActualizadosJSON.Pedido pedido : res.pedidos) {
    
                    /* 
                    
                    Mapeo de campos
    
                    ID_Externo__c = DocNum + BusUnit
    
                    */
    
                    String idSap = pedido.DocNum != null ? String.valueOf(pedido.DocNum) : '';
    
                    Order ord;
                    
                    // validacion de estatus Y
                    if (pedido.Estatus != null && pedido.Estatus.equals(ESTATUS_CANCELADO) &&
                            mapOrdersByExternalID.containsKey(idSap+pedido.BusUnit.toUpperCase()) ) {
                        
                        ord = mapOrdersByExternalID.get(idSap+pedido.BusUnit.toUpperCase());
                        ord.Integraci_n__c = true;
                        ord.Status = PEDIDO_CANCELADO;
                        orders.add(ord);           
    
                    } else if ( String.isNotBlank(pedido.BusUnit) && 
                                mapOrdersByExternalID.containsKey(idSap+pedido.BusUnit.toUpperCase())) {
    
                        ord = mapOrdersByExternalID.get(idSap+pedido.BusUnit.toUpperCase());
                        ord.Integraci_n__c = true;

                        if ( String.isNotBlank(pedido.Liberado) && pedido.Liberado.toLowerCase().equals(SI) && (
                            mapOrdersByExternalID.get(idSap+pedido.BusUnit.toUpperCase()).Status.equals(PEDIDO_CAPTURADO) ||
                            mapOrdersByExternalID.get(idSap+pedido.BusUnit.toUpperCase()).Status.equals(PEDIDO_REVISADO)) ) {
                            ord.Status = PEDIDO_LIBERADO;
                            orders.add(ord);           
    
                        } else if (String.isNotBlank(pedido.Impreso) && pedido.Impreso.toLowerCase().equals(SI) && (
                            mapOrdersByExternalID.get(idSap+pedido.BusUnit.toUpperCase()).Status.equals(PEDIDO_CAPTURADO) ) ) {
    
                            ord.Status = PEDIDO_REVISADO;
                            orders.add(ord);           
    
                        }            
                        
    
                    }
    
                }
    
                DMLUtils.updateRecords(orders, false);
    
            }
        }catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

        
    }

}