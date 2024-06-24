/**
* @description Handler class for LogUtil
*/
public with sharing virtual class SOM_LogUtilHandler {
    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createEmailErrorsAsLogs(Messaging.SendEmailError[] errors) {
        for (Database.Error error : errors) {
            SOM_LogUtil.createErrorLog(String.valueOf(error.getStatusCode()), error.getMessage());
        }
    }

    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createConnectApiErrorsAsLogs(ConnectApi.ErrorResponse[] errors) {
        for (ConnectApi.ErrorResponse error : errors) {
            SOM_LogUtil.createErrorLog(error.errorCode, error.message);
        }
    }

    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createConnectApiErrorsAsLogs(ConnectApi.OCITransferReservationErrorOutputRepresentation[] errors) {
        for (ConnectApi.OCITransferReservationErrorOutputRepresentation error : errors) {
            SOM_LogUtil.createErrorLog(error.errorCode, error.message);
        }
    }

    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createConnectApiErrorsAsLogs(ConnectApi.OCIFulfillReservationErrorOutputRepresentation[] errors) {
        for (ConnectApi.OCIFulfillReservationErrorOutputRepresentation error : errors) {
            SOM_LogUtil.createErrorLog(error.errorCode, error.message);
        }
    }

    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createConnectApiErrorsAsLogs(ConnectApi.OCICreateReservationErrorOutputRepresentation[] errors) {
        for (ConnectApi.OCICreateReservationErrorOutputRepresentation error : errors) {
            SOM_LogUtil.createErrorLog(error.errorCode, error.message);
        }
    }

    /**
    * @description Creates errors from result and adds to the logs list
    * @param errors Errors
    */
    public static void createConnectApiErrorsAsLogs(ConnectApi.OCIReleaseReservationErrorOutputRepresentation[] errors) {
        for (ConnectApi.OCIReleaseReservationErrorOutputRepresentation error : errors) {
            SOM_LogUtil.createErrorLog(error.errorCode, error.message);
        }
    }
}