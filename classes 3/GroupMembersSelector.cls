public with sharing class GroupMembersSelector extends fflib_SObjectSelector implements IGroupMembersSelector {
    public static IGroupMembersSelector newInstance() {
		return (IGroupMembersSelector) Application.Selector.newInstance(GroupMember.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
            GroupMember.Id,
            GroupMember.UserOrGroupId
        };

    }

    public Schema.SObjectType getSObjectType() {

        return GroupMember.sObjectType;

    }

    public override String getOrderBy(){
        return 'Id';
	}

    public List<GroupMember> selectByGroupId(Set<Id> setIds){
        return Database.query(
            newQueryFactory()
            .setCondition('GroupId In : setIds').toSOQL());
    }
}