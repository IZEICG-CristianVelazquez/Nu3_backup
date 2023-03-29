public class VisitasSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                Visita__c.Cliente__c,
                Visita__c.Fecha_y_hora_de_inicio__c
            };

    }

    public Schema.SObjectType getSObjectType() {

        return Visita__c.sObjectType;

    }

    public List<Visita__c> selectById(Set<ID> idSet) {

        return (List<Visita__c>) selectSObjectsById(idSet);

    }

    public List<Visita__c> selectCreatedThisMonth () {

        List<String> acctSchema = new List<String>();

        for(Schema.SObjectField sfield : getSObjectFieldList()) {

            acctSchema.add(''+sfield);

        }

        Integer mnth = System.Today().MOnth();
        Integer yr = System.Today().Year();

        String query = String.format(
            'SELECT {0} from {1} ' +
            'WHERE CALENDAR_MONTH(Fecha_y_hora_de_inicio__c) = :mnth ' +
            'AND CALENDAR_YEAR(Fecha_y_hora_de_inicio__c) = :yr ' +
            'ORDER by {2} ',
             
            new List<Object> {
                String.join( acctSchema, ','),
                getSObjectName(),
                getOrderBy()
            } 
        );

        System.debug('query ' + query);

        return (List<Visita__c>) Database.query(query);
    }

}