public class pruebanu3 {

	public class Pedidos {
		public List<Productos> Productos;
		public String IdSalesforce;
		public String IdEmpleadoVentas;
		public String FechaEntrega;
		public String FechaContabilizacion;
		public String Concepto;
		public Object CodigoCliente;
	}

	public class Productos {
		public Double PrecioUnitario;
		public String IdSalesforce;
		public String CodigoProducto;
		public String CodigoImpuesto;
		public Double Cantidad;
	}

	public List<Pedidos> Pedidos;
	public Integer Cantidad;

	
	public static pruebanu3 parse(String json) {
		return (pruebanu3) System.JSON.deserialize(json, pruebanu3.class);
	}
}