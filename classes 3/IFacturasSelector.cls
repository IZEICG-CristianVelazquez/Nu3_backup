public interface IFacturasSelector extends fflib_ISObjectSelector {

    List<Factura__c> selectById(Set<Id> setIds);
    List<Factura__c> selectByIdExterno(Set<String> setIds);
    List<Factura__c> selectByExternalIdWithProducts(Set<String> setIds);
}