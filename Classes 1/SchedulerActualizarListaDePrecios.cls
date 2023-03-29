public class SchedulerActualizarListaDePrecios implements Schedulable, Database.AllowsCallouts {


    public void execute (SchedulableContext sc) {
        

       BatchActualizarListasPrecios batch = new BatchActualizarListasPrecios();
       Database.executeBatch(batch, 1);

    }

    
    public static void processScheduler (String priceList, String busUnit, String pbId) {

        try{
            MSObtenerListasPrecios servicio = new MSObtenerListasPrecios();
            ListasPreciosJSON res = servicio.obtenerListasPrecios (priceList, busUnit);
    
            Map<String, PriceBookEntry> mapPBEItemCode = new Map<String, PriceBookEntry>(); 
    
            List<PriceBook2> pb = new PriceBooksSelector().selectByIDWithPriceBookEntries(new Set<Id>{pbId});
    
            if (!pb.IsEmpty()) {
                
                for (PriceBookEntry pbe :  pb.get(0).PriceBookEntries) {
    
                    mapPBEItemCode.put(pbe.ProductCode, pbe);
    
                }
    
            }
            
            
            if (res.Articulos != null && !mapPBEItemCode.IsEmpty()) {
    
                List<PriceBookEntry> lstUpdatePBEs = new List<PriceBookEntry>();
            
                for (ListasPreciosJSON.Articulo articulo : res.Articulos) {
                    
                    /* 
                        Mapeo de campos
    
                        Price	ENTRADA DE LISTA DE PRECIOS	UnitPrice
                        ItemCode	ENTRADA DE LISTA DE PRECIOS	ProductCode
                        Listadeprecios	LISTA DE PRECIO	Lista_de_precios_SAP__c
                        BusUnit	LISTA DE PRECIO	Base_de_Datos__c
                    */
    
                    // Producto existente si contiene  la llave
                    if ( mapPBEItemCode.containsKey(articulo.ItemCode) ) {
    
                        PriceBookEntry pbe = mapPBEItemCode.get(articulo.ItemCode);
    
                        if (articulo.Price != null && pbe.Product2.Kilogramos_unidad__c != null) {
    
                            pbe.UnitPrice = articulo.Price * pbe.Product2.Kilogramos_unidad__c;
                            lstUpdatePBEs.add(pbe);
                        
                        }
    
                    }                
    
                }
    
                DMLUtils.updateRecords(lstUpdatePBEs, false);
    
    
            }
        } catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

        
    }

}