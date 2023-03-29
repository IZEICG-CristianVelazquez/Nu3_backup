public without sharing class BatchActualizarListasPrecios implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
	    
    public Database.QueryLocator start(Database.BatchableContext BC) {
	
        return new PricebooksSelector().selectListaPreciosSap();
    
    }
    
    public void execute(Database.BatchableContext BC, List<PriceBook2> scope) {
        
       for (PriceBook2 pb : scope) {

			SchedulerActualizarListaDePrecios.processScheduler(String.valueOf(pb.Lista_de_precios_SAP__c), pb.Base_de_Datos__c, pb.Id);            
            
        }
        

    }
   
    public void finish(Database.BatchableContext BC) {

    }

}