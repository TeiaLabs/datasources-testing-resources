/**
* @description ReturnOrder service class
*/
public interface SOM_IReturnOrderService {
    /**
    * @description Create a ReturnOrder and
    *   ReturnOrderLineItems for items belonging
    *   to an OrderSummary
    * @param input Data for creating a ReturnOrder
    *   and ReturnOrderLineItems
    * @return Id of the created ReturnOrder
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_ReturnOrder_static_methods.htm#apex_ConnectAPI_ReturnOrder_createReturnOrder_1
    */
    ConnectApi.ReturnOrderOutputRepresentation createReturnOrder(ConnectApi.ReturnOrderInputRepresentation input);

    /**
    * @description Process ReturnOrderLineItems belonging
    *   to a ReturnOrder. Processing a ReturnOrderLineItem
    *   generates a change Order and makes that
    *   ReturnOrderLineItem read-only
    * @param returnOrderId The Id of the ReturnOrder
    * @param input Data about products and delivery
    *   charges to return
    * @return Output of Return Items. Includes the
    *   Id of the generated change order, plus 
    *   information about any ReturnOrderLineItems
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_ReturnOrder_static_methods.htm#apex_ConnectAPI_ReturnOrder_returnItems_1
    */
    ConnectApi.ReturnItemsOutputRepresentation returnItems(String returnOrderId, ConnectApi.ReturnItemsInputRepresentation input);
}