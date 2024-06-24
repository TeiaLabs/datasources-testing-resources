/**
* @description FulfillmentOrder service class
*/
public with sharing class SOM_FulfillmentOrderService implements SOM_IFulfillmentOrderService {
    /**
    * @description Cancel FulfillmentOrderLineItems from a
    *   FulfillmentOrder. This action doesn’t cancel the 
    *   associated OrderItemSummaries, so reallocate the 
    *   canceled quantities to a new FulfillmentOrder
    * @param fulfillmentOrderId Id of the FulfillmentOrder
    * @param input List of FulfillmentOrderLineItems to cancel
    * @return Wraps the base output
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_FulfillmentOrder_static_methods.htm#apex_ConnectAPI_FulfillmentOrder_cancelFulfillmentOrderLineItems_1
    */
    public ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation cancelFulfillmentOrderLineItems(String fulfillmentOrderId, ConnectApi.FulfillmentOrderLineItemsToCancelInputRepresentation input) {
        return ConnectApi.Fulfillmentorder.cancelFulfillmentOrderLineItems(fulfillmentOrderId, input);
    }

    /**
    * @description Create one or more FulfillmentOrders and
    *   FulfillmentOrderLineItems for an OrderDeliveryGroupSummary
    * @param input OrderItemSummaries to allocate, with location 
    *   and delivery information
    * @return A list of Ids of the created FulfillmentOrders
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_FulfillmentOrder_static_methods.htm#apex_ConnectAPI_FulfillmentOrder_createFulfillmentOrders_1
    */
    public ConnectApi.FulfillmentOrderOutputRepresentation createFulfillmentOrders(ConnectApi.FulfillmentOrderInputRepresentation input) {
        return ConnectApi.Fulfillmentorder.createFulfillmentOrders(input);
    }

    /**
    * @description Create an invoice for a FulfillmentOrder that
    *   doesn’t have one
    * @param fulfillmentOrderId Id of the FulfillmentOrder
    * @param input Instantiate and include this object with no
    *   properties when creating an invoice
    * @return Id of the created Invoice
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_FulfillmentOrder_static_methods.htm#apex_ConnectAPI_FulfillmentOrder_createInvoice_1
    */
    public ConnectApi.FulfillmentOrderInvoiceOutputRepresentation createInvoice(String fulfillmentOrderId, ConnectApi.FulfillmentOrderInvoiceInputRepresentation input) {
        return ConnectApi.Fulfillmentorder.createInvoice(fulfillmentOrderId, input);
    }

    /**
    * @description Create FulfillmentOrders for multiple
    *   OrderDeliveryGroups in a single request
    * @param input Wraps a list of inputs for creating fulfillment
    *   orders
    * @return List of responses for the individual 
    *   FulfillmentOrder creation attempts from a create
    *   multiple fulfillment orders request
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_FulfillmentOrder_static_methods.htm#apex_ConnectAPI_FulfillmentOrder_createMultipleFulfillmentOrder_1
    */
    public ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrder(ConnectApi.MultipleFulfillmentOrderInputRepresentation input) {
        return ConnectApi.Fulfillmentorder.createMultipleFulfillmentOrder(input);
    }

    /**
    * @description Create Invoices for multiple FulfillmentOrders 
    * @param input The FulfillmentOrders to create Invoices for
    * @return Ids of the created Invoices
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_FulfillmentOrder_static_methods.htm#apex_ConnectAPI_FulfillmentOrder_createMultipleInvoices_1
    */
    public ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation createMultipleInvoices(ConnectApi.MultipleFulfillmentOrderInvoicesInputRepresentation input) {
        return ConnectApi.Fulfillmentorder.createMultipleInvoices(input);
    }
}