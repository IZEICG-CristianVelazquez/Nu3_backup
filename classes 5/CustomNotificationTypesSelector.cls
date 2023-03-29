public class CustomNotificationTypesSelector extends fflib_SObjectSelector implements ICustomNotificationTypesSelector {
    public static ICustomNotificationTypesSelector newInstance() {
		return (ICustomNotificationTypesSelector) Application.Selector.newInstance(CustomNotificationType.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField> {
            CustomNotificationType.Id,
            CustomNotificationType.DeveloperName
        };

    }

    public Schema.SObjectType getSObjectType() {

        return CustomNotificationType.sObjectType;

    }

    public List<CustomNotificationType> selectByDevName(Set<String> setNames){
        return Database.query(newQueryFactory().setCondition('DeveloperName In : setNames').toSOQL());
    }
}