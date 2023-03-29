public with sharing class SchedulerInsertarNotasCredito implements Schedulable, Database.AllowsCallouts{
    
    static Map<String, Account> mapCuentasIdExterno;
    static Set<String> codigos;
    static Set<String> idCuentas;
    static Id NCRecordTypeId;
    static Map<String, Product2> productEntriesMap;
    static Map<String,Id> agenteSellerIdByExternalId; // Added By Oscar
    static Map<String,String> agenteCanalByExternalId; // Added By Oscar
    static Map<String,String> agentesIdsByNCExternalId; // Added By oscar

    
    private static String errorMsgs = '';
    private static Boolean hasNullValues = false;
    
    private static Decimal rate;

    private static final String NOTA_CREDITO = 'Nota de Crédito';
    private final static String CANCELED = 'Y';
    private final static String PEDIDO_CANCELADO = 'Cancelado';
    
    
    static Set<String> externalIds;
    static Set<String> ncExternalIds;
    
    //private static Map<String, Order> mapOrdersByExternalID;
    private static Map<String, Factura__c> mapCreditNotesByExternalID;
    
    private static List<Factura__c> creditNotes;
    
    private static List<Factura__c> listNcOrdersByExternalID;
    
    
    private static List<Pricebook2> stdPbk;
    private static fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();
    
    
    /**
* Metodo para inicializar los mapas y variables necesarias para la ejecucion
* @param res > recibe un objeto del tipo NotasCreditoJSON para obtener las claves de las cuentas a consultar
* 
*/
    private static void init (NotasCreditoJSON res) {
        NCRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Nota de Crédito').getRecordTypeId();
        idCuentas = new Set<String>();
        codigos = new Set<String>();
        
        ncExternalIds = new Set<String>();
        externalIds = new Set<String>();

        listNcOrdersByExternalID = new List<Factura__c>();

        agentesIdsByNCExternalId = new Map<String,String>(); //Added by Oscar
        Set<String> agentesExternalIds = new Set<String>(); // Added By Oscar
        
        for(NotasCreditoJSON.Pedidos notaCredito : res.Pedidos){
            System.debug('notaCredito ' + notaCredito );
            
            String IdNcSap = String.valueOf(notaCredito.IdNcSap);
            System.debug('ncExternalIds add ' + IdNcSap + notaCredito.BusUnit.toUpperCase());

            if (String.isNotBlank(IdNcSap)) {
                String externalKey = IdNcSap + notaCredito.BusUnit.toUpperCase();
                ncExternalIds.add(externalKey);

                if(notaCredito.SlpCode != null){
                    agentesIdsByNCExternalId.put(externalKey,String.valueOf(notaCredito.SlpCode));
                    agentesExternalIds.add(String.valueOf(notaCredito.SlpCode));
                }

            }

            // Added by Oscar
            if(notaCredito.BusUnit != null && notaCredito.CardCode != null){
                idCuentas.add(Accounts.generateAccountKey(notaCredito.BusUnit, notaCredito.CardCode));
            }
            
/*             String cardcode = notaCredito.CardCode != null ? String.valueOf(notaCredito.CardCode).toUpperCase() : '';
            String busUnit = notaCredito.BusUnit != null ? String.valueOf(notaCredito.BusUnit).toUpperCase() : '';
            String slpCode = notaCredito.SlpCode != null ? String.valueOf(notaCredito.SlpCode).toUpperCase() : ''; */
            
            
            for (NotasCreditoJSON.Productos producto : notaCredito.Productos) {
                codigos.add(producto.ItemCode);   
                System.debug('codigos: '+codigos);
                String idFacSAP = producto.IdFacSap != null ? String.valueOf(producto.IdFacSap) : '';
                System.debug('externalIds add ' + IdFacSap + notaCredito.BusUnit.toUpperCase());
                
                if (String.isNotBlank(idFacSAP)) {
                    externalIds.add(idFacSAP + notaCredito.BusUnit.toUpperCase());
                }             
            }
        }
        
        //cargarOrdenesSF(externalIds);
        getAgentes(agentesExternalIds); // Added By Oscar
        cargarNcOrdenesSF(ncExternalIds);
        cargarCuentas();
        cargarProductos();
        
    }

    //Added By Oscar
    private static void getAgentes(Set<String> agentesExternalIds){
        agenteSellerIdByExternalId = new Map<String,Id>();
        agenteCanalByExternalId = new Map<String,String>();

        for(Agente__c agente : AgentesSelector.newInstance().selectByIdDeAgente(agentesExternalIds)){
            agenteSellerIdByExternalId.put(agente.ID_Base_de_Datos__c,agente.Vendedor__c);
            agenteCanalByExternalId.put(agente.ID_Base_de_Datos__c,agente.Canal__c);

        }
    }

	/*    
    private static void cargarOrdenesSF (Set<String> externalIds) {
        System.debug('externalIds ' + externalIds);
        
        mapOrdersByExternalID = new Map<String, Order>();
        
        for (Order ord : new OrdersSelector().selectByExternalId(externalIds)) {
            mapOrdersByExternalID.put(ord.ID_Externo__c, ord);
        }
        
        System.debug('mapOrdersByExternalID' + mapOrdersByExternalID);
        
    }
    */
    private static void cargarNcOrdenesSF (Set<String> ncExternalIds) {
        System.debug('ncExternalIds ' + ncExternalIds);
        
        mapCreditNotesByExternalID = new Map<String, Factura__c>();
        
        for (Factura__c fact : FacturasSelector.newInstance().selectByExternalIdWithProducts(ncExternalIds)) {
            mapCreditNotesByExternalID.put(fact.ID_Externo__c, fact);
        }
        
        System.debug('mapCreditNotesByExternalID' + mapCreditNotesByExternalID);
        
    }
    
    /**
* Carga las cuentas del sistema y las guarda en un mapa de cuentas
* su key es la clave de cliente en mayusculas
*/
    private static void cargarCuentas () {
        
        mapCuentasIdExterno = new Map<String, Account>();
        
        for (Account acct : new AccountsSelector().selectByExternalId(idCuentas, 15000)) {
            if(acct.Clave_cliente__c != null){
                mapCuentasIdExterno.put(acct.Clave_cliente__c.toUpperCase(), acct);
            }
            
        }
        
    }
    
    /**
* Carga los pricebookentrys del sistema y las guarda en un mapa de pricebook entries
* su key es el codigo  el de pricebookentry en mayusculas
*/
    private static void cargarProductos () {
        
        productEntriesMap = new Map<String, Product2>();        
        
        for (Product2 product : ProductsSelector.newInstance().selectByProductCode(codigos, 50000)) {
                
                productEntriesMap.put(String.valueOf(product.ProductCode).toUpperCase(), product);
            
        }
        
        
    }
    /**
* Metodo que se encarga de ejecutar el processescheduler
* @Param sc,  del tipo SchedulableContext se utiliza para agendar el corrido del processScheduler
*/
    public void execute (SchedulableContext sc) {
        
        processScheduler();
    }
    
    /**
* Metodo del tipo futuro que se encarga de insertar todas las notas de credito consultadas por la API
* este metodo inserta Orders con recordtype Nota de credito, con sus respectivos OrderItems
*/
    @future(callout=true) 
    public static void processScheduler () {

        try{
            MSObtenerNotasCredito servicio = new MSObtenerNotasCredito();
            NotasCreditoJSON res = servicio.obtenerNotasCredito();
            
            if(res.Pedidos != null){
            
            init(res);
            stdPbk = [select Id, Name, IsActive from PriceBook2 where IsStandard=True LIMIT 1];
            
            for(NotasCreditoJSON.Pedidos notaCredito : res.Pedidos){
                Order nc = new Order();
                /* String cardcode = notaCredito.CardCode != null ? String.valueOf(notaCredito.CardCode).toUpperCase() : '';
                String busUnit = notaCredito.BusUnit != null ? String.valueOf(notaCredito.BusUnit).toUpperCase() : '';
                String slpCode = notaCredito.SlpCode != null ? String.valueOf(notaCredito.SlpCode).toUpperCase() : ''; */
                
                /* String ClaveCliente = busUnit+slpCode+cardcode; */

                // Added by Oscar
                String ClaveCliente = notaCredito.BusUnit != null && notaCredito.CardCode != null ? 
                                        Accounts.generateAccountKey(notaCredito.BusUnit,notaCredito.CardCode) : null;


                System.debug('ClaveCliente =>'+ClaveCliente);
                Account cliente = String.isNotBlank(ClaveCliente) && mapCuentasIdExterno.containsKey(ClaveCliente) ? 
                                    mapCuentasIdExterno.get(ClaveCliente) : null;
                
                System.debug('cliente =>'+cliente);
                if(cliente != null){
                    
                    //Los valores de CANCELED afectan sólo a la nota de credito
                    String IdNcSap = notaCredito.IdNcSap != null ? String.valueOf(notaCredito.IdNcSap) : '';                
                    System.debug('BUSCAR --------' + IdNcSap + notaCredito.BusUnit.toUpperCase());
                    System.debug('CANCELADA??? --------' + notaCredito.CANCELED); 
                    System.debug('MapNcOrders: '+mapCreditNotesByExternalID.containsKey(idNcSAP + notaCredito.BusUnit.toUpperCase()));
                    
                    // Added By Oscar
                    String ncExternalId = Facturas.generateFacturaKey(notaCredito.IdNcSap, notaCredito.BusUnit);

                    String agenteId = agentesIdsByNCExternalId.containsKey(ncExternalId) ? agentesIdsByNCExternalId.get(ncExternalId) : null;
                    agenteId = String.isNotBlank(notaCredito.BusUnit) ? agenteId + notaCredito.BusUnit.toUpperCase() : null; 

                    if(mapCreditNotesByExternalID.containsKey(idNcSAP + notaCredito.BusUnit.toUpperCase())){
                        if(notaCredito.CANCELED == CANCELED){
                            
                            mapCreditNotesByExternalID.get(idNcSAP + notaCredito.BusUnit.toUpperCase()).Cancelada__c = true;
        
                        }else{
                            System.debug('NO ES CANCELADA');
                            
                        }
                        //-----------Author devManuel-------------------------------------------------------
                        
                        /* OrderItem ordItemUpd;
                        Factura__c ncExistente = mapCreditNotesByExternalID.get(ncExternalId); */

                        
                        /* if(String.isNotBlank(agenteId) && agenteSellerIdByExternalId.containsKey(agenteId)){
                            ncExistente.OwnerId = agenteSellerIdByExternalId.get(agenteId);
                            mapCreditNotesByExternalID.put(ncExternalId,ncExistente);
                        } else{
                            ncExistente.OwnerId = cliente.OwnerId;
                        } */


                        /* for (NotasCreditoJSON.Productos pro : notaCredito.Productos) {
                            
                            Boolean existeEnSalesforce = false;
                            
                            for(OrderItem item : OrderExistente.orderItems){
                                if (item.PricebookEntry.Product2.ProductCode == pro.ItemCode) {
                                    System.debug('Existe item ' + item);
                                    existeEnSalesforce = true;
                                    ordItemUpd = item;
                                    break;
                                }
                            }

                            if (existeEnSalesforce==false) {                   
                                Order externalOrder = new Order(ID_Externo__c = IdNCSap+notaCredito.BusUnit.toUpperCase());
                                crearProducto(pro,cliente,String.valueOf(pro.IdFacSap),externalOrder,String.valueOf(notaCredito.DocumentoBase)); 
                            }
                        } */
                        //-----------------------------------------------------------------------
                        
                    }else{
                        //CREAR NUEVA ORDER Y DE SUS PRODUCTOS OBTENER EL ORDER (idFacSap) Y CAMBIARLE STATUS A nota de credito
                        System.debug('ENTRA A CREAR ORDER');
                        crearOrden(notaCredito, cliente, idNcSAP);
                        if(hasNullValues){
                            break;
                        }

                    }
                    
                }else{
                    String IdNcSap = notaCredito.IdNcSap != null ? String.valueOf(notaCredito.IdNcSap) : '';                
                    System.debug('NO EXISTE EL CLIENTE' + IdNcSap);
                }
                
            }
            
            listNcOrdersByExternalID.addall(mapCreditNotesByExternalID.values());
            
            uow.registerDirty(listNcOrdersByExternalID);

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
            System.debug('Exception caught: '+e.getMessage() +' '+ e.getStackTraceString());
            uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }
        
    }   
    
    private static void crearOrden(NotasCreditoJSON.Pedidos notaCredito, Account cliente, String IdNcSap){
    
        // Added By Oscar
        List<Producto_de_Factura__c> productosDefactura = new List<Producto_de_Factura__c>();
        
        /* Order externalOrder = new Order(ID_Externo__c = String.valueOf(notaCredito.IdNcSap)+notaCredito.BusUnit.toUpperCase()); */
        for (NotasCreditoJSON.Productos producto : notaCredito.Productos) {
            
            Producto_de_Factura__c newProduct = crearProducto(producto);            

            if (hasNullValues){
                break;
            }

            productosDefactura.add(newProduct);
        }

        Factura__c ncToInsert = assingCreditNote(notaCredito,cliente, String.valueOf(notaCredito.BusUnit));

        uow.registerNew(ncToInsert);
        
        for(Producto_de_Factura__c product : productosDefactura){
            product.Vendedor__c = ncToInsert.OwnerId;
            product.OwnerId = ncToInsert.OwnerId;
            uow.registerNew(product, Producto_de_Factura__c.Factura__c, ncToInsert);
        }
        
    }

    private static Factura__c assingCreditNote(NotasCreditoJSON.Pedidos notaCredito, Account acc, String busUnit){
        String ncExternalId  = Facturas.generateFacturaKey(notaCredito.IdNcSap, notaCredito.BusUnit);
        String agenteId = agentesIdsByNCExternalId.containsKey(ncExternalId) ? agentesIdsByNCExternalId.get(ncExternalId) : null;
        agenteId = String.isNotBlank(busUnit) ? agenteId + busUnit.toUpperCase() : null;

        Factura__c creditNote = new Factura__c();
        creditNote.ID_Externo__c = ncExternalId;

        creditNote.RecordTypeId = Constants.FACT_RT_NOTACREDITO_ID;
        creditNote.Centro_de_Costo__c = notaCredito.U_VentaDelCU;
        creditNote.Tipo_de_Unidad__c = String.isNotBlank(notaCredito.U_Tipo) && Constants.MAP_TIPO_UNIDAD.containsKey(notaCredito.U_Tipo) ? Constants.MAP_TIPO_UNIDAD.get(notaCredito.U_Tipo) : null; 
        creditNote.Tarifa__c  = getDecimalVal(notaCredito.U_Tarifa, rate);
        creditNote.Tarifa_Camioneta__c = getDecimalVal(notaCredito.U_TarCam, rate);
        creditNote.Tipo_de_Pago__c = notaCredito.U_metodoDePagoCFD;
        creditNote.Flete__c = notaCredito.U_Flete;
        creditNote.Empresa_Financiera__c = notaCredito.U_EmpresaFinanciera;
        creditNote.Serie_del_documento__c = notaCredito.Series != null ? String.valueOf(notaCredito.Series) : null;

        creditNote.Fecha_Vencimiento_Factura__c =  getDate(notaCredito.DocDueDate);
        creditNote.Fecha_de_Facturaci_n__c = getDate(notaCredito.DocDate);
        creditNote.ltima_Fecha_de_Facturaci_n_en_SAP__c = getDate(notaCredito.UpdateDate);

        creditNote.Comentarios__c = notaCredito.Comments;
        creditNote.ID_SAP_Cuenta__c = notaCredito.CardCode;
        creditNote.Estatus_de_Factura__c = String.isNotBlank(notaCredito.Estatus) ? Constants.MAP_ESTATUS_FACTURA.get(notaCredito.Estatus) : null;
        creditNote.Cancelada__c = String.isNotBlank(notaCredito.CANCELED) && notaCredito.CANCELED == Constants.FACT_CANCELADA ? true : false;
        creditNote.Base_de_Datos__c = notaCredito.BusUnit;
        creditNote.Total_de_gastos_adicionales_flete__c = getDecimalVal(notaCredito.Flete, rate);
        creditNote.N_mero_Nota_de_Cr_dito_SAT__c = notaCredito.NumNc;
        creditNote.Documento_Base__c = notaCredito.DocumentoBase;
        creditNote.Nombre_de_la_Cuenta__c = acc.Id;
        creditNote.Tipo_de_Documento__c = notaCredito.DocType;
        creditNote.Tipo_de_Moneda__c = 'MXP';

        creditNote.Impuesto_Total__c = getDecimalVal(notaCredito.VatSum, rate);
        /* creditNote.Impuesto_Total__c = creditNote.Impuesto_Total__c > 0 ? creditNote.Impuesto_Total__c * (-1) : creditNote.Impuesto_Total__c; */

        
        creditNote.Total_del_Documento__c = getDecimalVal(String.valueOf(notaCredito.DocTotal), rate);
        /* creditNote.Total_del_Documento__c = creditNote.Total_del_Documento__c > 0 ? creditNote.Total_del_Documento__c * (-1) : creditNote.Total_del_Documento__c; */

        creditNote.Monto_Pagado__c = getDecimalVal(String.valueOf(notaCredito.PaidToDate), rate);
        /* creditNote.Monto_Pagado__c = creditNote.Monto_Pagado__c > 0 ? creditNote.Monto_Pagado__c * (-1) : creditNote.Monto_Pagado__c; */

        creditNote.Gross_Profit__c = getDecimalVal(String.valueOf(notaCredito.GrosProfit), rate);
        /* creditNote.Gross_Profit__c = creditNote.Gross_Profit__c > 0 ? creditNote.Gross_Profit__c * (-1) : creditNote.Gross_Profit__c; */

        creditNote.Tipo_de_Cambio__c = notaCredito.U_TipoDeCambio;

        if(notaCredito.CreateTS != null && String.isNotBlank(notaCredito.DocDate)){
            String timeTS = String.valueOf(notaCredito.CreateTS);
            if(timeTS.length() != 6){
                while(timeTS.length() != 6){
                    timeTS = '0' + timeTS;
                }
            }

            String hour = timeTS.substring(0,2);
            String minute = timeTS.substring(2,4);
            String second = timeTS.substring(4,6);
            String completeTime = hour +':' + minute + ':' + second;

            String fechaCorta = notaCredito.DocDate.replace('/', '-');
            List<String> fechaArray = fechaCorta.split('-');

            String fechaCompleta = fechaArray[0]+'-'+fechaArray[1]+'-'+fechaArray[2]+' '+completeTime;

            creditNote.Fecha_de_Facturaci_n_Hora__c = Datetime.valueOf(fechaCompleta);

        }
        
        creditNote.Nota_de_Cr_dito__c = notaCredito.IdNCSap != null ? String.valueOf(notaCredito.IdNCSap) : null;

        if(String.isNotBlank(agenteId) && agenteSellerIdByExternalId.containsKey(agenteId)){
            creditNote.OwnerId = agenteSellerIdByExternalId.get(agenteId);
            creditNote.Canal_2__c = agenteCanalByExternalId.get(agenteId);
        } else{
            creditNote.OwnerId = acc.OwnerId;
        }

        creditNote.Vendedor__c = creditNote.OwnerId;

        if(creditNote.Nombre_de_la_Cuenta__c == null){
            hasNullValues = true;
            errorMsgs += '\n Error en Integración de Notas de Crédito: Cuenta no encontrada: '+ Accounts.generateAccountKey(notaCredito.BusUnit,notaCredito.CardCode);
        }

        return creditNote;

    }
    
    private static Producto_de_Factura__c crearProducto(NotasCreditoJSON.Productos producto){
        
       /*  PricebookEntry pbe = productEntriesMap.containsKey(cliente.Lista_de_Precio__c) && productEntriesMap.get(cliente.Lista_de_Precio__c).containsKey(producto.ItemCode) ? 
            productEntriesMap.get(cliente.Lista_de_Precio__c).get(producto.itemCode) : (!stdPbk.isEmpty() ? productEntriesMap.get(stdPbk.get(0).Id).get(producto.ItemCode) : null); */


            Product2 product = productEntriesMap.containsKey(producto.ItemCode.toUpperCase()) ? productEntriesMap.get(producto.ItemCode.toUpperCase()) : null;
            Producto_de_Factura__c item;
                
                // TODO agregar Error Log con info de producto y pedido
                
                if (product != null ) {
                    
                    Decimal kilos = String.isNotBlank(producto.Kilos) ? Decimal.valueOf( producto.Kilos.replaceAll(',', '')) : null;
                                        
                    item = new Producto_de_Factura__c(
                        Producto__c = product.Id,
                        ID_de_Agente__c = producto.SlpCode != null ? String.valueOf(producto.SlpCode ) : null,
                        Kg__c = kilos,
                        C_digo_de_Producto__c = product.ProductCode,
                        Cantidad__c = getDecimalVal(producto.Factor1,null) ,
                        C_digo_de_IVA__c = producto.TaxCode,
                        Currency__c = 'MXP',
                        Line_Number__c = producto.LineNum
                    );
                    item.Rate__c = producto.Rate!= null && producto.Rate > 0 ? producto.rate : 1; 

                    /* if(String.isNotBlank(producto.Moneda) && String.valueOf(producto.Moneda )== 'USD' && producto.Rate != null){
                        rate = producto.rate;
                        item.Rate__c = rate;
                    } else{
                        rate = null;
                    } */

                    item.IVA__c = getDecimalVal(String.valueOf(producto.VatSum), rate);
                    item.Precio_de_Lista__c = getDecimalVal(producto.Price, rate);

                    item.Gross_Profit__c = getDecimalVal(producto.GrssProfit, rate);
                    /* item.Gross_Profit__c = item.Gross_Profit__c > 0 ? item.Gross_Profit__c * (-1) : item.Gross_Profit__c; */

                    item.Total_de_la_l_nea__c = getDecimalVal(String.valueOf(producto.LineTotal), rate);
                   /*  item.Total_de_la_l_nea__c = item.Total_de_la_l_nea__c > 0 ? item.Total_de_la_l_nea__c * (-1) : item.Total_de_la_l_nea__c; */
                    
                } else{
                    hasNullValues = true;
                    errorMsgs += String.isNotBlank(producto.ItemCode) ? '\nError en integración de notas de crédito: Producto no encontrado: '+ producto.ItemCode : '\nError en integración de notas de crédito: El código del producto de la integración viene nulo' ;
                }
                return item;
    }
    
    private static Decimal getDecimalVal(String strVal, Decimal rate){
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
    
}