public class DMLUtils {

    public static void insertRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.SaveResult> saveResults = Database.insert(records, allOrNone);
        
        processSaveResults(saveResults,false);

    }

    public static void insertIntegrationRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.SaveResult> saveResults = Database.insert(records, allOrNone);
        
        processSaveResults(saveResults,true);

    }

    public static void deleteRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.DeleteResult> deleteResults = Database.delete(records, allOrNone);
        
        processDeleteResults(deleteResults);

    }

    public static void updateRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.SaveResult> saveResults = Database.update(records, allOrNone);

        processSaveResults(saveResults,false);
        

    }

    public static void updateIntegrationRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.SaveResult> saveResults = Database.update(records, allOrNone);

        processSaveResults(saveResults,true);
        

    }

    public static void upsertRecords (List<SObject> records, Boolean allOrNone) {

        List<Database.UpsertResult> upsertResults = Database.upsert(records, allOrNone);

        processUpsertResults(upsertResults);
        

    }


    public static void processSaveResults (List<Database.SaveResult> saveResults, Boolean isIntegration) {

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

       /*  ErrorLog el = new ErrorLog(); */

        for (Database.SaveResult sr : saveResults) {

            if (!sr.isSuccess()) {
                System.debug('sr' + sr);
                Error_Log__c errorLog = ErrorLog.log(String.valueOf(sr.getErrors()), sr.getId());
                errorLog.Integration__c = isIntegration;
                uow.registerNew(errorLog);
               /*  el.log(String.valueOf(sr.getErrors()), sr.getId()); */

            }

        }
        uow.commitWork();
        /* el.saveErrors(); */

    }

    public static void processDeleteResults (List<Database.DeleteResult> deleteResults) {

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        /* ErrorLog el = new ErrorLog(); */

        for (Database.DeleteResult sr : deleteResults) {

            if (!sr.isSuccess()) {
                System.debug('sr' + sr);
                uow.registerNew(ErrorLog.log(String.valueOf(sr.getErrors()), sr.getId()));
               /*  el.log(String.valueOf(sr.getErrors()), sr.getId()); */

            }

        }
        uow.commitWork();
        /* el.saveErrors(); */

    }

    public static void processUpsertResults (List<Database.UpsertResult> upsertResults) {

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

       /*  ErrorLog el = new ErrorLog(); */

        for (Database.UpsertResult sr : upsertResults) {

            if (!sr.isSuccess()) {
                uow.registerNew(ErrorLog.log(String.valueOf(sr.getErrors()), sr.getId()));
                /* el.log(String.valueOf(sr.getErrors()), sr.getId()); */

            }

        }

        uow.commitWork();
       /*  el.saveErrors(); */

    }

}