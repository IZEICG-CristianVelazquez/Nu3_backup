trigger FacturaTrigger on Factura__c (before insert, after insert, before update, after update) {
    fflib_SObjectDomain.triggerHandler(Facturas.class);
}