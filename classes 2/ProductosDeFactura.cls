public inherited sharing class ProductosDeFactura extends fflib_SObjectDomain implements IProductosDeFactura {

    public static IProductosDeFactura newInstance(List<Producto_de_Factura__c> recordList) {
		return (IProductosDeFactura) Application.Domain.newInstance(recordList);
	}
	
	public static IProductosDeFactura newInstance(Set<Id> recordIdSet) {
		return (IProductosDeFactura) Application.Domain.newInstance(recordIdSet);
	}

    public ProductosDeFactura(List<Producto_de_Factura__c> sObjectList){
       super(sObjectList);
    }
  
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> records){
            return new ProductosDeFactura(records);
        }
    }



}