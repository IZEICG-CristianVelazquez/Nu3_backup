public with sharing class PedidosJSON {

	public class Pedido {
		public String U_VentaDelCU;
		public String U_Tipo;
		public String U_Tarifa;
		public String U_TarCam;
		public String U_metodoDePagoCFD;
		public String U_LE;
		public String U_Flete;
		public String U_EmpresaFinanciera;
		public String Status;
		public Integer SlpCode;
		public String ShipToCode;
		public Integer Series;
		public String Project;
		public List<Producto> Productos;
		public String JrnlMemo;
		public Integer IdSap;
		public String IdSalesforce;
		public Integer IdFacSap;
		public String DocDueDate;
		public String DocDate;
		public String DiscPrcnt;
		public String Comments;
		public String CardCode;
		public String BusUnit;
		public String Referencia;
	}

	public class Producto {
		public String TaxCode;
		public Integer SlpCode;
		public String Project;
		public String Price;
		public String ItemCode;
		public String IdSalesforce;
		public String Factor1;
		public String DiscPrcnt;
		public String Kilos;
	}

	public List<Pedido> Pedidos;
	public Integer Cantidad;

	
	public static PedidosJSON parse(String json) {
		return (PedidosJSON) System.JSON.deserialize(json, PedidosJSON.class);
	}

}