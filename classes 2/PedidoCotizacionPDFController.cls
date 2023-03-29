public with sharing class PedidoCotizacionPDFController {

    public List<OrderItem> productos {get;set;}

    public PedidoCotizacionPDFController(ApexPages.StandardController stdController){

        Order pedido = (Order) stdController.getRecord();

        productos = [SELECT Id,ListPrice,UnitPrice,Quantity,Kilogramos__c,Descuento__c,Precio_kg__c,
                    Descuento_por_l_nea__c,Product2Id,Unidad_de_Medida__c,Precio_total_con_flete__c,
                    PricebookEntry.ProductCode, PricebookEntry.Name
                    FROM OrderItem WHERE OrderId = :pedido.Id];
                    

    }

}