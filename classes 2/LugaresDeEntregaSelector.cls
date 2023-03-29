public class LugaresDeEntregaSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Lugar_de_Entrega__c.Name,
                Lugar_de_Entrega__c.Tipo_de_unidad__c,
                Lugar_de_Entrega__c.Base_de_Datos__c,
                Lugar_de_Entrega__c.Factor__c,
                Lugar_de_Entrega__c.Cliente__c,
                Lugar_de_Entrega__c.Codigo_SAP__c,
                Lugar_de_Entrega__c.ID_Externo__c
            };

    }

    public Schema.SObjectType getSObjectType() {

        return Lugar_de_Entrega__c.sObjectType;

    }

    public List<Lugar_de_Entrega__c> selectById(Set<ID> idSet) {

        return (List<Lugar_de_Entrega__c>) selectSObjectsById(idSet);

    }

    public List<Lugar_de_Entrega__c> selectAll(String soqlLimit) {

        List<String> acctSchema = new List<String>();

        for(Schema.SObjectField sfield : getSObjectFieldList()) {
            acctSchema.add(''+sfield);
        }

        String query = String.format(
            'SELECT {0} from {1} ' +
            'ORDER by {2} ' +
            'LIMIT {3}' ,
             
            new List<Object> {
                String.join( acctSchema, ','),
                getSObjectName(),
                getOrderBy(),
                soqlLimit
            } 
        );

        System.debug('query ' + query);

        return (List<Lugar_de_Entrega__c>) Database.query(query);
    }

    

}