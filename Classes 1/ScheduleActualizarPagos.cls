public class ScheduleActualizarPagos implements Schedulable, Database.AllowsCallouts {
	
    static Map<String, Order> mapOrdersIdExterno;
    
    public void execute (SchedulableContext sc) {
        
        processScheduler();
        
    }
    
    @future(callout=true) 
    private static void processScheduler () {
        
        MSObtenerPagos pagos = new MSObtenerPagos();
		JSONPagosResponse res = pagos.obtenerPagos();
        
        init(res.TotalPagosSAP);
        
    }
    
    private static void init (List<JSONPagosResponse.TotalPagosSAP> res) {
        
        try{
            mapOrdersIdExterno = new Map<String, Order>();
            Set<String> setIdsExternos = new Set<String>();
            
            for (JSONPagosResponse.TotalPagosSAP pago : res) {
                
                if (pago.Factura != null && pago.BaseDatos != null) {
                    
                    Order ord = new Order();
                    ord.Estatus_de_factura__c = pago.EstatusFactura;
                    
                    if (pago.FechaVencimientoFactura != null ) {
                        
                        String[] fechaArr = pago.FechaVencimientoFactura.split('-');
                        
                        Date fechaVencimiento = Date.newInstance(Integer.valueOf(fechaArr[2]), 
                                                       Integer.valueOf(fechaArr[1]), 
                                                       Integer.valueOf(fechaArr[0])
                                                      );
                        ord.Fecha_Vencimiento_Factura__c = fechaVencimiento;
                        ord.ID_Externo__c = String.valueOf(pago.Factura) + pago.BaseDatos;
                        
                        if (pago.TotalFactura != null) {
                            ord.Total_Factura__c = Decimal.valueOf(pago.TotalFactura.replaceAll(',', ''));
                        }
                        
                        if (pago.TotalPagadoFactura != null) {
                            ord.Total_Pagado_Factura__c = Decimal.valueOf(pago.TotalPagadoFactura.replaceAll(',', ''));
                        }
                       
                        
                    }
                    
                    mapOrdersIdExterno.put(String.valueOf(pago.Factura) + pago.BaseDatos, ord);
                    
                }
                
            }
            
            Database.upsert (mapOrdersIdExterno.values(), Order.ID_Externo__c, false);
        } catch(Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }

        
    }
    
}