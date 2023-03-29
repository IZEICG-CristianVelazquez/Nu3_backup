@RestResource(urlMapping='/api/pedidos/*')
global class ServicePedidos {

    global class WSPedido {

        /*
        ORDR.CardCode	String	Codigo de cliente		ID_SAP__c
        ORDR.Series	    numeric	Serie del documento		Serie_del_Documento__c
        ORDR.DocDate	date	Fecha del pedido		CreatedDate
        ORDR.DocDueDate	date	Fecha de entrega		EffectiveDate
        ORDR.SlpCode	numeric	Codigo de agente de ventas		ID_SAP__c
        ORDR.Comments	String	Comentarios del pedido		Comentarios__c
        ORDR.JrnlMemo	String	Entrada en el diario		
        ORDR.Project	String	Codigo de proyecto		Proyecto__c
        ORDR.BusUnit	String	Unidad de Negocio		Unidad_de_Negocio__c
        ORDR.DiscPrcnt	numeric	Descuento por Documento		
        ORDR.ShipToCode	String	Destino		
        ORDR.U_metodoDePagoCFD	string	Metodo de pago		Tipo_de_pago__c
        ORDR.U_EmpresaFinanciera	string	Empresa quien financia el credito		Empresa_Financiera__c
        ORDR.U_VentaDelCU	     string	Ventas del centro de costo		
        ORDR.U_Flete	        string	Aplica flete		Incluye_flete__c
        ORDR.U_LE	            string	Lugar de entrega		BillingAddress
        ORDR.U_Tipo	            string	Tipo de transporte		Tipo_de_Unidad__c
        ORDR.U_Tarifa	        numeric	Tarifa camionera		Costo_flete__c
        */

        public String CardCode;
        public String Series;
        public Date DocDate;
        public Date DocDueDate;
        public String SlpCode;
        public String Comments;
        public String JrnlMemo;
        public String Project;
        public String BusUnit;
        public Decimal DiscPrcnt;
        public String ShipToCode;
        public String U_metodoDePagoCFD;
        public String U_EmpresaFinanciera;
        public String U_VentaDelCU;
        public String U_Flete;
        public String U_LE;
        public String U_Tipo;
        public Decimal U_Tarifa;
        public Decimal U_TarCam;
        public List<WSProducto> Productos;
        public String IdSalesforce; 
        public String IdSap;
        public String Status;
        

        public WSPedido (String CardCode, String Series, Date DocDate, Date DocDueDate, String SlpCode, String Comments, String JrnlMemo, 
                        String Project, String BusUnit, Decimal DiscPrcnt, String ShipToCode,
                        String U_metodoDePagoCFD, String U_EmpresaFinanciera, String U_VentaDelCU, String U_Flete, String U_LE, String U_Tipo,
                        Decimal U_Tarifa, Decimal U_TarCam, List<WSProducto> Productos, String IdSalesforce, String IdSap) {
            
            this.CardCode = CardCode;
            this.Series = Series; 
            this.DocDate = DocDate;
            this.DocDueDate = DocDueDate;
            this.SlpCode = SlpCode;
            this.Comments = Comments;
            this.Project = Project;
            this.BusUnit = BusUnit;
            this.DiscPrcnt = DiscPrcnt;
            this.ShipToCode = ShipToCode;
            this.U_metodoDePagoCFD = U_metodoDePagoCFD;
            this.U_EmpresaFinanciera = U_EmpresaFinanciera;
            this.U_VentaDelCU = U_VentaDelCU;
            this.U_Flete = U_Flete;
            this.U_LE = U_LE;
            this.U_Tipo = U_Tipo;
            this.U_Tarifa = U_Tarifa;
            this.U_TarCam = U_TarCam;
            this.Productos = Productos;
            this.IdSalesforce = IdSalesforce;
            this.IdSap = IdSap;

        }

    }

    global class WSProducto {
        
        /*
        RDR1.ItemCode	string	Codigo de producto		ProductCode
        RDR1.Factor1	numeric	Cantidad en sacos		Quantity
        RDR1.DiscPrcnt	numeric	% de descuento por linea		
        RDR1.TaxCode	string	codigo de iva		Codigo_de_IVA__c
        RDR1.SlpCode	string	Codigo de empleado por linea		
        RDR1.Project	string	Codigo de proyecto por linea	
        */	

        public String ItemCode;
        public Decimal Factor1;
        public Decimal DiscPrcnt;
        public String TaxCode;
        public String SlpCode;
        public String Project;
        public Decimal Price;
        public String IdSalesforce;
        public WSProducto (String ItemCode, Decimal Factor1, Decimal DiscPrcnt, String TaxCode, String SlpCode, String Project, Decimal Price, String IdSalesforce) {
            this.ItemCode = ItemCode;
            this.Factor1 = Factor1;
            this.DiscPrcnt = DiscPrcnt;
            this.TaxCode = TaxCode;
            this.SlpCode = SlpCode;
            this.Project = Project;
            this.Price = Price;
            this.IdSalesforce = IdSalesforce;
        }
    }
    global class WSResponsePedidos {
        public List<WSPedido> Pedidos;
        public Integer Cantidad;
        public WSResponsePedidos (List<WSPedido> pedidos, Integer cantidad) {
            this.Pedidos = pedidos;
            this.Cantidad = cantidad;
        }
    }
    public static WSResponsePedidos parse(String json) {
		return (WSResponsePedidos) System.JSON.deserialize(json, WSResponsePedidos.class);
	}
    @HttpGet
    global static void obtenerPedidos () {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        RestResponse res = RestContext.response;
        List<WSPedido> pedidos;
        
        try {
            pedidos = ServicePedidosHelper.obtenerUltimosPedidos();
            Integer cantidad = pedidos == null || pedidos.IsEmpty() ? 0 : pedidos.size();
            
            if (pedidos != null) {
                res.responseBody = blob.valueof(JSON.serialize(new WSResponsePedidos(pedidos, cantidad)));
            }   
        } catch (Exception e) {

            res.statusCode = 500;
            uow.registerNew(ErrorLog.log(e.getMessage(), e.getMessage(), e.getLineNumber()));
            uow.commitWork();

            /* ErrorLog el = new ErrorLog();
            el.log (e.getMessage(), e.getMessage(), e.getLineNumber());
            el.saveErrors(); */
        }
    }

    @HttpPost
    global static void actualizarPedidos () {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            WSResponsePedidos container = (WSResponsePedidos)System.JSON.deserialize(RestContext.request.requestBody.tostring(), WSResponsePedidos.class);
            ServicePedidosHelper.actualizarUltimosPedidos(container);
        } catch (Exception e) {

            uow.registerNew(ErrorLog.log(e.getMessage(), e.getMessage(), e.getLineNumber()));
            uow.commitWork();

            /* ErrorLog el = new ErrorLog();
            el.log (e.getMessage(), e.getMessage(), e.getLineNumber());
            el.saveErrors(); */
        }
    }
}