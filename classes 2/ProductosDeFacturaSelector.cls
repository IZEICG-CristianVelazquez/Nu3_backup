public inherited sharing class ProductosDeFacturaSelector extends fflib_SObjectSelector implements IProductosDeFacturaSelector {

    public static IProductosDeFacturaSelector newInstance() {
		return (IProductosDeFacturaSelector) Application.Selector.newInstance(Producto_de_Factura__c.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Producto_de_Factura__c.Id
		};
	}

    public Schema.SObjectType getSObjectType() {
		return Producto_de_Factura__c.SObjectType;
	}

    public List<Producto_de_Factura__c> selectById(Set<Id> setIds) {
		return (List<Producto_de_Factura__c>) selectSObjectsById(setIds);
	}
}