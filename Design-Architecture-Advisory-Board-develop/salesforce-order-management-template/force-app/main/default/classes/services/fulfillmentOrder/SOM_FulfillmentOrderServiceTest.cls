/**
* @description FulfillmentOrderService test class
*/
@isTest
private class SOM_FulfillmentOrderServiceTest {
    /**
    * @description Test method of FulfillmentOrderService.cancelFulfillmentOrderLineItems
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCancelFulfillmentOrderLineItems() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        List<FulfillmentOrderLineItem> fulfillmentOrderLineItems = [
            SELECT Quantity 
            FROM FulfillmentOrderLineItem 
            WHERE FulfillmentOrderId = :fulfillmentOrderId];

        ConnectApi.FulfillmentOrderLineItemsToCancelInputRepresentation input = new ConnectApi.FulfillmentOrderLineItemsToCancelInputRepresentation();
        input.fulfillmentOrderLineItemsToCancel = new List<ConnectApi.FulfillmentOrderLineItemInputRepresentation>();

        for (FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrderLineItems) {
            ConnectApi.FulfillmentOrderLineItemInputRepresentation inputItem = new ConnectApi.FulfillmentOrderLineItemInputRepresentation();
            inputItem.quantity = fulfillmentOrderLineItem.Quantity;
            inputItem.fulfillmentOrderLineItemId = fulfillmentOrderLineItem.Id;
            input.fulfillmentOrderLineItemsToCancel.add(inputItem);
        }

        Test.startTest();
        ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation output = SOM_Services.fulfillmentOrder.cancelFulfillmentOrderLineItems(fulfillmentOrderId, input);
        Test.stopTest();

        fulfillmentOrderLineItems = [SELECT Quantity FROM FulfillmentOrderLineItem WHERE FulfillmentOrderID = :fulfillmentOrderId];

        for (FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrderLineItems) {
            System.assert(fulfillmentOrderLineItem.Quantity == 0, String.format('Fulfillment order line item quantity is {0}', new List<String>{ String.valueOf(fulfillmentOrderLineItem.Quantity) }));
        }

        System.assert(output.success, 'Cancel fulfillment order line items action is failed');
    }

    /**
    * @description Test method of FulfillmentOrderService.createFulfillmentOrders
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateFulfillmentOrders() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        // preparing input for fulfillment order creation
        ConnectApi.FulfillmentOrderInputRepresentation input = new ConnectApi.FulfillmentOrderInputRepresentation();
        input.orderSummaryId = orderSummaryId;
        
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [
            SELECT Id 
            FROM OrderDeliveryGroupSummary 
            WHERE OrderSummaryId = :orderSummaryId WITH SECURITY_ENFORCED];

        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = 
            SOM_TestDataFactoryHelper.getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: orderDeliveryGroupSummaryList) {
            input.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = location.Id;
            fulfillmentGroup.fulfillmentType = SOM_FulfillmentOrderType.WAREHOUSE.enumValue;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderDeliveryGroupSummary.Id);

            for(OrderItemSummary orderItemSummary : orderItemSummaryList) {
                ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                orderItemSummaryInputList.add(orderItemSummaryInput);
            }

            fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
            fulfillmentGroups.add(fulfillmentGroup);
            input.fulfillmentGroups = fulfillmentGroups;
        }

        Test.startTest();
        ConnectApi.FulfillmentOrderOutputRepresentation output = SOM_Services.fulfillmentOrder.createFulfillmentOrders(input);
        Test.stopTest();

        System.assert(output.success, 'Create fulfillment orders action is failed');

        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryId = :orderSummaryId];
        System.assert(!fulfillmentOrders.isEmpty(), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderService.createInvoice
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateInvoice() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];
       
        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        Test.startTest();
        ConnectApi.FulfillmentOrderInvoiceOutputRepresentation output = 
            SOM_Services.fulfillmentOrder.createInvoice(fulfillmentOrderId, new ConnectApi.FulfillmentOrderInvoiceInputRepresentation());
        Test.stopTest();

        System.assert(output.success, 'Create invoice action is failed');

        List<Invoice> invoices = [SELECT Id FROM Invoice WHERE Id = :output.invoiceId];
        System.assert(!invoices.isEmpty(), 'No invoice found');
    }

    /**
    * @description Test method of FulfillmentOrderService.createMultipleFulfillmentOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateMultipleFulfillmentOrder() {
        String order1Id = SOM_TestDataFactory.createOrderAction();
        String order2Id = SOM_TestDataFactory.createOrderAction();

        String orderSummary1Id = SOM_TestDataFactory.createOrderSummary(order1Id).Id;
        String orderSummary2Id = SOM_TestDataFactory.createOrderSummary(order2Id).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        ConnectApi.MultipleFulfillmentOrderInputRepresentation input = new ConnectApi.MultipleFulfillmentOrderInputRepresentation();
        input.fulfillmentOrders = new List<ConnectApi.FulfillmentOrderInputRepresentation>();

        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [
            SELECT OrderSummaryId
            FROM OrderDeliveryGroupSummary 
            WHERE OrderSummaryId = :orderSummary1Id
                OR OrderSummaryId = :orderSummary2Id
            WITH SECURITY_ENFORCED];

        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = 
            SOM_TestDataFactoryHelper.getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary : orderDeliveryGroupSummaryList) {
            // same as single fulfillment order creation
            // the difference is now the input for single
            // fulfillment order create input should be 
            // grouped in an input list
            ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
            fulfillmentOrderInput.orderSummaryId = orderDeliveryGroupSummary.OrderSummaryId;
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = location.Id;
            fulfillmentGroup.fulfillmentType = SOM_FulfillmentOrderType.WAREHOUSE.enumValue;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderDeliveryGroupSummary.Id);

            for(OrderItemSummary orderItemSummary : orderItemSummaryList) {
                ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                orderItemSummaryInputList.add(orderItemSummaryInput);
            }

            fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
            fulfillmentGroup.referenceId = orderDeliveryGroupSummary.Id;
            fulfillmentGroups.add(fulfillmentGroup);
            fulfillmentOrderInput.fulfillmentGroups = fulfillmentGroups;
            input.fulfillmentOrders.add(fulfillmentOrderInput);
        }

        Test.startTest();
        ConnectApi.MultipleFulfillmentOrderOutputRepresentation output = SOM_Services.fulfillmentOrder.createMultipleFulfillmentOrder(input);
        Test.stopTest();

        System.assert(output.success, 'Create multiple fulfillment order action is failed');

        List<FulfillmentOrder> fulfillmentOrders = [
            SELECT Id 
            FROM FulfillmentOrder 
            WHERE OrderSummaryId = :orderSummary1Id
                OR OrderSummaryId = :orderSummary2Id];
        
        System.assert(!fulfillmentOrders.isEmpty(), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderService.createMultipleInvoices
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateMultipleInvoices() {
        // same structure as multiple fulfillment order
        // additionally multiple invoices will be created
        String order1Id = SOM_TestDataFactory.createOrderAction();
        String order2Id = SOM_TestDataFactory.createOrderAction();

        String orderSummary1Id = SOM_TestDataFactory.createOrderSummary(order1Id).Id;
        String orderSummary2Id = SOM_TestDataFactory.createOrderSummary(order2Id).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        ConnectApi.MultipleFulfillmentOrderInputRepresentation input = new ConnectApi.MultipleFulfillmentOrderInputRepresentation();
        input.fulfillmentOrders = new List<ConnectApi.FulfillmentOrderInputRepresentation>();

        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [
            SELECT OrderSummaryId
            FROM OrderDeliveryGroupSummary 
            WHERE OrderSummaryId = :orderSummary1Id
                OR OrderSummaryId = :orderSummary2Id
            WITH SECURITY_ENFORCED];

        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = 
            SOM_TestDataFactoryHelper.getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary : orderDeliveryGroupSummaryList) {
            // same as single fulfillment order creation
            // the difference is now the input for single
            // fulfillment order create input should be 
            // grouped in an input list
            ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
            fulfillmentOrderInput.orderSummaryId = orderDeliveryGroupSummary.OrderSummaryId;
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = location.Id;
            fulfillmentGroup.fulfillmentType = SOM_FulfillmentOrderType.WAREHOUSE.enumValue;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderDeliveryGroupSummary.Id);

            for(OrderItemSummary orderItemSummary : orderItemSummaryList) {
                ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                orderItemSummaryInputList.add(orderItemSummaryInput);
            }

            fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
            fulfillmentGroup.referenceId = orderDeliveryGroupSummary.Id;
            fulfillmentGroups.add(fulfillmentGroup);
            fulfillmentOrderInput.fulfillmentGroups = fulfillmentGroups;
            input.fulfillmentOrders.add(fulfillmentOrderInput);
        }

        ConnectApi.MultipleFulfillmentOrderOutputRepresentation multipleFulfillmentOrderoutput = 
            SOM_Services.fulfillmentOrder.createMultipleFulfillmentOrder(input);

        // gather fulfillment order Ids
        // for multiple invoce create input
        List<String> fulfillmentOrderIds = new List<String>();
        for (ConnectApi.FulfillmentGroupOutputRepresentation fulfillmentOrder : multipleFulfillmentOrderoutput.fulfillmentOrders) {
            fulfillmentOrderIds.add(fulfillmentOrder.fulfillmentOrderId);
        }

        ConnectApi.MultipleFulfillmentOrderInvoicesInputRepresentation multipleInvoiceInput = new ConnectApi.MultipleFulfillmentOrderInvoicesInputRepresentation();
        multipleInvoiceInput.fulfillmentOrderIds = fulfillmentOrderIds;

        Test.startTest();
        ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation output = SOM_Services.fulfillmentOrder.createMultipleInvoices(multipleInvoiceInput);
        Test.stopTest();

        System.assert(output.success, 'Create invoice action is failed');

        List<Invoice> invoices = [SELECT Id FROM Invoice WHERE Id IN :output.invoiceIds];
        System.assert(!invoices.isEmpty(), 'No invoices found');
    }
}