//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class PedidosActualizadosJSON {

	public class Pedido {
		public Integer DocNum;
		public String Impreso;
		public String Estatus;
		public String Liberado;
		public String BusUnit;
	}

	public List<Pedido> Pedidos;

	
	public static PedidosActualizadosJSON parse(String json) {
		return (PedidosActualizadosJSON) System.JSON.deserialize(json, PedidosActualizadosJSON.class);
	}
}