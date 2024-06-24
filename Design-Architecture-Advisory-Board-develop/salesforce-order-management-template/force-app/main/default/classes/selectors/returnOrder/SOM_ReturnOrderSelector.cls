/**
* @description ReturnOrder selector class
*/
public with sharing class SOM_ReturnOrderSelector implements SOM_IReturnOrderSelector {
    /**
    * @description Selects ReturnOrder records based on the Id list
    * @param returnOrderIds List of the Ids
    * @return List of ReturnOrder
    */
    public List<ReturnOrder> selectByIds(List<String> returnOrderIds) {
        return [SELECT Id 
                FROM ReturnOrder 
                WHERE Id IN :returnOrderIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects ReturnOrder records by list of OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of ReturnOrder
    */
    public List<ReturnOrder> selectByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT Id 
                FROM ReturnOrder 
                WHERE OrderSummaryId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects ReturnOrderLineItem records by list of ReturnOrder Id
    * @param returnOrderIds List of the FulfillmentOrder Ids
    * @return List of ReturnOrderLineItem
    */
    public List<ReturnOrderLineItem> selectLineItemsByReturnOrderIds(List<String> returnOrderIds) {
        return [SELECT ReturnOrderId
                FROM ReturnOrderLineItem 
                WHERE ReturnOrderId IN :returnOrderIds
                WITH SECURITY_ENFORCED];
    }
}