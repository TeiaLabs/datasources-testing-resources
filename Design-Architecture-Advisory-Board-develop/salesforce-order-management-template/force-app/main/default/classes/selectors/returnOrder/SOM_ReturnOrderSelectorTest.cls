/**
* @description ReturnOrderSelector test class
*/
@isTest
private class SOM_ReturnOrderSelectorTest {
    /**
    * @description Test method of ReturnOrderSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        // in order to create a return order
        // order item summary status should be fulfilled
        // by fulfilling the fulfillment order 
        update fulfillmentOrder;

        OrderItemSummary orderItemSummary = [SELECT Id FROM OrderItemSummary 
                                            WHERE OrderSummaryId = :orderSummaryId
                                                AND Type =: SOM_OrderItemType.ORDER_PRODUCT.enumValue][0];

        // line item input for create order action
        List<ConnectApi.ReturnOrderLineItemInputRepresentation> inputItemList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        ConnectApi.ReturnOrderLineItemInputRepresentation inputItem = new ConnectApi.ReturnOrderLineItemInputRepresentation();
        inputItem.canReduceShipping = false;
        inputItem.orderItemSummaryId = orderItemSummary.Id;
        inputItem.quantityExpected = 1;
        inputItem.quantityReceived = 0;
        inputItem.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
        inputItemList.add(inputItem);

        // create return order
        String returnOrderId = SOM_TestDataFactory.createReturnOrder(orderSummaryId, SOM_ReturnOrderStatus.APPROVED, inputItemList).returnOrderId;

        Test.startTest();
        List<ReturnOrder> returnOrder = new SOM_ReturnOrderSelector().selectByIds(new List<String>{ returnOrderId });
        Test.stopTest();
        
        Set<Id> resultIds = (new Map<Id,SObject>(returnOrder)).keySet();
        System.assert(resultIds.contains(returnOrderId), 'No return order found');
    }

    /**
    * @description Test method of ReturnOrderSelector.selectByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        // in order to create a return order
        // order item summary status should be fulfilled
        // by fulfilling the fulfillment order 
        update fulfillmentOrder;

        OrderItemSummary orderItemSummary = [SELECT Id FROM OrderItemSummary 
                                            WHERE OrderSummaryId = :orderSummaryId
                                                AND Type =: SOM_OrderItemType.ORDER_PRODUCT.enumValue][0];

        // line item input for create order action
        List<ConnectApi.ReturnOrderLineItemInputRepresentation> inputItemList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        ConnectApi.ReturnOrderLineItemInputRepresentation inputItem = new ConnectApi.ReturnOrderLineItemInputRepresentation();
        inputItem.canReduceShipping = false;
        inputItem.orderItemSummaryId = orderItemSummary.Id;
        inputItem.quantityExpected = 1;
        inputItem.quantityReceived = 0;
        inputItem.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
        inputItemList.add(inputItem);

        // create return order
        String returnOrderId = SOM_TestDataFactory.createReturnOrder(orderSummaryId, SOM_ReturnOrderStatus.APPROVED, inputItemList).returnOrderId;

        Test.startTest();
        List<ReturnOrder> returnOrder = new SOM_ReturnOrderSelector().selectByOrderSummaryIds(new List<String>{ orderSummaryId });
        Test.stopTest();

        Set<Id> resultIds = (new Map<Id,SObject>(returnOrder)).keySet();
        System.assert(resultIds.contains(returnOrderId), 'No return order found');
    }

    /**
    * @description Test method of ReturnOrderSelector.selectLineItemsByReturnOrderIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectLineItemsByReturnOrderIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        // in order to create a return order
        // order item summary status should be fulfilled
        // by fulfilling the fulfillment order 
        update fulfillmentOrder;

        OrderItemSummary orderItemSummary = [SELECT Id FROM OrderItemSummary 
                                            WHERE OrderSummaryId = :orderSummaryId
                                                AND Type =: SOM_OrderItemType.ORDER_PRODUCT.enumValue][0];

        // line item input for create order action
        List<ConnectApi.ReturnOrderLineItemInputRepresentation> inputItemList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        ConnectApi.ReturnOrderLineItemInputRepresentation inputItem = new ConnectApi.ReturnOrderLineItemInputRepresentation();
        inputItem.canReduceShipping = false;
        inputItem.orderItemSummaryId = orderItemSummary.Id;
        inputItem.quantityExpected = 1;
        inputItem.quantityReceived = 0;
        inputItem.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
        inputItemList.add(inputItem);

        // create return order
        String returnOrderId = SOM_TestDataFactory.createReturnOrder(orderSummaryId, SOM_ReturnOrderStatus.APPROVED, inputItemList).returnOrderId;

        Test.startTest();
        List<ReturnOrderLineItem> returnOrderLineItems = new SOM_ReturnOrderSelector().selectLineItemsByReturnOrderIds(new List<String>{ returnOrderId });
        Test.stopTest();

        List<Id> returnOrderIdList = new List<Id>();
        for(ReturnOrderLineItem returnOrderLineItem : returnOrderLineItems){
            returnOrderIdList.add(returnOrderLineItem.ReturnOrderId);
        }

        System.assert(returnOrderIdList.contains(returnOrderId), 'No return order line item(s) found');
    }
}