public inherited sharing class ErrorLog extends fflib_SObjectDomain implements IErrorLog{

    public static IErrorLog newInstance(List<Error_Log__c> recordList) {
		return (IErrorLog) Application.Domain.newInstance(recordList);
	}
	
	public static IErrorLog newInstance(Set<Id> recordIdSet) {
		return (IErrorLog) Application.Domain.newInstance(recordIdSet);
	}

    public ErrorLog(List<Error_Log__c> sObjectList){
       super(sObjectList);
    }
  
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> records){
            return new ErrorLog(records);
        }
    }

    public override void onAfterInsert () {
        getUsersandNotifyThem();
    }

    /**
     * metodo para guardado de errores de DMLs
    */
    public static Error_Log__c log (String message, String record) {

        return new Error_Log__c(Message__c = message, Record__c = record);

    }

    /**
     * metodo para guardado de errores de Excepciones
    */
    public static Error_Log__c log (String message, String stackTrace, Integer line) {

        return new Error_Log__c(Message__c = message, StackTrace__c = stackTrace, Line__c = line);
    }

    public void getUsersAndNotifyThem(){
        List<Group> grupos = GroupsSelector.newInstance().selectByDevName(new Set<String>{'salesforceAdmins'});


        Id adminGroupId = !grupos.isEmpty() ? grupos[0].Id : null;
        /* Id adminGroupId = [SELECT  Id FROM Group Where DeveloperName = 'salesforceAdmins']?.Id; */

        Set<String> usersToNotify = new Set<String>();
        Id notificationTypeId = [SELECT Id, DeveloperName FROM CustomNotificationType  WHERE DeveloperName='Integration_Error']?.Id;
        /* List<CustomNotificationType> notificationTypes = CustomNotificationTypesSelector.newInstance().selectByDevName(new Set<String>{'Integration_Error'}); */
        /* Id notificationTypeId = !notificationTypes.isEmpty() ? notificationTypes[0].Id : null; */
        
        for(GroupMember member : GroupMembersSelector.newInstance().selectByGroupId(new Set<Id>{adminGroupId})){
            usersToNotify.add(member.UserOrGroupId);
        }

        for(Error_Log__c errorLog : (List<Error_Log__c>)this.Records){
            
            if(errorLog.Integration__c){
                notifyUsers(usersToNotify, errorLog.Id, notificationTypeId);
            }
        }
    }

    
    public static void notifyUsers(Set<String> recipientsIds, String targetId,String notificationTypeId) {

        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
 
        // Set the contents for the notification
        notification.setTitle(Constants.CN_TITLE);
        notification.setBody(Constants.CN_BODY);
 
        // Set the notification type and target
        notification.setNotificationTypeId(notificationTypeId);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            notification.send(recipientsIds);
            System.debug('notification sent to: '+recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

}