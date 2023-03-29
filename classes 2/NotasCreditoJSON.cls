public class NotasCreditoJSON {

	public class Pedidos {
		public String U_VentaDelCU;
		public String U_Tipo;
		public String U_Tarifa;
		public String U_TarCam;
		public String U_metodoDePagoCFD;
		public String U_LE;
		public String U_Flete;
		public String U_EmpresaFinanciera;
		public Object Status;
		public Integer SlpCode;
		public Object ShipToCode;
		public Integer Series;
		public String Project;
		public List<Productos> Productos;
		public Object JrnlMemo;
		public Integer DocumentoBase;
		public Integer IdNCSap;
		public Object IdSalesforce;
		public String DocDueDate;
		public String DocDate;
		public Object DiscPrcnt;
		public String Flete;
		public String Listadeprecios;
		public String Comments;
		public String CardCode;
		public String NumNC;
		public String Estatus;
		public String BusUnit;

		public String UpdateDate;
		public String CANCELED;

		// nuevos campos
		public String DocType;
		public String VatSum;
		public String DocCur;
		public String DocTotal;
		public String PaidToDate;
		public String GrosProfit;
		public Decimal U_TipoDeCambio;
		public Integer ObjType;
		public String CardName;
		public Integer CreateTS;

	}

	public class Productos {
		public String TaxCode;
		public Integer SlpCode;
		public Object Project;
		public String Price;
		public String ItemCode;
		public Object IdSalesforce;
		public String Factor1;
		public String Kilos;
		public String DiscPrcnt;
		public String GrssProfit;
		public Integer IdFacSap;

		// nuevos campos
		public String Moneda;
		public String VatSum;
		public Decimal Rate;
		public Integer LineNum;
		public String  Dscription;
		public String LineTotal;
		public String LineStatus;

	}

	public List<Pedidos> Pedidos;

	
	public static NotasCreditoJSON parse(String json) {
		return (NotasCreditoJSON) System.JSON.deserialize(json, NotasCreditoJSON.class);
	}
}