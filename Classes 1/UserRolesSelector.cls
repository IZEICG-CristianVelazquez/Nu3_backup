public with sharing class UserRolesSelector  extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
                UserRole.Id,
                UserRole.ParentRoleId

            };

    }

    public Schema.SObjectType getSObjectType() {

        return UserRole.sObjectType;

    }

    public List<UserRole> selectById(Set<ID> idSet) {

        return (List<UserRole>) selectSObjectsById(idSet);

    }

    public List<UserRole> selectByParentRoleId (Set<ID> idSet) {

        return (List<UserRole>) Database.query( 
            newQueryFactory(true)
            .setCondition('ParentRoleId IN :idSet AND ParentRoleID != null')
            .toSOQL()
        );

    }

    

}