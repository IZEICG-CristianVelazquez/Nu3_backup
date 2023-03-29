public interface IErrorLog {
    Error_Log__c log (String message, String record);
    Error_Log__c log (String message, String stackTrace, Integer line);
}