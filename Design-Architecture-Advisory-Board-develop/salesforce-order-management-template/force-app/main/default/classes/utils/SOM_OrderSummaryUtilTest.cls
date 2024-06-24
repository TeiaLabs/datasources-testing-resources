/**
* @description OrderSummaryUtil test class 
*/
@isTest
private class SOM_OrderSummaryUtilTest {
    /**
    * @description OrderSummaryUtil.getDiscountableOrderItems 
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldGetDiscountableOrderItems() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        List<OrderItemSummary> orderItemSummaries = SOM_Selectors.orderSummary.selectOrderItemSummariesByOrderSummaryIds(new List<String>{ orderSummary.Id });

        List<OrderItemSummary> discountableOrderItems = SOM_OrderSummaryUtil.getDiscountableOrderItems(orderItemSummaries);

        System.assert(!discountableOrderItems.isEmpty(), 'No discountable item(s) found');        
    }

    /**
    * @description OrderSummaryUtil.getCancelableOrderItems 
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldGetCancelableOrderItems() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        List<OrderItemSummary> orderItemSummaries = SOM_Selectors.orderSummary.selectOrderItemSummariesByOrderSummaryIds(new List<String>{ orderSummary.Id });

        // no fulfillment order is created thus the order items
        // will be in ordered
        List<OrderItemSummary> cancelableOrderItems = SOM_OrderSummaryUtil.getCancelableOrderItems(orderItemSummaries);

        System.assert(!cancelableOrderItems.isEmpty(), 'No cancelable item(s) found');        
    }

    /**
    * @description OrderSummaryUtil.getReturnableOrderItems 
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldGetReturnableOrderItems() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummary.Id, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = SOM_Selectors.orderSummary.selectOrderItemSummariesByOrderSummaryIds(new List<String>{ orderSummary.Id });

        List<OrderItemSummary> returnableOrderItems = SOM_OrderSummaryUtil.getReturnableOrderItems(orderItemSummaries);

        System.assert(!returnableOrderItems.isEmpty(), 'No returnable item(s) found');        
    }
}