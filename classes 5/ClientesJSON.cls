public with sharing class ClientesJSON {
   public List<Clientes> Clientes;

	public class Clientes {
		public String CardCode;
		public String CardName;
		public Integer ListNum;
		public List<Direcciones> Direcciones;
		public String LicTradNum;
		public String Phone;
		public Integer SlpCode;
		public String ProjectCod;
		public String Activo;
		public String ClienteSalesForce;
		public String BusUnit;
		public Integer Grupo;
		public Decimal Flete;
		public Decimal Balance;
		public Decimal CreditLine;
        public String Email;

	}

	public class Direcciones {
		public String ID_de_direccion;
		public String Street;
		public String City;
		public String State;
		public String ZipCode;
		public String Country;
		public String AdresType;
	}

	
	public static ClientesJSON parse(String json) {
		return (ClientesJSON) System.JSON.deserialize(json, ClientesJSON.class);
	}
}