/**
* @description OrderSummary service class
*/
public interface SOM_IOrderSummaryService {
    /**
    * @description Create an OrderSummary based on an order
    * @param input OrderSummaryInputRepresentation
    * @return Id of the created Order Summary
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummaryCreation_static_methods.htm#apex_ConnectAPI_OrderSummaryCreation_createOrderSummary_1
    */
    ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(ConnectApi.OrderSummaryInputRepresentation input);

    /**
    * @description Retrieve the expected results of adjusting
    *   the price of one or more OrderItemSummaries from an OrderSummary,
    *   without actually executing the adjustment
    * @param orderSummaryId Id of the OrderSummary
    * @param input A list of price adjustments to 
    *   OrderItemSummaries that make up a price adjustment to an order
    * @return Output representation of the financial changes for an adjust
    *   items action
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_adjustPreview_1
    */
    ConnectApi.AdjustOrderSummaryOutputRepresentation adjustPreview(String orderSummaryId, ConnectApi.AdjustOrderItemSummaryInputRepresentation input);

    /**
    * @description Adjust the price of one or more OrderItemSummaries
    *   from an OrderSummary, and create one or two corresponding change
    *   orders
    * @param orderSummaryId Id of the OrderSummary
    * @param input A list of price adjustments to 
    *   OrderItemSummaries that make up a price adjustment to an order
    * @return Output representation of the financial changes for an adjust
    *   items action
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_adjustSubmit_1
    */ 
    ConnectApi.AdjustOrderSummaryOutputRepresentation adjustSubmit(String orderSummaryId, ConnectApi.AdjustOrderItemSummaryInputRepresentation input);

    /**
    * @description Create a credit memo to represent the refund for one
    *   or more change orders associated with an OrderSummary
    * @param orderSummaryId Id of the OrderSummary
    * @param input The list of change order Ids
    * @return Id of a created Credit Memo
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_createCreditMemo_1
    */
    ConnectApi.CreateCreditMemoOutputRepresentation createCreditMemo(String orderSummaryId, ConnectApi.CreateCreditMemoInputRepresentation input);

    /**
    * @description Ensure funds for an invoice and apply them to it
    * @param orderSummaryId Id of the OrderSummary
    * @param input ID of an invoice to ensure funds for and apply them to
    * @return Id of the asynchronous background operation
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_ensureFundsAsync_1
    */
    ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsAsync(String orderSummaryId, ConnectApi.EnsureFundsAsyncInputRepresentation input);

    /**
    * @description Ensure refunds for a credit memo or excess funds
    *   by sending a request to a payment provider
    * @param orderSummaryId Id of the OrderSummary
    * @param input ID of a credit memo to ensure refunds for, an amount of
    *   excess funds to refund, or both. At least one is required
    * @return Id of the background operation
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_ensureRefundsAsync_1
    */
    ConnectApi.EnsureRefundsAsyncOutputRepresentation ensureRefundsAsync(String orderSummaryId, ConnectApi.EnsureRefundsAsyncInputRepresentation input);

    /**
    * @description Retrieve the expected change order values for
    *   canceling one or more OrderItemSummaries from an OrderSummary
    *   without actually executing the cancel
    * @param orderSummaryId Id of the OrderSummary
    * @param input A list of changes to OrderItemSummaries that
    *   make up an order change, such as a cancel or return
    * @return Expected financial values for a proposed cancel action
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_previewCancel_1
    */
    ConnectApi.PreviewCancelOutputRepresentation previewCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation input);

    /**
    * @description Retrieve the expected change order values for returning
    *   one or more OrderItemSummaries from an OrderSummary, without actually
    *   executing the return
    * @param orderSummaryId Id of the OrderSummary
    * @param input A list of changes to OrderItemSummaries that
    *   make up an order change, such as a cancel or return
    * @return Expected financial values for a proposed return action
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_previewReturn_1
    */
    ConnectApi.PreviewReturnOutputRepresentation previewReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation input);

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummar
    * @param input A list of changes to OrderItemSummaries that make up an order
    *   change, such as a cancel or return
    * @return ID of the change order created for a cancel action, and a set of its
    *   financial values
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_submitCancel_1
    */
    ConnectApi.SubmitCancelOutputRepresentation submitCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation input);

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummary
    * @param input A list of changes to OrderItemSummaries that make up an order
    *   change, such as a cancel or return
    * @return ID of the change order created for a cancel action, and a set of its
    *   financial values
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderSummary_static_methods.htm#apex_ConnectAPI_OrderSummary_submitReturn_1
    */
    ConnectApi.SubmitReturnOutputRepresentation submitReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation input);
}