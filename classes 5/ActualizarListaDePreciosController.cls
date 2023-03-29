public with sharing class ActualizarListaDePreciosController {

    @AuraEnabled
    public static void actualizarLista (String listaId) {

        List<PriceBook2> lstPriceBooks = new PriceBooksSelector().selectById(new Set<Id>{listaId});

        if ( !lstPriceBooks.isEmpty() ) {

            SchedulerActualizarListaDePrecios.processScheduler(String.valueOf(lstPriceBooks.get(0).Lista_de_precios_SAP__c), 
                                                                lstPriceBooks.get(0).Base_de_Datos__c, 
                                                                lstPriceBooks.get(0).Id);

        } 
    }

}