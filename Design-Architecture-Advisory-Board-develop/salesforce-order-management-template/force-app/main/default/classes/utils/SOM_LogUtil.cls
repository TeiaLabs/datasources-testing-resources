/**
* @description Log util class
*/
public with sharing class SOM_LogUtil extends SOM_LogUtilHandler {
    private static List<SOM_Log__c> logsToInsert = new List<SOM_Log__c>();

    /**
    * @description Inserting all the logs at once
    * @return List of SaveResult
    */
    public static List<Database.SaveResult> insertLogs() {
        List<Database.SaveResult> results = Database.insert(logsToInsert, false);
        logsToInsert.clear();
        return results;
    }

    /**
    * @description Creates OMS error log and adds to logs list
    * @param category Category of the log
    * @param message Message of the log
    * @return SOM_Log__c instance
    */
    public static SOM_Log__c createErrorLog(String category, String message) {
        SOM_Log__c log = createLog(category, message, true);
        logsToInsert.add(log);
        return log;
    }

    /**
    * @description Creates OMS error log and adds to logs list
    * @param attachedToId Attached/related object Id
    * @param category Category of the log
    * @param message Message of the log
    * @return SOM_Log__c instance
    */
    public static SOM_Log__c createErrorLog(String attachedToId, String category, String message) {
        SOM_Log__c log = createLog(attachedToId, category, message, true);
        logsToInsert.add(log);
        return log;
    }

    /**
    * @description Creates OMS info log and adds to logs list
    * @param category Category of the log
    * @param message Message of the log
    * @return SOM_Log__c instance
    */
    public static SOM_Log__c createInfoLog(String category, String message) {
        SOM_Log__c log = createLog(category, message, false);
        logsToInsert.add(log);
        return log;
    }

    /**
    * @description Creates OMS info log and adds to logs list
    * @param attachedToId Attached/related object Id
    * @param category Category of the log
    * @param message Message of the log
    * @return SOM_Log__c instance
    */
    public static SOM_Log__c createInfoLog(String attachedToId, String category, String message) {
        SOM_Log__c log = createLog(attachedToId, category, message, false);
        logsToInsert.add(log);
        return log;
    }

    /**
    * @description Creates OMS log
    * @param category Category of the log
    * @param message Message of the log
    * @param isError Is Error?
    * @return SOM_Log__c instance
    */
    private static SOM_Log__c createLog(String category, String message, Boolean isError) {
        SOM_Log__c log = new SOM_Log__c();
        log.Category__c = category;
        log.Message__c = message;
        log.IsError__c = isError;
        return log;
    }

    /**
    * @description Creates OMS log
    *   suppress reason : todo refactor
    * @param attachedToId Attached/related object Id
    * @param category Category of the log
    * @param message Message of the log
    * @param isError Is Error?
    * @return SOM_Log__c instance
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    private static SOM_Log__c createLog(String attachedToId, String category, String message, Boolean isError) {
        SOM_Log__c log = new SOM_Log__c();
        log.AttachedToId__c = attachedToId;
        log.Category__c = category;
        log.Message__c = message;
        log.IsError__c = isError;
        return log;
    }

    /**
    * @description Creates OMS log based on failed send email result(s) and adds to logs list
    * @param results Send email results
    */
    public static void createEmailErrors(Messaging.SendEmailResult[] results) {
        for (Messaging.SendEmailResult result : results) {
            if (!result.isSuccess()) {
                createEmailErrorsAsLogs(result.getErrors());
            }
        }
    }

    /**
    * @description Creates OMS logs based on failed ConnectApi method and adds to logs list
    * @param output Base output class
    */
    public static void createConnectApiErrors(ConnectApi.BaseOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }

    /**
    * @description Creates OMS logs based on failed OCI ConnectApi method and adds to logs list
    * @param output OCIBaseOutputRepresentation
    */
    public static void createConnectApiErrors(ConnectApi.OCIBaseOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }

    /**
    * @description Creates OMS logs based on failed OCI ConnectApi method and adds to logs list
    * @param output OCICreateReservationOutputRepresentation
    */
    public static void createConnectApiErrors(ConnectApi.OCICreateReservationOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }

    /**
    * @description Creates OMS logs based on failed OCI ConnectApi method and adds to logs list
    * @param output OCIFulfillReservationOutputRepresentation
    */
    public static void createConnectApiErrors(ConnectApi.OCIFulfillReservationOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }

    /**
    * @description Creates OMS logs based on failed OCI ConnectApi method and adds to logs list
    * @param output OCIReleaseReservationOutputRepresentation
    */
    public static void createConnectApiErrors(ConnectApi.OCIReleaseReservationOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }

    /**
    * @description Creates OMS logs based on failed OCI ConnectApi method and adds to logs list
    * @param output OCIReleaseReservationOutputRepresentation
    */
    public static void createConnectApiErrors(ConnectApi.OCITransferReservationOutputRepresentation output) {
        if (!output.success) {
            createConnectApiErrorsAsLogs(output.errors);
        }
    }
}