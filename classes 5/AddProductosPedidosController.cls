public with sharing class AddProductosPedidosController {

    private List<Order> pedidos;
    private ApexPages.StandardController std;
    List<PricebookEntry> lstPricebook {get;set;}
    public List<ProductosOrderItem> lstProductos {get;set;}
    public String lstSelectProductos{get;set;}
    public Boolean hasLstPrecios { get; set; }
    public Boolean isSelected {get; set; }
    public string selectedValue {get;set;}
    private String pedidoId;
    private String listaPrecios;
    Map<Id,Pricebook2> mapLstPrecios;

    public class CustomDMLUtilsException extends Exception{}

    public AddProductosPedidosController(ApexPages.StandardController sc){


        Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
        System.debug('nombre de perfil ' + p.Name);
        pedidoId = sc.getId();
        std = sc;
        pedidos = new OrdersSelector().selectById(new Set<Id>{pedidoId});
        mapLstPrecios = new Map<Id,Pricebook2>([SELECT Id, Name 
                                                FROM Pricebook2 
                                        WHERE IsActive = true AND Acceso_Perfiles__c includes(:p.Name)]);

        lstPricebook = new List<PricebookEntry>();
        lstProductos = new List<ProductosOrderItem>();
        lstSelectProductos = '';
        isSelected = false;

        System.debug(pedidos);

        if(!pedidos.isEmpty()){

            if(String.isBlank(pedidos[0].Lista_de_Precios__c)){

            hasLstPrecios = false;

            }else{

                hasLstPrecios = true;

            }

        }
        
    }

    public Pagereference cancelAction () {
        return std.view();
    }

    public SelectOption[] getselectValues() {     
         SelectOption[] options = new SelectOption[]{};
         options.add(new SelectOption('','Seleccione'));
         for(Pricebook2 oneRelationship : mapLstPrecios.values()) {
             options.add(new SelectOption(
                 String.valueOf(oneRelationship.Id),oneRelationship.Name));                 
         } 
         return options;           
    }

    public List<PricebookEntry> getProductos(){

        System.debug('Get Productos');
        System.debug(pedidos[0].Lista_de_Precios__c);
        System.debug(hasLstPrecios);
        System.debug(selectedValue);

        String nombreList = '';
        String category = 'Promoción';

        if(String.isBlank(pedidos[0].Lista_de_Precios__c)){

            nombreList = mapLstPrecios.get(selectedValue).Name;

        }else{

            nombreList = pedidos[0].Lista_de_Precios__c;

        }

        lstPricebook = new PriceBookEntriesSelector().selectByPBNameAndCategoryWithCustomFields(nombreList,category);

        return lstPricebook;

    }

    public void loadSelectedProducts(){

        System.debug('Load Selected Products');
        System.debug('Items' + lstSelectProductos);
       if(String.isNotBlank(lstSelectProductos)){
            List<Object> m = (List<Object>) JSON.deserializeUntyped(lstSelectProductos);
            Map<String,Integer> mapCantidad = new Map<String,Integer>();
            Set<Id> setProdIds = new Set<Id>();

            lstProductos.clear();
            mapCantidad.clear();
            setProdIds.clear();

            for(Object pr : m){
               
                Map<String,Object> data = (Map<String,Object>)pr;

                if(String.isNotBlank((String)data.get('cantidad'))){

                    setProdIds.add((String)data.get('Id'));
                    mapCantidad.put((String)data.get('Id'),Integer.valueOf((String)data.get('cantidad')));

                }

            }

            for(PricebookEntry pbe : new PriceBookEntriesSelector().selectByIdWithCustomFields(setProdIds)){

                Integer cantidad = mapCantidad.get(pbe.Id);
                lstProductos.add(new ProductosOrderItem(pbe.Id, pbe.Name, pbe.ProductCode,pbe.UnitPrice,cantidad));
            
            }

        }

    }

    public Pagereference saveProducts () {

        System.debug('Save Products');

        List<OrderItem> lstOrderItem = new List<OrderItem>();

        try {

            for (ProductosOrderItem oi : lstProductos) {

                OrderItem orderItem = new OrderItem();
                orderItem.OrderId = pedidoId;
                orderItem.Quantity = oi.quantity;
                orderItem.UnitPrice = oi.unitPrice;
                orderItem.PricebookEntryId = oi.productId;

                lstOrderItem.add(orderItem);

            }

            if(!pedidos.isEmpty()){

                if(String.isBlank(pedidos[0].Pricebook2Id)){

                    pedidos[0].Pricebook2Id = mapLstPrecios.get(selectedValue).Id;

                    DMLUtils.updateRecords(pedidos, false);

                }

            }
            
            /// Se Ejecuta el Upsert desde el controlador para cachar los Errores
            List<Database.UpsertResult> upsertResults = Database.upsert(lstOrderItem, false);

            for (Database.UpsertResult sr : upsertResults) {

                if (!sr.isSuccess()) {

                    throw new CustomDMLUtilsException('');
                }
            }            

        } catch (CustomDMLUtilsException ex) {

            ApexPages.addMessages(ex);
            return null;
        } catch (Exception e) {

            ApexPages.addMessages(e);
            return null;
        }

        return std.view();

    }

    public void next(){

        System.debug('Si entra');
        System.debug(hasLstPrecios);
        hasLstPrecios = true;

    }

    public void addSelectedProductos(){

        isSelected = true;
        loadSelectedProducts();

    }

}