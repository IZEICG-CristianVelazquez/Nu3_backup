public interface IProductosDeFacturaSelector extends fflib_ISObjectSelector {

    List<Producto_de_Factura__c> selectById(Set<Id> setIds);
}