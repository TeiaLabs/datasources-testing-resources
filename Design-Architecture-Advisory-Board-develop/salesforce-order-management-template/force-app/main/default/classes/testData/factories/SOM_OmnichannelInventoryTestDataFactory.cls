/**
* @description OmnichannelInventory test data class
*/
@isTest
@suppressWarnings('PMD.ClassNamingConventionTest')
public with sharing class SOM_OmnichannelInventoryTestDataFactory {
    private final static String TIME_FORMAT = 'YYYY-MM-dd\'T\'HH:mm:ss\'Z\'';
    private final static String TEST_LOCATION_GROUP = 'TEST_LOCATION_GROUP';
    private final static String UNKNOWN_EXCEPTION = 'UNKOWN_EXCEPTION';
    private final static String CODE = '001';

    /**
    * @description Creates success output for reservation
    * @return ConnectApi.OCICreateReservationOutputRepresentation
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation createSuccessCreateReservationOutput() {
        ConnectApi.OCICreateReservationSingleOutputRepresentation outputItem = new ConnectApi.OCICreateReservationSingleOutputRepresentation();
        outputItem.locationGroupIdentifier = TEST_LOCATION_GROUP;
        outputItem.quantity = 1;
        outputItem.stockKeepingUnit = CODE;

        ConnectApi.OCICreateReservationOutputRepresentation output = new ConnectApi.OCICreateReservationOutputRepresentation();
        output.details = new List<ConnectApi.OCICreateReservationSingleOutputRepresentation>{ outputItem };
        output.expirationTime = DateTime.now().addDays(1).format(TIME_FORMAT);
        output.reservationTime = DateTime.now().format(TIME_FORMAT);
        output.success = true;
        output.errors = new List<ConnectApi.OCICreateReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates failed output for reservation
    * @return ConnectApi.OCICreateReservationOutputRepresentation
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation createFailedCreateReservationOutput() {
        ConnectApi.OCICreateReservationErrorOutputRepresentation error = new ConnectApi.OCICreateReservationErrorOutputRepresentation();
        error.message = UNKNOWN_EXCEPTION;
        error.errorCode = CODE;
        
        ConnectApi.OCICreateReservationOutputRepresentation output = new ConnectApi.OCICreateReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCICreateReservationErrorOutputRepresentation>{ error };

        return output;
    }

    /**
    * @description Creates success output for fulfill reservation
    * @return Success fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation createSuccessFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIFulfillReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates failed output for fulfill reservation
    * @return Success fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation createFailedFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationErrorOutputRepresentation error = new ConnectApi.OCIFulfillReservationErrorOutputRepresentation();
        error.message = UNKNOWN_EXCEPTION;
        error.errorCode = CODE;
        
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCIFulfillReservationErrorOutputRepresentation>{ error };

        return output;
    }

    /**
    * @description Creates success output for get inventory availability
    * @return ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation
    */
    public static ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation createSuccessGetInventoryAvailabilityOutput() {
        ConnectApi.OCIInventoryRecordOutputRepresentation inventoryRecord = new ConnectApi.OCIInventoryRecordOutputRepresentation();
        inventoryRecord.availableToFulfill = 1;
        inventoryRecord.availableToOrder = 1;
        inventoryRecord.effectiveDate = DateTime.now();
        inventoryRecord.onHand = 1;
        inventoryRecord.reserved = 0;
        inventoryRecord.safetyStockCount = 0;
        inventoryRecord.stockKeepingUnit = CODE;

        ConnectApi.OCILocationGroupAvailabilityOutputRepresentation locationGroupItem = new ConnectApi.OCILocationGroupAvailabilityOutputRepresentation();
        locationGroupItem.inventoryRecords = new List<ConnectApi.OCIInventoryRecordOutputRepresentation>{ inventoryRecord };
        locationGroupItem.locationGroupIdentifier = TEST_LOCATION_GROUP;

        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation();
        output.locationGroups = new List<ConnectApi.OCILocationGroupAvailabilityOutputRepresentation>{ locationGroupItem };
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates failed output for get inventory availability
    * @return ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation
    */
    public static ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation createFailedInventoryAvailabilityOutputRepresentation() {
        ConnectApi.ErrorResponse error = new ConnectApi.ErrorResponse();
        error.message = UNKNOWN_EXCEPTION;
        error.errorCode = CODE;

        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.ErrorResponse>{ error };

        return output;
    }

    /**
    * @description Creates success output for get inventory availability
    *   upload status
    * @return ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation createSuccessGetInventoryAvailabilityUploadStatusOutput() {
        ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation output = new ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation();
        output.endTimeUTC = DateTime.now().format(TIME_FORMAT);
        output.recordsProcessedCount = 100;
        output.recordsReadCount = 100;
        output.recordsSkippedCount = 0;
        output.startTimeUTC = DateTime.now().addMinutes(-10).format(TIME_FORMAT);
        output.status = 'COMPLETED';
        output.uploadId = 'some_id';
        output.validationErrors = new List<String>();
        output.validationStatus = '';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates failed output for get inventory availability
    *   upload status
    * @return ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation
    */
    public static ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation createSuccessGetPublishLocationStructureStatusOutput() {
        ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation output = new ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation();
        output.endTimeUTC = DateTime.now().format(TIME_FORMAT);
        output.recordsProcessedCount = 100;
        output.recordsReadCount = 100;
        output.recordsSkippedCount = 0;
        output.startTimeUTC = DateTime.now().addMinutes(-10).format(TIME_FORMAT);
        output.status = 'COMPLETED';
        output.uploadId = 'some_id';
        output.validationErrors = new List<String>();
        output.validationStatus = '';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIPublishLocationStructureOutputRepresentation test data
    * @return ConnectApi.OCIPublishLocationStructureOutputRepresentation
    */
    public static ConnectApi.OCIPublishLocationStructureOutputRepresentation createSuccessPublishLocationStructureOutput() {
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output = new ConnectApi.OCIPublishLocationStructureOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIReleaseReservationOutputRepresentation test data
    * @return ConnectApi.OCIReleaseReservationOutputRepresentation
    */
    public static ConnectApi.OCIReleaseReservationOutputRepresentation createSuccessReleaseReservationOutput() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = new ConnectApi.OCIReleaseReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIUploadInventoryAvailabilityOutputRepresentation test data
    * @return ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation createSuccessSubmitInventoryAvailabilityUploadOutput() {
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCITransferReservationOutputRepresentation test data
    * @return Success transfer reservation output
    */
    public static ConnectApi.OCITransferReservationOutputRepresentation createSuccessTransferReservationOutput() {
        ConnectApi.OCITransferReservationOutputRepresentation output = new ConnectApi.OCITransferReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCITransferReservationErrorOutputRepresentation>();

        return output;
    }
}