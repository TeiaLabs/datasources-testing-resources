/**
* @description Test data factory helper class
*   suppress reason: refactor
*/
@isTest
@suppressWarnings('PMD.ClassNamingConventionTest')
public class SOM_TestDataFactoryHelper {
    /**
    * @description Creates ConnectApi.ErrorResponse
    * @return List of ConnectApi.ErrorResponse
    */
    public static List<ConnectApi.ErrorResponse> createErrorResponseList() {
        ConnectApi.ErrorResponse error = new ConnectApi.ErrorResponse();
        error.errorCode = SOM_Constants.CONNECT_API_ERROR;
        error.message = SOM_Constants.UNKNOWN;

        return new List<ConnectApi.ErrorResponse>{ error };
    }

    /**
    * @description Creates ConnectApi.ErrorResponse
    * @return List of ConnectApi.OCIReleaseReservationErrorOutputRepresentation
    */
    public static List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation> createOCIReleaseReservationErrorResponseList() {
        ConnectApi.OCIReleaseReservationErrorOutputRepresentation error =
            new ConnectApi.OCIReleaseReservationErrorOutputRepresentation();
        error.errorCode = SOM_Constants.CONNECT_API_ERROR;
        error.message = SOM_Constants.UNKNOWN;

        return new List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation>{ error };
    }

    /**
    * @description Creates ConnectApi.ErrorResponse
    * @return List of ConnectApi.OCITransferReservationErrorOutputRepresentation
    */
    public static List<ConnectApi.OCITransferReservationErrorOutputRepresentation> createOCITransferReservationErrorResponseList() {
        ConnectApi.OCITransferReservationErrorOutputRepresentation error =
            new ConnectApi.OCITransferReservationErrorOutputRepresentation();
        error.errorCode = SOM_Constants.CONNECT_API_ERROR;
        error.message = SOM_Constants.UNKNOWN;

        return new List<ConnectApi.OCITransferReservationErrorOutputRepresentation>{ error };
    }

    /**
    * @description Gets OrderDeliveryGroupSummaryId to list of OrderItemSummary map
    * @param orderDeliveryGroupSummaryList List of OrderDeliveryGroupSummary records
    * @return Map of OrderDeliveryGroupSummaryId to list of OrderItemSummary
    */
    public static Map<String, List<OrderItemSummary>> getOrderItemSummaryMap(List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList) {
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = new Map<String, List<OrderItemSummary>>();

        List<OrderItemSummary> orderItemSummaryList = [SELECT Quantity, OrderDeliveryGroupSummaryId FROM OrderItemSummary 
                                                    WHERE OrderDeliveryGroupSummaryId = :orderDeliveryGroupSummaryList 
                                                    WITH SECURITY_ENFORCED];

        for (OrderItemSummary orderItemSummary : orderItemSummaryList) {
            List<OrderItemSummary> existingOrderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderItemSummary.OrderDeliveryGroupSummaryId);

            if (existingOrderItemSummaryList == null) {
                orderDeliveryGroupSummaryIdToOrderItemSummaryList.put(orderItemSummary.OrderDeliveryGroupSummaryId, new List<OrderItemSummary>{ orderItemSummary });
            }
            else {
                existingOrderItemSummaryList.add(orderItemSummary);
            }
        }

        return orderDeliveryGroupSummaryIdToOrderItemSummaryList;
    }
}