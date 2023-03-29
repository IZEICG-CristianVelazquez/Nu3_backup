public class AccountsSelector extends fflib_SObjectSelector implements IAccountsSelector {

    public static IAccountsSelector newInstance() {
		return (IAccountsSelector) Application.Selector.newInstance(Account.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Account.Id,
                Account.Name,
                Account.ShippingCity,
                Account.ShippingState,
                Account.Frecuencia_mensual_de_visitas__c,
                Account.Ultima_Visita__c,
                Account.Id_SAP__c,
                Account.Lista_de_precio__c,
                Account.ID_Agente__c,
                Account.Proyecto__c,
                Account.Clave_cliente__c,
                Account.Fecha_Primer_Factura__c,
                Account.Fecha_Ultima_Factura__c,
                Account.Correo_electr_nico__c,
                Account.Phone,
                Account.Base_de_Datos__c,
                Account.OwnerId

            };

    }

    public Schema.SObjectType getSObjectType() {

        return Account.sObjectType;

    }

    public List<Account> selectById(Set<ID> idSet) {

        return (List<Account>) selectSObjectsById(idSet);

    }

    public List<Account> selectByExternalId (Set<String> externalIds, Integer recordLimit) {

        // Query Factory for this Selector (Account)
        fflib_QueryFactory ordersQueryFactory = newQueryFactory();        
        
        // Set the condition and build the query

        return (List<Account>) Database.query(
            ordersQueryFactory.setCondition('Clave_cliente__c in :externalIds').setLimit(recordLimit).toSOQL());
    }

    public List<Account> selectRecentlyUpdated (Integer recordLimit) {

        List<String> acctSchema = new List<String>();

        for(Schema.SObjectField sfield : getSObjectFieldList()) {

            acctSchema.add(''+sfield);

        }

        String query = String.format(
            'SELECT {0} from {1} ' +
            'ORDER by {2} limit {3}',
             
            new List<Object> {
                String.join( acctSchema, ','),
                getSObjectName(),
                getOrderBy(),
                String.valueOf(recordLimit)
            } 
        );

        System.debug('query ' + query);

        return (List<Account>) Database.query(query);
    }

}