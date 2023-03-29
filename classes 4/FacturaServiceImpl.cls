public inherited sharing class FacturaServiceImpl implements IFacturaService {
    private static Boolean hasNullValues = false;
    private static Decimal rate;
    private static String errorMsgs = '';

    public void syncInvoicesSap() {

        try{
            fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();
            FacturasJSON resultMSFacturas = getInvoicesSap();
    
            
            if( resultMSFacturas != null ) {
    
                SourceData sourceData = generateDataToUpsert(resultMSFacturas.pedidos);
                Set<String> alreadyPassed = new Set<String>();
                
                /// Se Inserten y Actualizan las Facturas con sus Productos
                for(FacturasJSON.Pedido fact: resultMSFacturas.pedidos) {
    
                    if(!alreadyPassed.contains(Facturas.generateFacturaKey(fact.IdFacSap, fact.BusUnit)  )){
                        if( !sourceData.mapCurrentFacturas.containsKey( Facturas.generateFacturaKey(fact.IdFacSap, fact.BusUnit) ) ) {
                            /// Facturas Nuevas
                            List<Producto_de_Factura__c> productosDefactura = new List<Producto_de_Factura__c>();
        
                            for(FacturasJSON.Producto producto : fact.Productos) {
                                Producto_de_Factura__c newProd = assignInvoiceProduct(producto,sourceData, String.valueof(fact.BusUnit));
        
                                if (hasNullValues){
                                    break;
                                }
        
                                productosDefactura.add(newProd);
                            }
        
                            Factura__c factura = assignInvoice(fact,sourceData,uow);
        
                            if (hasNullValues){
                                break;
                            }
        
                            uow.registerNew(factura);
        
                            for(Producto_de_Factura__c product : productosDefactura){
                                product.OwnerId = factura.OwnerId;
                                product.Vendedor__c = factura.Vendedor__c;
                                product.ID_de_Agente__c = factura.ID_de_Agente__c;
                                uow.registerNew(product, Producto_de_Factura__c.Factura__c, factura);
                            }
        
                        } else {
        
                            /// Facturas Existentes
                            Factura__c currentFact = sourceData.mapCurrentFacturas.get( Facturas.generateFacturaKey(fact.IdFacSap, fact.BusUnit) );

                            if(sourceData.mapOrders.containsKey(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase())){
                                Order ordToFacturar = sourceData.mapOrders.get(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase()) ;
                                if(ordToFacturar.Status != 'Facturad'){
                                    ordToFacturar.Status = 'Facturado';
                                    uow.registerDirty(ordToFacturar);
                                }
                            }    

                            /// Actualizacion de Facturas Canceladas
                            if( (fact.Cancelada == Constants.FACT_CANCELADA) && (!currentFact.Cancelada__c) ) {
        
                                currentFact.Cancelada__c = true;
                            }
        
                            /// Actualizacion de Estatus de Facturas 
                            if( String.isNotBlank(fact.Estatus) 
                                && Constants.MAP_ESTATUS_FACTURA.containsKey(fact.Estatus) 
                                && currentFact.Estatus_de_Factura__c != Constants.MAP_ESTATUS_FACTURA.get(fact.Estatus) ) {
        
                                currentFact.Estatus_de_Factura__c = Constants.MAP_ESTATUS_FACTURA.get(fact.Estatus);
        
                            }
        
                            uow.registerDirty(currentFact);
                        }
                        
                        alreadyPassed.add(Facturas.generateFacturaKey(fact.IdFacSap, fact.BusUnit));
                    }
                }

    
                if(hasNullValues){
                    uow = Application.UnitOfWork.newInstance();
                    uow.registerNew(
                        new Error_Log__c(
                            Integration__c = true,
                            Message__c = errorMsgs
                        )
                    );
                }
                    
                uow.commitWork();
                
            }
        } catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

    }

    private FacturasJSON getInvoicesSap(){
        Map<String, String> mapHours = getIntervalInHours();
        /* Map<String, String> mapHours = new Map<String,String>{
            'startTime' => String.valueOf(startTime),
            'endTime' => String.valueOf(endtime)
        }; */

        /// Cliente SAP
        ClienteSap client = new ClienteSap();
        client.setMethod('GET');
        client.setEndpoint( '/facturas/' + '?horainicial=' + mapHours.get('startTime') + '&horafinal=' + mapHours.get('endTime') );
        
        HttpRequest req = client.crearRequest(null);
        HttpResponse res = client.enviarRequest(req);

        return FacturasJSON.parse(res.getBody().replace('"Currency":', '"Currency_z":'));
    }

    private Map<String, String> getIntervalInHours() {

        Map<String, String> mapResult = new Map<String, String>();

        ////////// 
        Cadena_MS__mdt cmHours = [SELECT Cadena__c FROM Cadena_MS__mdt WHERE DeveloperName = 'MSFacturasTiempoHoras' LIMIT 1];
        Integer intCMHours = Integer.valueOf(cmHours.Cadena__c);
        //////////

        Datetime dtNow = Datetime.now();
        Integer dtHour = dtNow.hour();
        Integer dtMinute = dtNow.minute();

        Integer intInitialHour = dtHour - intCMHours;
        Integer intInitialMinute = intInitialHour < 0 ? 0 : dtMinute;
        intInitialHour = intInitialHour < 0 ? 0 : intInitialHour;

        String startTime = String.valueOf(intInitialHour) + String.valueOf(intInitialMinute) + '00';
        String endTime = String.valueOf(dtHour) + String.valueOf(dtMinute) + '00';

        startTime = startTime.equals('240000') ? '235960' : startTime;
        endTime = endTime.equals('240000') ? '235960' : endTime;        
        system.debug(startTime + '  ' + endTime);

        mapResult.put('startTime', startTime);
        mapResult.put('endTime', endTime);

        return mapResult;
    }

    private SourceData generateDataToUpsert(List<FacturasJSON.Pedido> facturasList){
        SourceData sourceData = new SourceData();

        for(FacturasJSON.Pedido factura : facturasList){

            if( String.isNotBlank(factura.busUnit) && String.isNotBlank(factura.cardCode) ) {

                sourceData.lstIdsAccounts.add( Accounts.generateAccountKey(factura.BusUnit, factura.CardCode) );
            }                

            if( factura.SlpCode != null ) {

                sourceData.lstIdsAgentes.add( String.valueOf(factura.SlpCode) );
            }

            if( factura.IdFacSap != null && String.isNotBlank(factura.busUnit) ) {

                sourceData.lstIdsFacturas.add( Facturas.generateFacturaKey(factura.IdFacSap, factura.BusUnit) );
            }

            for(FacturasJSON.Producto productoFactura : factura.Productos) {

                if( productoFactura.IdSap != null && factura.BusUnit != null ) {

                    sourceData.lstIdsOrders.add(productoFactura.IdSap.toUpperCase() + factura.BusUnit.toUpperCase());
                }

                if( String.isNotBlank(productoFactura.ItemCode) ) {

                    sourceData.lstIdsProducts.add(productoFactura.ItemCode);
                }
            }
        }

        sourceData = assembleSourceMaps(sourceData);

        return sourceData;
    }

    private SourceData assembleSourceMaps(SourceData sourceData){

        System.debug('accounts: '+sourceData.lstIdsAccounts);

        for(Account acc : AccountsSelector.newInstance()
                            .selectByExternalId( sourceData.lstIdsAccounts, 15000) ) {
            sourceData.mapAccounts.put(acc.Clave_cliente__c.toUpperCase(), acc);
        }

        for(Agente__c agent : AgentesSelector.newInstance()
                                .selectByIdDeAgente( sourceData.lstIdsAgentes )) {
            sourceData.mapAgentes.put(agent.ID_Base_de_Datos__c, agent);
        }

        for(Order ord: OrdersSelector.newInstance()
                        .selectByExternalId( sourceData.lstIdsOrders )) {

            sourceData.mapOrders.put(ord.ID_Externo__c, ord);
        }

        for(Product2 prod: ProductsSelector.newInstance()
                            .selectByProductCode( sourceData.lstIdsProducts, 15000)) {

            sourceData.mapProdcuts.put(String.valueOf(prod.ProductCode).toUpperCase(), prod);
        }

        for(Factura__c fact: FacturasSelector.newInstance()
                                .selectByIdExterno( sourceData.lstIdsFacturas )) {

            sourceData.mapCurrentFacturas.put(fact.ID_Externo__c, fact);
        }

        return sourceData;
    }

    private Factura__c assignInvoice(FacturasJSON.Pedido fact, SourceData sourceData, fflib_ISObjectUnitOfWork uow){


        Map<String, Account> mapAccounts = sourceData.mapAccounts;
        Map<String, Agente__c> mapAgentes = sourceData.mapAgentes;
        Map<String, Order> mapOrders = sourceData.mapOrders;
        Map<String, Factura__c> mapCurrentFacturas = sourceData.mapCurrentFacturas;
        Map<String, Product2> mapProdcuts = sourceData.mapProdcuts;

        String agenteKey = String.isNotBlank(String.valueOf(fact.SlpCode)) && String.isNotBlank(String.valueOf(fact.BusUnit)) ?
                                String.valueOf(fact.SlpCode).toUpperCase() + fact.BusUnit.toUpperCase() : null;

        System.debug('FacturaServiceImpl assignInvoice agenteKey: '+agenteKey);

        Factura__c invoiceToReturn = new Factura__c();
        Account acc = mapAccounts.containsKey( Accounts.generateAccountKey(fact.BusUnit, fact.CardCode) ) ? mapAccounts.get( Accounts.generateAccountKey(fact.BusUnit, fact.CardCode) ) : null;

        if (acc != null){
            invoiceToReturn.ID_Externo__c = Facturas.generateFacturaKey(fact.IdFacSap, fact.BusUnit);

            invoiceToReturn.RecordTypeId          = Constants.FACT_RT_FACTURA_ID;
            invoiceToReturn.Centro_de_Costo__c    = fact.U_VentaDelCU;
            invoiceToReturn.Flete__c              = fact.U_Flete;
            invoiceToReturn.ID_SAP_Cuenta__c      = fact.CardCode;
            invoiceToReturn.N_mero_de_Factura__c  = fact.NumFactura;
            invoiceToReturn.Base_de_Datos__c      = fact.BusUnit;
            invoiceToReturn.Tipo_de_Documento__c  = fact.DocType;
            invoiceToReturn.C_digo_de_Cliente__c  = fact.CardCode;
            invoiceToReturn.Empresa_Financiera__c = fact.U_EmpresaFinanciera;
            invoiceToReturn.Proyecto__c           = fact.Project;
            invoiceToReturn.Tipo_de_Pago__c       = fact.U_metodoDePagoCFD;
            invoiceToReturn.Tipo_de_Moneda__c     = 'MXP';
            
           /*  invoiceToReturn.Descuento__c           = getDecimalval(fact.DiscPrcnt, rate); */ /// SAP Regresa NULL Validar Formato y Tipo
            invoiceToReturn.Flete_Facturado__c     = getDecimalval(fact.Flete, rate);
            invoiceToReturn.Impuesto_Total__c      = getDecimalVal(fact.VatSum, rate);
            invoiceToReturn.Total_del_Documento__c = getDecimalVal(fact.DocTotal, rate);
            invoiceToReturn.Monto_Pagado__c        = getDecimalVal(fact.PaidToDate, rate);
            invoiceToReturn.Gross_Profit__c        = getDecimalVal(fact.GrosProfit, rate);
            invoiceToReturn.Tarifa__c              = getDecimalVal(fact.U_Tarifa, rate);
            invoiceToReturn.Tarifa_Camioneta__c    = getDecimalVal(fact.U_TarCam, rate);
    
            invoiceToReturn.Tipo_de_Cambio__c      = getDecimalVal(fact.U_TipoDeCambio, null);
    
            invoiceToReturn.Tipo_de_Unidad__c     = String.isNotBlank(fact.U_Tipo)    && Constants.MAP_TIPO_UNIDAD.containsKey(fact.U_Tipo)      ? Constants.MAP_TIPO_UNIDAD.get(fact.U_Tipo)      :          null; 
            invoiceToReturn.Estatus_de_Factura__c = String.isNotBlank(fact.Estatus)   && Constants.MAP_ESTATUS_FACTURA.containsKey(fact.Estatus) ? Constants.MAP_ESTATUS_FACTURA.get(fact.Estatus) :          null;
            invoiceToReturn.Cancelada__c          = String.isNotBlank(fact.Cancelada) && fact.Cancelada == Constants.FACT_CANCELADA              ? true                                            :         false;
            invoiceToReturn.Comentarios__c        = String.isNotBlank(fact.Comments)  && fact.Comments.length() > 250                            ? fact.Comments.substring(0, 249)                 : fact.Comments;
    
            invoiceToReturn.Serie_del_documento__c = fact.Series != null   ? String.valueof(fact.Series)   : null;
            invoiceToReturn.Factura__c             = fact.IdFacSap != null ? String.valueof(fact.IdFacSap) : null;
    
            invoiceToReturn.Fecha_Vencimiento_Factura__c         = getDate(fact.DocDueDate) ; 
            invoiceToReturn.Fecha_de_Facturaci_n__c              = getDate(fact.DocDate)    ;
            invoiceToReturn.ltima_Fecha_de_Facturaci_n_en_SAP__c = getDate(fact.UpdateDate) ;
    
            System.debug('account: '+acc);
            System.debug('mapAgentes.get(agenteKey): '+mapAgentes.get(agenteKey));
    
            invoiceToReturn.Vendedor__c     = mapAgentes.containsKey(agenteKey) && mapAgentes.get(agenteKey) != null ? mapAgentes.get(agenteKey).Vendedor__c     : acc.OwnerId;
             
            if(mapAgentes.containsKey(agenteKey)){
                System.debug('agente: '+mapAgentes.get(agenteKey).Id);
                invoiceToReturn.OwnerId = mapAgentes.get(agenteKey).Vendedor__c;
                invoiceToReturn.Canal_2__c = mapAgentes.get(agenteKey).Canal__c;
                invoiceToReturn.ID_de_Agente__c = mapAgentes.get(agenteKey).ID_de_Agente__c;
            } else{
                invoiceToReturn.OwnerId = acc.OwnerId;
            }
    
            invoiceToReturn.Vendedor__c = invoiceToReturn.OwnerId;
            
            System.debug('FacturaServiceImpl assignInvoice accountMap: '+mapAccounts);
            System.debug('FacturaServiceImpl assignInvoice accountMap Key: '+Accounts.generateAccountKey(fact.BusUnit, fact.CardCode));
            
            invoiceToReturn.Nombre_de_la_Cuenta__c  = mapAccounts.containsKey( Accounts.generateAccountKey(fact.BusUnit, fact.CardCode) ) ? mapAccounts.get( Accounts.generateAccountKey(fact.BusUnit, fact.CardCode) ).Id : null;
            invoiceToReturn.Pedido__c               = mapOrders.containsKey(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase())         ? mapOrders.get(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase()).Id         : null;

            /* invoiceToReturn.Hora_Vencimiento_Factura__c = fact.CreateTS != null ? 
                                                           String.valueOf(fact.CreateTS).length() == 5 ? 
                                                               Time.newInstance( Integer.valueOf(String.valueOf(fact.CreateTS).substring(0, 1)), Integer.valueOf(String.valueOf(fact.CreateTS).substring(1, 3)),Integer.valueOf(String.valueOf(fact.CreateTS).substring(3, 5)), 0) 
                                                               : String.valueOf(fact.CreateTS).length() == 6 ? 
                                                                       Time.newInstance( Integer.valueOf(String.valueOf(fact.CreateTS).substring(0, 2)), Integer.valueOf(String.valueOf(fact.CreateTS).substring(2, 4)),Integer.valueOf(String.valueOf(fact.CreateTS).substring(4, 6)), 0)
                                                                       : null
                                                           : null; */
            
            if(mapOrders.containsKey(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase())){
                Order ordToFacturar = mapOrders.get(fact.Productos[0].IdSAP + fact.BusUnit.toUpperCase()) ;
                ordToFacturar.Status = 'Facturado';
                uow.registerDirty(ordToFacturar);
            }                  
            //invoiceToReturn.Total_de_gastos_adicionales_flete__c = fact.TotalExpns; /// SAP NO regresa el campo 
            ///invoiceToReturn.Fecha_Vencimiento_Factura_Hora__c = null; /// Falta el campo de SAP
            if(fact.CreateTS != null && String.isNotBlank(fact.DocDate)){

                String timeTS = String.valueOf(fact.CreateTS);
                if(timeTS.length() != 6){
                    while(timeTS.length() != 6){
                        timeTS = '0' + timeTS;
                    }
                }

                System.debug('timeTs: '+timeTS);
                String hour = timeTS.substring(0,2);
                String minute = timeTS.substring(2,4);
                String second = timeTS.substring(4,6);
                String completeTime = hour +':' + minute + ':' + second;

                String fechaCorta = fact.DocDate.replace('/', '-');
                List<String> fechaArray = fechaCorta.split('-');

                String fechaCompleta = fechaArray[0]+'-'+fechaArray[1]+'-'+fechaArray[2]+' '+completeTime;

                invoiceToReturn.Fecha_de_Facturaci_n_Hora__c = Datetime.valueOf(fechaCompleta);

                invoiceToReturn.Hora_Vencimiento_Factura__c = Time.newInstance( Integer.valueOf(timeTS.substring(0, 2)), Integer.valueOf(timeTS.substring(2, 4)),Integer.valueOf(timeTS.substring(4, 6)), 0);

            }
        }

        if( invoiceToReturn.Nombre_de_la_Cuenta__c == null){
            System.debug('invoiceToReturn.Nombre_de_la_Cuenta__c: '+invoiceToReturn.Nombre_de_la_Cuenta__c+' llave: '+Accounts.generateAccountKey(fact.BusUnit, fact.CardCode) );
            errorMsgs += '\n Error Integración facturas: Cuenta no encontrada: '+ Accounts.generateAccountKey(fact.BusUnit, fact.CardCode);
            hasNullValues = true;
        }
        
        return invoiceToReturn;
    }

    private Producto_de_Factura__c assignInvoiceProduct(FacturasJSON.Producto producto,SourceData sourceData, String busUnit){

        Map<String, Account> mapAccounts = sourceData.mapAccounts;
        Map<String, Agente__c> mapAgentes = sourceData.mapAgentes;
        Map<String, Order> mapOrders = sourceData.mapOrders;
        Map<String, Factura__c> mapCurrentFacturas = sourceData.mapCurrentFacturas;
        Map<String, Product2> mapProdcuts = sourceData.mapProdcuts;

        String agenteKey = String.isNotBlank(String.valueOf(producto.SlpCode)) && String.isNotBlank(busUnit) ?
                                String.valueOf(producto.SlpCode).toUpperCase() + busUnit.toUpperCase() : null;

        Producto_de_Factura__c newProd = new Producto_de_Factura__c();

        newProd.Id_SAP_Pedido__c      = producto.IdSAP;
        newProd.Entrega__c            = producto.Entrega;
        newProd.C_digo_de_IVA__c      = producto.TaxCode;
        newProd.Currency__c           = 'MXP';
        newProd.Line_Number__c        = producto.LineNum;
        newProd.C_digo_de_Producto__c = producto.ItemCode.toUpperCase();



        newProd.ID_de_Agente__c = mapAgentes.containsKey(agenteKey) ? mapAgentes.get(agenteKey).ID_de_Agente__c: null;
        System.debug('Producto ItemCode: '+producto.ItemCode);
        System.debug('Producto mapa: '+mapProdcuts);

        newProd.Producto__c     = mapProdcuts.containsKey(producto.ItemCode.toUpperCase()) ? mapProdcuts.get(producto.ItemCode.toUpperCase()).Id: null;
        /* newProd.Vendedor__c     = mapAgentes.containsKey(agenteKey) ? mapAgentes.get(agenteKey).Vendedor__c: null; */
        newProd.Rate__c = producto.Rate!= null && producto.Rate > 0 ? producto.rate : 1; 

        /* if(String.isNotBlank(producto.Moneda) && String.valueOf(producto.Moneda )== 'USD' && producto.Rate != null){
            rate = producto.rate;
            newProd.Rate__c = rate;
        } else {
            rate = null;
        } */

        newProd.IVA__c                  = getDecimalVal(producto.VatSum, rate)    ;
        newProd.Precio_de_Lista__c      = getDecimalVal(producto.Price, rate)     ;
        newProd.Gross_Profit__c         = getDecimalVal(producto.GrssProfit, rate);
        newProd.Total_de_la_l_nea__c    = getDecimalVal(producto.LineTotal, rate) ;

        newProd.Kg__c                   = getDecimalVal(producto.Kilos, null)     ;

        ///newProd.Proyecto__c = producto.Project; // SAP manda NULL
        newProd.Cantidad__c = getDecimalVal(producto.Factor1, null); // SAP no manda el campo
        ///newProd.Total_de_impuesto_por_l_nea__c = producto.LineTotalVat; // SAP no manda el campo

        if( newProd.Producto__c == null /* || newProd.Vendedor__c == null */){

            System.debug('Producto: '+newProd.Producto__c + ' llave: '+producto.ItemCode);
            errorMsgs += String.isNotBlank(producto.ItemCode) ? '\n Error Integración Facturas - Producto no encontrado: '+ producto.ItemCode : '\n Error Integración Facturas: El código del producto de la integración viene nulo' ;
            hasNullValues = true;
        }

        return newProd;
    }

    private Decimal getDecimalVal(String strVal, Decimal rate){
        Decimal val;
        if(String.isNotBlank(strVal)){
            val = rate != null ? Decimal.valueOf(strVal.replace(',', '')) * rate : Decimal.valueOf(strVal.replace(',', ''));
        }

        return val;
    }

    private static Date getDate(String fecha){

        if(String.isNotBlank(fecha)){
            fecha = fecha.replace('/', '-');
            
            List<String> fechaArray = fecha.split('-');
            String fechaCompleta = fechaArray[0]+'-'+fechaArray[1]+'-'+fechaArray[2];

            return date.valueOf(fechaCompleta);

        }

        return null;
        

    }

    private class SourceData{
        /// Cuentas
        public Set<String> lstIdsAccounts = new Set<String>();
        public Map<String, Account> mapAccounts = new Map<String, Account>();

        /// Agentes
        public Set<String> lstIdsAgentes = new Set<String>();
        public Map<String, Agente__c> mapAgentes = new Map<String, Agente__c>();

        /// Pedidos
        public Set<String> lstIdsOrders = new Set<String>();
        public Map<String, Order> mapOrders = new Map<String, Order>();

        /// Facturas
        public Set<String> lstIdsFacturas = new Set<String>();
        public Map<String, Factura__c> mapCurrentFacturas = new Map<String, Factura__c>();

        /// Productos
        public Set<String> lstIdsProducts = new Set<String>();
        public Map<String, Product2> mapProdcuts = new Map<String, Product2>();
    }
}