public inherited sharing class PermissionSetAssignmentsSelector extends fflib_SObjectSelector implements IPermissionSetAssignmentsSelector{
    public static IPermissionSetAssignmentsSelector newInstance() {
		return (IPermissionSetAssignmentsSelector) Application.Selector.newInstance(PermissionSetAssignment.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
            PermissionSetAssignment.Id,
            PermissionSetAssignment.AssigneeId
        };

    }
   
    public Schema.SObjectType getSObjectType() {

        return PermissionSetAssignment.sObjectType;

    }

    public override String getOrderBy(){
        return 'Id';
	}

    public List<PermissionSetAssignment> selectByAssigneeIdWithPermissionSet(Set<Id> setIds){
        return Database.query(
            newQueryfactory()
            .selectField('PermissionSet.Name')
            .setCondition('AssigneeId IN: setIds')
            .toSOQL());
    }
}