public with sharing class ServicePedidosHelper {

    private static final String BD_LAGOS = 'NU3_AgropecuariaPiedadense_LAGOS';

    public class ServicePedidosException extends Exception {}

    private static Map<Id, Order> mapOrders;

    private static void cargarPedidos (List<ServicePedidos.WSPedido> pedidos) {

        Set<Id> orderIds = new Set<Id>();

        for (ServicePedidos.WSPedido pedido : pedidos) {

            if (String.isNotBlank(pedido.IdSalesforce)) {

                orderIds.add(pedido.IdSalesforce);

            }

        }

        mapOrders = new Map<Id, Order>((List<Order>)  
    
            new OrdersSelector().selectByIdWithAccountInfo(orderIds)
        
        );

    }

    public static void actualizarUltimosPedidos (ServicePedidos.WSResponsePedidos container) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        System.debug('Entro a ServicePedidosHelper -actualizarUltimosPedidos');
        List<Order> lstOrder = new List<Order>();
        /* ErrorLog el = new ErrorLog(); */

        cargarPedidos(container.Pedidos);

        for (ServicePedidos.WSPedido pedido : container.Pedidos) {

            String baseDeDatos = mapOrders.containsKey(pedido.IdSalesforce) ? mapOrders.get(pedido.IdSalesforce).Account.Base_de_Datos__c : null;
            

            if (String.isNotBlank(baseDeDatos)) {

                String llaveExterna = pedido.IdSap + baseDeDatos.toUpperCase();
                lstOrder.add(new Order(Status = pedido.Status, ID_SAP__c = pedido.IdSap, Id = pedido.IdSalesforce, ID_Externo__c = llaveExterna));

            } else {
                uow.registerNew(ErrorLog.log('No se encontro la base de datos', pedido.IdSap));
                /* el.log('No se encontro la base de datos', pedido.IdSap); */

            }
            uow.commitWork();
            /* el.saveErrors(); */

        }

        DMLUtils.upsertRecords(lstOrder, false);

    }


    public static List<ServicePedidos.WSPedido> obtenerUltimosPedidos () {
        
        List<ServicePedidos.WSPedido> pedidos = new List<ServicePedidos.WSPedido>();
        
        for (Order ord : new OrdersSelector().selectRecentlyUpdatedWithOrderItems(5000)) {

            List<ServicePedidos.WSProducto> productos = new List<ServicePedidos.WSProducto>();

            for (OrderItem oi : ord.OrderItems) {

                productos.add(new ServicePedidos.WSProducto( oi.Product2.ProductCode, oi.Quantity, oi.Descuento_por_l_nea__c, oi.Product2.Codigo_Impuesto__c, null, null, oi.Precio_kg__c, oi.Id));
                
            }

            DateTime gmtCreatedDate = datetime.valueOfGmt(String.valueOf(ord.CreatedDate));

            String CardCode = ord.Account.ID_SAP__c;
            String Series = ord.Serie_del_Documento2__c;
            Date DocDate = date.newinstance(gmtCreatedDate.year(), gmtCreatedDate.month(), gmtCreatedDate.day());
            Date DocDueDate = ord.EffectiveDate;
            String SlpCode = ord.Account.ID_Agente__c;
            String Comments = String.isNotBlank(ord.Comentarios__c) && ord.Comentarios__c.length() > 250 ? ord.Comentarios__c.substring(0, 249) : ord.Comentarios__c;
            String JrnlMemo = '';
            String Project = ord.Account.Proyecto__c;
            String BusUnit = ord.Account.Base_de_Datos__c;
            Decimal DiscPrcnt = ord.Descuento_general__c;
            String ShipToCode = String.valueOf( ord.Account.BillingAddress);
            String U_metodoDePagoCFD = ord.Tipo_de_pago__c;
            String U_EmpresaFinanciera = ord.Empresa_Financiera__c;
            String U_VentaDelCU = ord.Pricebook2.Centro_de_Utilidad__c;
            String U_Flete = (ord.Incluye_flete__c ? '01' : '02');
            String U_LE = ord.Lugar_de_entrega__r.Name;
            String U_Tipo = ord.C_digo_Tipo_de_Unidad__c;
            
            Decimal U_Tarifa = BD_LAGOS.equals(BusUnit) ? ord.Account.Tarifa_flete__c : ord.Lugar_de_entrega__r.Factor__c;

            Decimal U_TarCam = ord.Factor_tarifa_camioneta__c;
            List<ServicePedidos.WSProducto> ProductosLst = productos;

            pedidos.add( new ServicePedidos.WSPedido(CardCode, Series, DocDate, DocDueDate, SlpCode, Comments, JrnlMemo, 
            Project, BusUnit, DiscPrcnt, ShipToCode,
            U_metodoDePagoCFD, U_EmpresaFinanciera, U_VentaDelCU, U_Flete, U_LE, U_Tipo,
            U_Tarifa, U_TarCam, productos, ord.Id, ord.ID_SAP__c) );
            

        }
        
        return pedidos;

    }

}