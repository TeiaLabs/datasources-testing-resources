/**
* @description OmnichannelInventoryService test class
*/
@isTest
private class SOM_OmnichannelInventoryServiceTest {
    /**
    * @description Test method of OmnichannelInventoryService.createReservation
    */
    @isTest
    static void shouldCreateReservation() {
        ConnectApi.OCICreateReservationSingleInputRepresentation singleReservationInput = new ConnectApi.OCICreateReservationSingleInputRepresentation();
        singleReservationInput.locationGroupIdentifier = 'TEST_LOCATION_GROUP';
        singleReservationInput.quantity = 1;
        singleReservationInput.stockKeepingUnit = '001';

        ConnectApi.OCICreateReservationInputRepresentation input = new ConnectApi.OCICreateReservationInputRepresentation();
        input.actionRequestId = 'requestId';
        input.allowPartialReservations = true;
        input.expirationSeconds = 20;
        input.externalRefId = 'externalRef_Id';
        input.reservationTime = DateTime.now().format('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
        input.createRecords = new List<ConnectApi.OCICreateReservationSingleInputRepresentation>{ singleReservationInput };

        Test.startTest();
        ConnectApi.OCICreateReservationOutputRepresentation output = SOM_Services.omnichannelInventory.createReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Create reservation action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.fulfillReservation
    */
    @isTest
    static void shouldFulfillReservation() {
        ConnectApi.OCIFulfillReservationSingleInputRepresentation singleFulfillInput = new ConnectApi.OCIFulfillReservationSingleInputRepresentation();
        singleFulfillInput.actionRequestId = 'request_Id';
        singleFulfillInput.externalRefId = 'externalRef_Id';
        singleFulfillInput.locationIdentifier = 'TEST_LOCATION';
        singleFulfillInput.quantity = 1;
        singleFulfillInput.stockKeepingUnit = '001';

        ConnectApi.OCIFulfillReservationInputRepresentation input = new ConnectApi.OCIFulfillReservationInputRepresentation();
        input.fulfillmentRecords = new List<ConnectApi.OCIFulfillReservationSingleInputRepresentation> { singleFulfillInput };

        Test.startTest();
        ConnectApi.OCIFulfillReservationOutputRepresentation output = SOM_Services.omnichannelInventory.fulfillReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Fulfill reservation action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.getInventoryAvailability
    */
    @isTest
    static void shouldGetInventoryAvailability() {
        ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input = new ConnectApi.OCIGetInventoryAvailabilityInputRepresentation();
        input.locationIdentifiers = new List<String>{ 'location_Id' };
        input.stockKeepingUnit = '001';
        input.useCache = false;

        Test.startTest();
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = SOM_Services.omnichannelInventory.getInventoryAvailability(input);
        Test.stopTest();

        System.assert(output.success, 'Get inventory availability action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.getInventoryAvailabilityUploadStatus
    */
    @isTest
    static void shouldGetInventoryAvailabilityUploadStatus() {
        String uploadId = 'upload_id';

        Test.startTest();
        ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation output = SOM_Services.omnichannelInventory.getInventoryAvailabilityUploadStatus(uploadId);
        Test.stopTest();

        System.assert(output.success, 'Get inventory availability upload status action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.getPublishLocationStructureStatus
    */
    @isTest
    static void shouldGetPublishLocationStructureStatus() {
        String uploadId = 'upload_id';

        Test.startTest();
        ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation output = SOM_Services.omnichannelInventory.getPublishLocationStructureStatus(uploadId);
        Test.stopTest();

        System.assert(output.success, 'Get publish location structure action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.publishLocationStructure
    */
    @isTest
    static void shouldPublishLocationStructure() {
        Test.startTest();
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output = SOM_Services.omnichannelInventory.publishLocationStructure();
        Test.stopTest();

        System.assert(output.success, 'Publish location structure action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.releaseReservation
    */
    @isTest
    static void shouldReleaseReservation() {
        ConnectApi.OCIReleaseReservationInputRepresentation input = new ConnectApi.OCIReleaseReservationInputRepresentation();
        ConnectApi.OCIReleaseReservationSingleInputRepresentation inputItem = new ConnectApi.OCIReleaseReservationSingleInputRepresentation();
        inputItem.actionRequestId = 'actionRequest_Id';
        inputItem.externalRefId = 'externalRef_Id';
        inputItem.locationIdentifier = 'location_id';
        inputItem.quantity = 1;
        inputItem.stockKeepingUnit = '001';

        input.releaseRecords = new List<ConnectApi.OCIReleaseReservationSingleInputRepresentation>{ inputItem };

        Test.startTest();
        ConnectApi.OCIReleaseReservationOutputRepresentation output = SOM_Services.omnichannelInventory.releaseReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Release reservation action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.submitInventoryAvailabilityUpload
    */
    @isTest
    static void shouldSubmitInventoryAvailabilityUpload() {
        ConnectApi.BinaryInput input = new ConnectApi.BinaryInput
        (
            Blob.valueOf('blob'), 
            'application/json', 
            'test.json'
        );
        
        Test.startTest();
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output = SOM_Services.omnichannelInventory.submitInventoryAvailabilityUpload(input);
        Test.stopTest();

        System.assert(output.success, 'Submit inventory availability upload action is failed');
    }

    /**
    * @description Test method of OmnichannelInventoryService.transferReservation
    */
    @isTest
    static void shouldTransferReservation() {
        ConnectApi.OCITransferReservationSingleInputRepresentation singleReservationInput = new ConnectApi.OCITransferReservationSingleInputRepresentation();
        singleReservationInput.actionRequestId = 'actionRequest_Id';
        singleReservationInput.externalRefId = 'externalRef_Id';
        singleReservationInput.fromLocationGroupIdentifier = 'TEST_LOCATION_GROUP';
        singleReservationInput.ignoreAvailabilityCheck = false;
        singleReservationInput.quantity = 1;
        singleReservationInput.stockKeepingUnit = '001';
        singleReservationInput.toLocationIdentifier = 'TEST_LOCATION';

        ConnectApi.OCITransferReservationInputRepresentation input = new ConnectApi.OCITransferReservationInputRepresentation();
        input.transferRecords = new List<ConnectApi.OCITransferReservationSingleInputRepresentation>{ singleReservationInput };

        Test.startTest();
        ConnectApi.OCITransferReservationOutputRepresentation output = SOM_Services.omnichannelInventory.transferReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Transfer reservation action is failed');
    }
}