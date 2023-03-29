public with sharing class UserSelector  extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                User.Id,
                User.Name,
                User.Id_SAP__c,
                User.Proyecto__c,
                User.Grupo__c,
                User.Base_de_datos__c,
                User.ID_SAP_secundario__c

            };

    }

    public Schema.SObjectType getSObjectType() {

        return User.sObjectType;

    }

    public List<User> selectById(Set<ID> idSet) { 

        return (List<User>) selectSObjectsById(idSet);

    }

     public List<User> selectRecentlyUpdated (Integer recordLimit) {

        List<String> userSchema = new List<String>();

        for(Schema.SObjectField sfield : getSObjectFieldList()) {

            userSchema.add(''+sfield);

        }

        String query = String.format(
            'SELECT {0} from {1} ' +
            'ORDER by {2} limit {3}',
             
            new List<Object> {
                String.join( userSchema, ','),
                getSObjectName(),
                getOrderBy(),
                String.valueOf(recordLimit)
            } 
        );

        System.debug('query ' + query);

        return (List<User>) Database.query(query);
    }

    public List<User> selectAll (Integer recordLimit) {

        return (List<User>) Database.query( 
            newQueryFactory(true)
            .setLimit(recordLimit)
            .toSOQL()
        );

    }

    public List<User> selectByUserRoleId (Set<ID> idSet) {

        return (List<User>) Database.query( 
            newQueryFactory(true)
            .setCondition('UserRoleId IN :idSet')
            .toSOQL()
        );

    }


    


}