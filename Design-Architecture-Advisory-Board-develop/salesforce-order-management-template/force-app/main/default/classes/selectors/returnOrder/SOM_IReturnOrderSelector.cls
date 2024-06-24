/**
* @description OrderSummary selector interface
*/
public interface SOM_IReturnOrderSelector {
    /**
    * @description Selects ReturnOrder records based on the Id list
    * @param returnOrderIds List of the Ids
    * @return List of ReturnOrder
    */
    List<ReturnOrder> selectByIds(List<String> returnOrderIds);

    /**
    * @description Selects ReturnOrder records by list of OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of ReturnOrder
    */
    List<ReturnOrder> selectByOrderSummaryIds(List<String> orderSummaryIds);

    /**
    * @description Selects ReturnOrderLineItem records by list of ReturnOrder Id
    * @param returnOrderIds List of the FulfillmentOrder Ids
    * @return List of ReturnOrderLineItem
    */
    List<ReturnOrderLineItem> selectLineItemsByReturnOrderIds(List<String> returnOrderIds);
}