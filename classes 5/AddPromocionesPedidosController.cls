public without sharing class AddPromocionesPedidosController {

    private List<Order> pedidos;
    private ApexPages.StandardController std;
    public List<PricebookEntry> lstPricebook {get;set;}

    public String lstDetallePromocion{get;set;}
    public Boolean isSelected {get; set; }
    private String pedidoId;
    private String listaPrecios;

    Set<Id> lstIdProductosPedido;

    List<Promocion__c> lstProductosPromocion;
    List<OrderItem> lstProductosOrderItem;
    List<orderItem> lstAllProductosOrderItem;
    List<AggregateResult> lstProductosWithProductPromotion;
    Map<String,Decimal> mapProductosItem;

    //constructor
    public AddPromocionesPedidosController(ApexPages.StandardController sc){
		
        System.debug('AddPromocionesPedidosController [Constructor]');

        pedidoId = sc.getId();
        std = sc;
        pedidos = new OrdersSelector().selectByIdWithProducts(new Set<Id>{pedidoId});
        
        System.debug('PEDIDOS: '+System.JSON.serializePretty(pedidos));
        
        lstPricebook = new List<PricebookEntry>();
        lstIdProductosPedido = new Set<Id>();
        lstProductosPromocion = new List<Promocion__c>();

        mapProductosItem = new Map<String, Decimal>();

        lstDetallePromocion = '';
        isSelected = false;


    }
    public Pagereference addDetallesPromocion(){
		System.debug('addDetallesPromocion');
        if(String.isNotBlank(lstDetallePromocion)){
            List<OrderItem> lstOrderItem = new List<OrderItem>();

            List<Object> m = (List<Object>) JSON.deserializeUntyped(lstDetallePromocion);
            Set<String> product2Ids = new Set<String>();

            for(Object pr : m){
                Map<String,Object> data = (Map<String,Object>)pr;

                product2Ids.add((String)data.get('Producto_promocion_id'));
               // product2Ids.add((String)data.get('Producto_base_id'));


            }

            String nombreList = pedidos[0].Lista_de_Precios__c;
            lstPricebook = new PriceBookEntriesSelector().selectByPriceBookNameAndProduct2Id(nombreList, product2Ids);
            
            for(Object pr : m){
                Map<String,Object> data = (Map<String,Object>)pr;

                String promocion_id = (String)data.get('Promocion_id');
                String producto_base_id = (String)data.get('Producto_base_id');
                String producto_promocion_id = (String)data.get('Producto_promocion_id');
                Integer cantidad_usada = (Integer)data.get('Cantidad_usada');
                Integer cantidad_disponible_promocion = (Integer)data.get('Cantidad_disponible_promocion');

                OrderItem oi = crearOrderItem(producto_base_id, cantidad_usada, promocion_id, cantidad_disponible_promocion, producto_promocion_id);
                
                Map<Id,OrderItem> auxMap = new Map<Id,OrderItem>();

                if(!auxMap.containsKey(oi.Id)) {
                    auxMap.put(oi.Id, oi);
                    lstOrderItem.add(oi);

                }

                System.debug(lstOrderItem);

            }

            DMLUtils.upsertRecords(lstOrderItem, false);
        }
        

        return std.view();


    }
    public OrderItem crearOrderItem(String producto_base_id, Integer cantidad_usada, String promocion_id, Integer cantidad_disponible_promocion, String producto_promocion_id){
        System.debug('producto_promocion_id ----->' + producto_promocion_id);
        OrderItem orderItem = new OrderItem();
        Boolean existe = false;
        System.debug('lstPricebook ----->' + lstPricebook.size());

        for(PricebookEntry pbe : lstPricebook){
            System.debug('Comparando -------> producto_promocion_id: '+producto_promocion_id+'pbe.product2Id: '+pbe.product2Id);
            if(producto_promocion_id == pbe.product2Id){
                //ver si lo creo o ya existe en la base
                for(OrderItem oi : lstProductosOrderItem){

                    if(promocion_id == oi.Promocion__c){
                        if(oi.product2Id == producto_promocion_id){
                            existe = true;
                            orderItem = oi;
                            break;
                        }  
                    }
                                      
                }

                if(existe){
                    System.debug('existe');
                    orderItem.Quantity = cantidad_usada;
                }else{
                    System.debug('no existe');
                    orderItem.OrderId = pedidoId;
                    orderItem.Descuento__c = 100;
                    orderItem.Quantity = cantidad_usada;
                    orderItem.UnitPrice = 0.1;
                    orderItem.PricebookEntryId = pbe.Id;
                    orderItem.Cantidad_Disponible_Promocion__c = cantidad_disponible_promocion;

                    orderItem.Product2Id = producto_promocion_id;
                    orderItem.Promocion__c = promocion_id;
                }
            }
        }

        return orderItem;
    }
    
    public List<Promocion__c> getProductosPromocion(){ //obtiene las promociones de la lista de productos del pedido seleccionado
		
        System.debug('lstIdProductosPedido'+lstIdProductosPedido);
        System.debug('pedidos.get(0).EffectiveDate'+pedidos.get(0).EffectiveDate);
        System.debug('Este valor se pasará como pbName desde el controlador: '+pedidos.get(0).Account.Lista_de_precio__r.Name);
        
        List<Promocion__c> lstPromociones = new PromocionesPedidoSelector().selectByIdWithProductoBaseCondition(lstIdProductosPedido, pedidos.get(0).EffectiveDate,pedidos.get(0).Lista_de_Precios__c,pedidos.get(0).Account.Clasificacion__c);
        
        System.debug('PROMOCIONES: '+System.JSON.serializePretty(lstPromociones));
        
        return lstPromociones;
    }
    
    public List<OrderItem> getProductosOrderItem(){ //obtiene todos los productos que han sido registrados como promocion del pedido seleccionado
			System.debug('getProductosOrderItem');
            return new OrderItemsSelector().selectByOrderIdWithDiscountCondition(pedidoId);

    }
    public List<OrderItem> getAllProductosOrderItem(){ //obtiene todos los productos base que no esten en promocion del pedido seleccionado
			System.debug('getAllProductosOrderItem');
            return new OrderItemsSelector().selectByOrderWithNotPromotionCondition(pedidoId);

    }
    public List<AggregateResult> getProductosWithProductPromotion(){ //obtiene todos los productos que han sido registrados como promocion de todos los pedidos en base a su lista de product2Id
			System.debug('getProductosWithProductPromotion');
            return new OrderItemsSelector().selectWithProductPromotionCondition(lstIdProductosPedido);

    }
    public List<Promocion__c> getProductos(){
		System.debug('getProductos');
        getIdProductosPedido();

        List<Promocion__c> lstProductosPromocionAux;

        lstProductosPromocionAux = getProductosPromocion();
        lstProductosOrderItem = getProductosOrderItem();
        lstAllProductosOrderItem = getAllProductosOrderItem();
        lstProductosWithProductPromotion = getProductosWithProductPromotion();

        /// Se guardan los productos de la Lista de Precios del Pedido
        Id idPriceBook = pedidos[0].Pricebook2Id;
        Set<String> setProductosListaPrecios = new Set<String>();
        List<PriceBook2> listPriceBook = new PriceBooksSelector().selectByIDWithPriceBookEntries(new Set<Id>{idPriceBook});
        
        if( listPriceBook.size() > 0 ) {
            for(PriceBookEntry producto: listPriceBook[0].PriceBookEntries) {

                setProductosListaPrecios.add(producto.Product2Id);
            } 
        }

        for (OrderItem oi : lstAllProductosOrderItem) {
            mapProductosItem.put(oi.Product2Id, oi.Quantity);         
       }

       for (Promocion__c promocion : lstProductosPromocionAux) {
            Integer cantidad_disponible = Math.round((mapProductosItem.get(promocion.Producto_base__c) * promocion.Cantidad_Disponible_Promocion__c) / promocion.Cantidad_Compra_Base__c);

            promocion.Cantidad_Usada_Producto_Promocion__c = 0;
            promocion.Cantidad_Disponible_Promocion__c = cantidad_disponible;

            //validar que el producto cumpla con la compra mínima para alcanzar la promoción
            /// Se agrega validacion para Productos de la Promocion que estan en la Lista de Precios del Pedido
            if(cantidad_disponible > 0 && setProductosListaPrecios.contains(promocion.Producto_promocion__c)) { 

                lstProductosPromocion.add(promocion);
            }

        }

        if(lstProductosOrderItem.size() > 0){

            for (OrderItem producto : lstProductosOrderItem) { //sacar la sumatoria de cantidad utilizada por producto registrado como promocion                                    
                        for (Promocion__c promocion : lstProductosPromocion) {
                            if(producto.product2Id == promocion.Producto_promocion__c && producto.Promocion__c == promocion.Id){
                                System.debug('promocion' + promocion.Id+ '****' + producto);
                                promocion.Cantidad_Usada_Producto_Promocion__c = producto.Quantity;
                            }

                            if(producto.product2Id == promocion.Producto_base__c && producto.Promocion__c == promocion.Id){
                                System.debug('base ' + promocion.Id+ '****' + producto);
                                promocion.Cantidad_Usada_Producto_Promocion__c = producto.Quantity;
                            }

                        
                        }
                    }
        }else{ // si es la primera vez qe se entra a registrar una promoción a ese pedido

            for (SObject sObj : lstProductosWithProductPromotion) {
                AggregateResult result = (AggregateResult) sObj;

                for (Promocion__c promocion : lstProductosPromocion) { // inicializará en 0 la cantidad utilizada de los productos de ese pedido y la sumatoria de cuantos quedan disponibles se aactualizará
                    
                    if((String)result.get('Product2Id') == promocion.Producto_base__c){
                        promocion.Cantidad_Usada_Producto_Promocion__c = 0;

                    }
                
                }
            }
        }
    
        return lstProductosPromocion;
    }
    public void getIdProductosPedido(){ //obtiene los id de los productos del pedido seleccionado (que no sean registrados como promocion)
		System.debug('getIdProductosPedido');
        Order pedido = new Order(Id = pedidoId);

        for (OrderItem producto : new OrderItemsSelector().selectByOrderWithNotPromotionCondition(pedido.Id)) {
            lstIdProductosPedido.add(producto.Product2Id);

        }

    }

}