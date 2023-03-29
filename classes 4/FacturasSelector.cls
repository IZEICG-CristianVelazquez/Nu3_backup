public inherited sharing class FacturasSelector extends fflib_SObjectSelector implements IFacturasSelector {

    public static IFacturasSelector newInstance() {
		return (IFacturasSelector) Application.Selector.newInstance(Factura__c.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Factura__c.Id,
            Factura__c.CreatedDate,

            Factura__c.Factura__c,
            Factura__c.Centro_de_Costo__c,
            Factura__c.Tipo_de_Unidad__c,
            Factura__c.Tarifa__c,
            Factura__c.Tarifa_Camioneta__c,
            Factura__c.Tipo_de_Pago__c,
            Factura__c.Flete__c,
            Factura__c.Empresa_Financiera__c,
            Factura__c.ID_de_Agente__c,
            Factura__c.Serie_del_documento__c,
            Factura__c.Proyecto__c,
            Factura__c.Fecha_Vencimiento_Factura__c,
            Factura__c.Fecha_de_Facturaci_n__c,
            /*Factura__c.Fecha_de_Facturaci_n_Hora__c,*/
            Factura__c.ltima_Fecha_de_Facturaci_n_en_SAP__c,
            Factura__c.Descuento__c,
            Factura__c.Flete_Facturado__c,
            Factura__c.Comentarios__c,
            Factura__c.ID_SAP_Cuenta__c,
            Factura__c.N_mero_de_Factura__c,
            Factura__c.Estatus_de_Factura__c,
            Factura__c.Cancelada__c,
            Factura__c.Base_de_Datos__c,

            Factura__c.ID_Externo__c,

            Factura__c.Pedido__c,
            Factura__c.Tipo_de_Documento__c,
            Factura__c.Impuesto_Total__c,
            Factura__c.Tipo_de_Moneda__c,
            Factura__c.Total_del_Documento__c,
            Factura__c.Monto_Pagado__c,
            Factura__c.Gross_Profit__c,
            Factura__c.Tipo_de_Cambio__c,
            Factura__c.Total_de_gastos_adicionales_flete__c,
            Factura__c.C_digo_de_Cliente__c

		};
	}

    public Schema.SObjectType getSObjectType() {
		return Factura__c.SObjectType;
	}

    public List<Factura__c> selectById(Set<Id> setIds) {
		return (List<Factura__c>) selectSObjectsById(setIds);
	}

    public List<Factura__c> selectByIdExterno(Set<String> setIds) {

        return Database.query(
            newQueryFactory()
            .setCondition('ID_Externo__c IN: setIds').toSOQL()
        );
    }

    public List<Factura__c> selectByExternalIdWithProducts(Set<String> setIds){
        // Query Factory for this Selector (Order)
        fflib_QueryFactory facturasQueryFactory = newQueryFactory();

        // Add a query subselect via the Query Factory for the Order Items
        fflib_QueryFactory productsQueryFactory = new 
            ProductosDeFacturaSelector().addQueryFactorySubselect(facturasQueryFactory);

        // Set the condition and build the query
        return (List<Factura__c>) Database.query(
            
            facturasQueryFactory.setCondition('ID_Externo__c IN: setIds').
            toSOQL());
    }
}