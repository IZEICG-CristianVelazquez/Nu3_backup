public class ScheduleObtenerLugaresDeEntrega implements Schedulable, Database.AllowsCallouts {

    static final Map<String, String> mapTipoUnidad = new Map<String, String>{'01' => 'Camioneta', '02' => 'Rabón', '03' => 'Torton', '04' => 'Trailer'};

    static final String CAMIONETA = 'Camioneta';
    static final String RABON = 'Rabón';
    static final String TRAILER = 'Trailer';
    static final String TORTON = 'Torton';

    static Map<String, Lugar_de_entrega__c> mapaLE;

    private static void init () {

        cargarLugaresEntrega();

    }

    private static void cargarLugaresEntrega () {

        mapaLE = new Map<String, Lugar_de_entrega__c>();

        for (Lugar_de_entrega__c le : new LugaresDeEntregaSelector().selectAll('25000')) {
            
            if (String.isNotBlank(le.Base_de_Datos__c) && String.isNotBlank(le.Tipo_de_unidad__c) &&
                String.isNotBlank(le.Codigo_SAP__c) ) {

                    mapaLE.put(le.ID_Externo__c, le);

            }
            
        }
        
    }

    public void execute (SchedulableContext sc) {

       processScheduler();
    }

    @future(callout=true) 
    private static void processScheduler () {

        try{
            MSObtenerLugaresDeEntrega servicio = new MSObtenerLugaresDeEntrega();
            LugaresDeEntregaJSON res = servicio.obtenerLugaresDeEntrega();
            
            if (res.Lugares != null) {
    
                init();
    
                List<Lugar_de_entrega__c> lstUpdateLE = new List<Lugar_de_entrega__c>();
                List<Lugar_de_entrega__c> lstInsertLE = new List<Lugar_de_entrega__c>();
            
                for (LugaresDeEntregaJSON.Lugar lugar : res.Lugares) {
                    
                    /* 
                        Mapeo de campos
    
                        Lugar	    LUGAR DE ENTREGA	Name	
                        Código	    LUGAR DE ENTREGA	C_digo_SAP__c	
                                    
                                    LUGAR DE ENTREGA	Tipo_de_unidad__c	Se recibe como encabezado de cada factor. Se debe crear un lugar de entrega por cada tipo de unidad
                                    
                        Camioneta	LUGAR DE ENTREGA	Factor__c	        Salesforce debe crear un lugar de entrega por cada tipo de unidad salvo que el valor del campo sea 0
                        Rabon	    LUGAR DE ENTREGA	Factor__c	        Salesforce debe crear un lugar de entrega por cada tipo de unidad salvo que el valor del campo sea 0
                        Torton	    LUGAR DE ENTREGA	Factor__c	        Salesforce debe crear un lugar de entrega por cada tipo de unidad salvo que el valor del campo sea 0
                        Trailer	    LUGAR DE ENTREGA	Factor__c	        Salesforce debe crear un lugar de entrega por cada tipo de unidad salvo que el valor del campo sea 0
                                    
                        BusUnit	    LUGAR DE ENTREGA	Base_de_Datos__c	Con este campo, "Tipo_de_unidad__c" y "Codigo_SAP__c" se puede hacer una llave única para cada lugar de entrega
                    */
    
                    // LE existente si contiene  la llave de cada uno de los tipos de unidad
    
                    if (mapaLE.containsKey(res.BusUnit + CAMIONETA + lugar.Codigo)) {
                        
                        Lugar_de_entrega__c le = mapaLE.get(res.BusUnit + CAMIONETA + lugar.Codigo);
                        le.Name = lugar.Lugar;
                        le.Factor__c = String.isNotBlank(lugar.Camioneta) ? 
                                         Decimal.valueOf(lugar.Camioneta.replaceAll(',', '')) : le.Factor__c;
                        lstUpdateLE.add(le);
    
                    } else if (String.isNotBlank(lugar.Camioneta) && Decimal.valueOf( lugar.Camioneta.replaceAll(',', '' ) ) > 0 ) {
    
                        lstInsertLE.add( new Lugar_de_entrega__c(ID_Externo__c = res.BusUnit + CAMIONETA + lugar.Codigo, 
                                                                    Codigo_SAP__c = lugar.Codigo,
                                                                    Tipo_de_unidad__c = CAMIONETA,
                                                                    Factor__c =  Decimal.valueOf(lugar.Camioneta.replaceAll(',', '') ),
                                                                    Base_de_Datos__c = res.BusUnit,
                                                                    Name = lugar.Lugar
                                                                )
                                        );
    
                    }
    
                    if (mapaLE.containsKey(res.BusUnit + TORTON + lugar.Codigo)) {
    
                        Lugar_de_entrega__c le = mapaLE.get(res.BusUnit + TORTON + lugar.Codigo);
                        le.Name = lugar.Lugar;
                        le.Factor__c = String.isNotBlank(lugar.Torton) ? 
                                         Decimal.valueOf(lugar.Torton.replaceAll(',', '')) : le.Factor__c;
                        lstUpdateLE.add(le);
                        
                    } else if (String.isNotBlank(lugar.Torton) && Decimal.valueOf(lugar.Torton.replaceAll(',', '' )) > 0) {
    
                        lstInsertLE.add( new Lugar_de_entrega__c(ID_Externo__c = res.BusUnit + TORTON + lugar.Codigo, 
                                                                    Codigo_SAP__c = lugar.Codigo,
                                                                    Tipo_de_unidad__c = TORTON,
                                                                    Factor__c =  Decimal.valueOf(lugar.Torton.replaceAll(',', '') ),
                                                                    Base_de_Datos__c = res.BusUnit,
                                                                    Name = lugar.Lugar
                                                                ) 
                                        );
    
                    }
    
                    if (mapaLE.containsKey(res.BusUnit + TRAILER + lugar.Codigo)) {
    
                        Lugar_de_entrega__c le = mapaLE.get(res.BusUnit + TRAILER + lugar.Codigo);
                        le.Name = lugar.Lugar;
                        le.Factor__c = String.isNotBlank(lugar.Trailer) ? 
                                         Decimal.valueOf(lugar.Trailer.replaceAll(',', '')) : le.Factor__c;
                        lstUpdateLE.add(le);
                        
                    } else if (String.isNotBlank(lugar.Trailer) && Decimal.valueOf(lugar.Trailer.replaceAll(',', '' )) > 0) {
    
                        lstInsertLE.add( new Lugar_de_entrega__c(ID_Externo__c = res.BusUnit + TRAILER + lugar.Codigo, 
                                                                    Codigo_SAP__c = lugar.Codigo,
                                                                    Tipo_de_unidad__c = TRAILER,
                                                                    Factor__c = Decimal.valueOf(lugar.Trailer.replaceAll(',', '') ),
                                                                    Base_de_Datos__c = res.BusUnit,
                                                                    Name = lugar.Lugar
                                                                )  
                                        );
    
                    }
    
                    if (mapaLE.containsKey(res.BusUnit + RABON + lugar.Codigo)) {
    
                        Lugar_de_entrega__c le = mapaLE.get(res.BusUnit + RABON + lugar.Codigo);
                        le.Name = lugar.Lugar;
                        le.Factor__c = String.isNotBlank(lugar.Rabon) ? 
                                         Decimal.valueOf(lugar.Rabon.replaceAll(',', '')) : le.Factor__c;
                        lstUpdateLE.add(le);
                        
                    } else if (String.isNotBlank(lugar.Rabon) && Decimal.valueOf( lugar.Rabon.replaceAll(',', '' )) > 0 ) {
    
                        lstInsertLE.add( new Lugar_de_entrega__c(ID_Externo__c = res.BusUnit + RABON + lugar.Codigo, 
                                                                    Codigo_SAP__c = lugar.Codigo,
                                                                    Tipo_de_unidad__c = RABON,
                                                                    Factor__c = Decimal.valueOf(lugar.Rabon.replaceAll(',', '') ),
                                                                    Base_de_Datos__c = res.BusUnit,
                                                                    Name = lugar.Lugar
                                                                ) 
                                        );
    
                    }
    
    
                }
    
                DMLUtils.insertRecords(lstInsertLE, false);
                DMLUtils.updateRecords(lstUpdateLE, false);
    
    
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