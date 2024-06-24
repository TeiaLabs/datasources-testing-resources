/**
* @description ReturnOrderService test class
*/
@isTest
private class SOM_ReturnOrderServiceTest {
    /**
    * @description Test method of ReturnOrderService.createReturnOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateReturnOrder() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Id
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.ReturnOrderLineItemInputRepresentation returnOrderLineItemInput = new ConnectApi.ReturnOrderLineItemInputRepresentation();
            returnOrderLineItemInput.canReduceShipping = true;
            returnOrderLineItemInput.orderItemSummaryId = orderItemSummary.Id;
            returnOrderLineItemInput.quantityExpected = 1;
            returnOrderLineItemInput.quantityReceived = 0;
            returnOrderLineItemInput.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
            returnOrderLineItemInputList.add(returnOrderLineItemInput);
        }

        ConnectApi.ReturnOrderInputRepresentation input = new ConnectApi.ReturnOrderInputRepresentation();
        input.orderSummaryId = orderSummaryId;
        input.returnOrderLifeCycleType = SOM_LifeCycleType.MANAGED.enumValue;
        input.returnOrderLineItems = returnOrderLineItemInputList;
        input.status = SOM_ReturnOrderStatus.APPROVED.enumValue;
        
        Test.startTest();
        ConnectApi.ReturnOrderOutputRepresentation output = SOM_Services.returnOrder.createReturnOrder(input);
        Test.stopTest();

        List<ReturnOrder> returnOrders = [SELECT Id FROM ReturnOrder WHERE OrderSummaryId = :orderSummaryId];

        System.assert(output.success, 'Create return order action is failed');
        System.assert(!returnOrders.isEmpty(), 'No ReturnOrder records found');
    }

    /**
    * @description Test method of ReturnOrderService.returnItems
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldReturnItems() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Id
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.ReturnOrderLineItemInputRepresentation returnOrderLineItemInput = new ConnectApi.ReturnOrderLineItemInputRepresentation();
            returnOrderLineItemInput.canReduceShipping = true;
            returnOrderLineItemInput.orderItemSummaryId = orderItemSummary.Id;
            returnOrderLineItemInput.quantityExpected = 1;
            returnOrderLineItemInput.quantityReceived = 0;
            returnOrderLineItemInput.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
            returnOrderLineItemInputList.add(returnOrderLineItemInput);
        }

        ConnectApi.ReturnOrderInputRepresentation returnOrderInput = new ConnectApi.ReturnOrderInputRepresentation();
        returnOrderInput.orderSummaryId = orderSummaryId;
        returnOrderInput.returnOrderLifeCycleType = SOM_LifeCycleType.MANAGED.enumValue;
        returnOrderInput.returnOrderLineItems = returnOrderLineItemInputList;
        returnOrderInput.status = SOM_ReturnOrderStatus.APPROVED.enumValue;

        String returnOrderId = SOM_Services.returnOrder.createReturnOrder(returnOrderInput).returnOrderId;

        List<ReturnOrderLineItem> returnOrderLineItems = [SELECT Id FROM ReturnOrderLineItem WHERE ReturnOrderId = :returnOrderId];

        ConnectApi.ReturnOrderItemInputRepresentation returnOrderItemInput = new ConnectApi.ReturnOrderItemInputRepresentation();
        returnOrderItemInput.quantityReceived = 1;
        returnOrderItemInput.quantityRejected = 0;
        returnOrderItemInput.quantityReturned = 1;
        returnOrderItemInput.quantityToCancel = 0;
        returnOrderItemInput.reasonForRejection = SOM_ReturnOrderLineItemRejectionReason.WRONG_ITEM.enumValue;
        returnOrderItemInput.returnOrderLineItemId = returnOrderLineItems[0].Id;

        ConnectApi.ReturnItemsInputRepresentation input = new ConnectApi.ReturnItemsInputRepresentation();
        input.returnOrderItems = new List<ConnectApi.ReturnOrderItemInputRepresentation>{ returnOrderItemInput };

        Test.startTest();
        ConnectApi.ReturnItemsOutputRepresentation output = SOM_Services.returnOrder.returnItems(returnOrderId, input);
        Test.stopTest();

        System.assert(output.success, 'Return items action is failed');
    }
}