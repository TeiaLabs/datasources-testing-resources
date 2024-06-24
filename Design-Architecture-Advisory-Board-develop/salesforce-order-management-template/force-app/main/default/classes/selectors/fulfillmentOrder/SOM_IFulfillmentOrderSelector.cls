/**
* @description FulfillmentOrder selector interface
*/
public interface SOM_IFulfillmentOrderSelector {
    /**
    * @description Selects FulfillmentOrder records based on the Id list
    * @param fulfillmentOrderIds List of the Ids
    * @return List of FulfillmentOrder
    */
    List<FulfillmentOrder> selectByIds(List<String> fulfillmentOrderIds);

    /**
    * @description Selects FulfillmentOrder records by OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of FulfillmentOrder
    */
    List<FulfillmentOrder> selectByOrderSummaryIds(List<String> orderSummaryIds);

    /**
    * @description Selects FulfillmentOrderLineItem records by FulfillmentOrder Id
    * @param fulfillmentOrderIds List of the FulfillmentOrder Ids
    * @return List of FulfillmentOrderLineItem
    */
    List<FulfillmentOrderLineItem> selectLineItemsByFulfillmentOrderIds(List<String> fulfillmentOrderIds);
}
