public class ScheduleObtenerProductos implements Schedulable, Database.AllowsCallouts {

    private static Map<String, Product2> mapProductosPorCodigo;

    private static void init (ProductosJSON res) {

        Set<String> setCodes = new Set<String>();

        for (ProductosJSON.Articulo articulo : res.Articulos) {

            setCodes.add(articulo.ItemCode);

        }

        cargarProductosSF(setCodes);

    }

    private static void cargarProductosSF (Set<String> setCodes) {

        mapProductosPorCodigo = new Map<String, Product2>();
        
        for (Product2 producto : new ProductsSelector().selectByProductCode(setCodes, 50000)) {

            mapProductosPorCodigo.put(producto.ProductCode, producto);

        }

    }

    public void execute (SchedulableContext sc) {

       processScheduler();
    }

    @future(callout=true) 
    private static void processScheduler () {

        try{
            MSObtenerProductos servicio = new MSObtenerProductos();
            ProductosJSON res = servicio.obtenerProductos();
            
            List<Pricebook2> stdPbk = [select Id, Name, IsActive from PriceBook2 where IsStandard=True LIMIT 1];
            System.debug(res.Articulos);
            if (res.Articulos != null) {
    
                init(res);
    
                Map<Id, Product2> mapUpdateProductos = new Map<Id, Product2>();
                List<Product2> lstInsertProductos = new List<Product2>();
                List<PricebookEntry> lstInsertPBEntries = new List<PricebookEntry>();
                Set<String> alreadyPassed = new Set<String>();
                for (ProductosJSON.Articulo articulo : res.Articulos) {
                    
                    /* 
                        Mapeo de campos
    
                        ItemName	PRODUCTO	Name	
                        ItemCode	PRODUCTO	ProductCode	
                        SalUnitMsr	PRODUCTO	QuantityUnitOfMeasure	
                        U_IvaVenta	PRODUCTO	Codigo_Impuesto__c	
                        SalFactor2	PRODUCTO	Kilogramos_unidad__c	
                    */
    
    
                    // Producto existente si contiene  la llave
                    if(!alreadyPassed.contains(articulo.ItemCode)){

                        Product2 producto2 = mapProductosPorCodigo.containsKey(articulo.ItemCode) ? mapProductosPorCodigo.get(articulo.ItemCode) : new Product2();
                        producto2.QuantityUnitOfMeasure          = articulo.SalUnitMsr;
                        producto2.Codigo_Impuesto__c             = articulo.U_IvaVenta;
                        producto2.Kilogramos_unidad__c           = articulo.SalFactor2;
                        producto2.Name                           = articulo.ItemName;
                        producto2.Grupo_de_art_culos__c          = String.valueOf(articulo.ItmsGrpCod);
                        producto2.Nombre_de_grupo_de_art_culo__c = articulo.ItmsGrpNam;

                        producto2.Categor_a__c                  = String.isNotBlank(articulo.U_SF_CATEGORIA)      ? articulo.U_SF_CATEGORIA      : null;
                        producto2.Clasificaci_n_de_productos__c = String.isNotBlank(articulo.U_SF_CLASIFICACION)  ? articulo.U_SF_CLASIFICACION  : null;
                        producto2.Family                        = String.isNotBlank(articulo.U_SF_FAMILIA)        ? articulo.U_SF_FAMILIA        : null;
                        producto2.L_nea_de_Producto__c          = String.isNotBlank(articulo.U_SF_LINEA_PRODUCTO) ? articulo.U_SF_LINEA_PRODUCTO : null;
                        producto2.Unidad_de_medida__c           = String.isNotBlank(articulo.U_SF_UNIDAD_MEDIDA)  ? articulo.U_SF_UNIDAD_MEDIDA  : null;
                        producto2.Unidad_de_Negocio__c          = String.isNotBlank(articulo.U_SF_UNIDAD_NEGOCIO) ? articulo.U_SF_UNIDAD_NEGOCIO : null;
                        String busUnit = articulo.BusUnit.toUpperCase();
                        
                        producto2.Grupo_Articulos_M2001__c = busUnit == 'NU3' ? articulo.ItmsGrpNam : producto2.Grupo_Articulos_M2001__c;
                        producto2.Grupo_Art_culos_Lagos__c = busUnit == 'NU3_AGROPECUARIAPIEDADENSE_LAGOS' ? articulo.ItmsGrpNam : producto2.Grupo_Art_culos_Lagos__c;
                        producto2.Grupo_de_art_culos_veracruz__c = busUnit == 'NU3_CABNUTRES_VERACRUZ' ? articulo.ItmsGrpNam : producto2.Grupo_de_art_culos_veracruz__c;



                        if (mapProductosPorCodigo.containsKey(articulo.ItemCode)) {   

                            mapUpdateProductos.put( mapProductosPorCodigo.get(articulo.ItemCode).Id, producto2);

                        } else {
                            producto2.ProductCode = articulo.ItemCode;
                            producto2.IsActive = true;
                            lstInsertProductos.add(producto2);    
    
                        }
                        alreadyPassed.add(articulo.ItemCode);
                    }
    
                }
    
                DMLUtils.insertIntegrationRecords(lstInsertProductos, false);
                DMLUtils.updateIntegrationRecords(mapUpdateProductos.values(), false);
        
                Id idPriceBook = (!Test.isRunningTest()) ? stdPbk.get(0).Id : Test.getStandardPricebookId();
                for ( Product2 product : lstInsertProductos ) {
    
                    if ( String.isNotBlank(product.Id) ) {
    
                        lstInsertPBEntries.add(new PricebookEntry(IsActive = true, Pricebook2Id = idPriceBook, 
                                                                    Product2Id = product.Id, UnitPrice = 1 ));
    
                    }   
    
                }
    
                DMLUtils.insertIntegrationRecords(lstInsertPBEntries, false);
    
            }
        } catch(Exception e){
            System.debug(e.getMessage());
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

        
    }

}