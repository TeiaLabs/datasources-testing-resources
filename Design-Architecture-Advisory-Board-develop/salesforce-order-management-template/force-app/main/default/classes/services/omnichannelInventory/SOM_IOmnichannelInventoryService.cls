/**
* @description OmnichannelInventory service class
*/
public interface SOM_IOmnichannelInventoryService {
    /**
    * @description Create an inventory reservation
    *   in Omnichannel Inventory
    * @param input Data to reserve inventory at one or more
    *   Omnichannel Inventory locations or location groups
    * @return Result of an Omnichannel Inventory reservation
    *   creation request
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_createReservation_1
    */
    ConnectApi.OCICreateReservationOutputRepresentation createReservation(ConnectApi.OCICreateReservationInputRepresentation input);

    /**
    * @description Fulfill one or more inventory reservations
    * @param input A list of inventory reservations to fulfill
    * @return Response to a request to fulfill one or more inventory
    *   reservations
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_fulfillReservation_1 
    */
    ConnectApi.OCIFulfillReservationOutputRepresentation fulfillReservation(ConnectApi.OCIFulfillReservationInputRepresentation input);

    /**
    * @description Retrieve inventory availability data for one
    *   or more products at one or more inventory locations or
    *   location groups
    * @param input Details of a request to retrieve inventory availability
    * @return Response to a request for inventory availability data
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_getInventoryAvailability_1
    */
    ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getInventoryAvailability(ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input);

    /**
    * @description Retrieve the status of an inventory availability
    *   upload job
    * @param uploadId The upload Id of the upload job
    * @return Detailed status of an upload inventory availability job
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_getInventoryAvailabilityUploadStatus_1
    */
    ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation getInventoryAvailabilityUploadStatus(String uploadId);

    /**
    * @description Retrieve the status of a publish location structure job
    * @param uploadId The upload ID of the publish job
    * @return Detailed status of a publish location structure job
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_getPublishLocationStructureStatus_1
    */
    ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation getPublishLocationStructureStatus(String uploadId);

    /**
    * @description Asynchronously publish information about your inventory
    *   locations and location groups to Omnichannel Inventory. The publish
    *   includes records whose IsEnabled and ShouldSyncWithOci fields are
    *   both true. This method returns an ID that you can use to retrieve
    *   the status of the publish job
    * @return Response to a publish location structure request
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_publishLocationStructure_2
    */
    ConnectApi.OCIPublishLocationStructureOutputRepresentation publishLocationStructure();

    /**
    * @description Release one or more existing inventory reservations
    *   to free up that inventory
    * @param input Details of one or more inventory reservations to release
    * @return Response to a request to release one or more inventory reservations
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_releaseReservation_1
    */
    ConnectApi.OCIReleaseReservationOutputRepresentation releaseReservation(ConnectApi.OCIReleaseReservationInputRepresentation input);

    /**
    * @description Upload an inventory availability data file to
    *   Omnichannel Inventory
    * @param input JSON file containing inventory availability data
    * @return Response to an upload inventory availability job
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_submitInventoryAvailabilityUpload_2
    */
    ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation submitInventoryAvailabilityUpload(ConnectApi.BinaryInput input);

    /**
    * @description Transfer one or more inventory reservations
    *   between locations or location groups. This API doesn’t
    *   change physical quantities, but reduces the reserved
    *   quantity at the source and increases it at the destination
    * @param input A list of inventory reservation transfers and
    *   specifies whether a single failure cancels the entire list
    * @return Response to a request to transfer one or more inventory
    *   reservations
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OmnichannelInventoryService_static_methods.htm#apex_ConnectAPI_OmnichannelInventoryService_transferReservation_1
    */
    ConnectApi.OCITransferReservationOutputRepresentation transferReservation(ConnectApi.OCITransferReservationInputRepresentation input);
}