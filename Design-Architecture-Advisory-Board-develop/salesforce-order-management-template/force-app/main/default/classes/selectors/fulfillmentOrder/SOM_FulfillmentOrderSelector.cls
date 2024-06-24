/**
* @description FulfillmentOrder selector class
*/
public with sharing class SOM_FulfillmentOrderSelector implements SOM_IFulfillmentOrderSelector {
    /**
    * @description Selects FulfillmentOrder records based on the Id list
    * @param fulfillmentOrderIds List of the Ids
    * @return List of FulfillmentOrder
    */
    public List<FulfillmentOrder> selectByIds(List<String> fulfillmentOrderIds) {
        return [SELECT Id 
                FROM FulfillmentOrder 
                WHERE Id IN :fulfillmentOrderIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects FulfillmentOrder records by OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of FulfillmentOrder
    */
    public List<FulfillmentOrder> selectByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT Id 
                FROM FulfillmentOrder 
                WHERE OrderSummaryId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects FulfillmentOrderLineItem records by FulfillmentOrder Id
    * @param fulfillmentOrderIds List of the FulfillmentOrder Ids
    * @return List of FulfillmentOrderLineItem
    */
    public List<FulfillmentOrderLineItem> selectLineItemsByFulfillmentOrderIds(List<String> fulfillmentOrderIds) {
        return [SELECT FulfillmentOrderId
                FROM FulfillmentOrderLineItem 
                WHERE FulfillmentOrderId IN :fulfillmentOrderIds
                WITH SECURITY_ENFORCED];
    }
}