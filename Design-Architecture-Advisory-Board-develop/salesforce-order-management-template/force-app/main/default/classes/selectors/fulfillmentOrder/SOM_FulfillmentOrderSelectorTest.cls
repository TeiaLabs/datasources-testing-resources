/**
* @description FulfillmentOrderSelector test class
*/
@isTest
private class SOM_FulfillmentOrderSelectorTest {
    /**
    * @description Test method of FulfillmentOrderSelector.selectById
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummary.Id, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        Test.startTest();
        List<FulfillmentOrder> fulfillmentOrders = new SOM_FulfillmentOrderSelector().selectByIds(new List<String>{ fulfillmentOrderId });
        Test.stopTest();
        
        Set<Id> resultIds = (new Map<Id,SObject>(fulfillmentOrders)).keySet();
        System.assert(resultIds.contains(fulfillmentOrderId), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderSelector.selectByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummary.Id, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        Test.startTest();
        List<FulfillmentOrder> fulfillmentOrders = new SOM_FulfillmentOrderSelector().selectByOrderSummaryIds(new List<String>{ orderSummary.Id });
        Test.stopTest();

        Set<Id> resultIds = (new Map<Id,SObject>(fulfillmentOrders)).keySet();
        System.assert(resultIds.contains(fulfillmentOrderId), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderSelector.selectLineItemsByfulfillmentOrderIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectLineItemsByfulfillmentOrderIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummary.Id, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        Test.startTest();
        List<FulfillmentOrderLineItem> fulfillmentOrderLineItems = new SOM_FulfillmentOrderSelector().selectLineItemsByfulfillmentOrderIds(new List<String>{ fulfillmentOrderId });
        Test.stopTest();

        List<Id> fulfillmentOrderIds = new List<Id>();
        for(FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrderLineItems){
            fulfillmentOrderIds.add(fulfillmentOrderLineItem.FulfillmentOrderId);
        }

        System.assert(fulfillmentOrderIds.contains(fulfillmentOrderId), 'No fulfillment order line item record(s) found');
    }
}