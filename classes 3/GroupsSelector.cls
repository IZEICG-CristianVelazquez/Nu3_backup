public with sharing class GroupsSelector extends fflib_SObjectSelector implements IGroupsSelector {
    public static IGroupsSelector newInstance() {
		return (IGroupsSelector) Application.Selector.newInstance(Group.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
            Group.Id,
            Group.DeveloperName
        };

    }

    public Schema.SObjectType getSObjectType() {

        return Group.sObjectType;

    }

    public List<Group> selectByDevName(Set<String> setNames){
        return Database.query(
            newQueryFactory()
            .setCondition('DeveloperName In : setNames').toSOQL());
    }
}