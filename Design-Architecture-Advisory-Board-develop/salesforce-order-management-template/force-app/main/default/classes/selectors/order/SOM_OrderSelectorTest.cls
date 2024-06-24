/**
* @description Order Selector test class
*/
@isTest
public with sharing class SOM_OrderSelectorTest {

    /**
    * @description Test method of OrderSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        Test.startTest();
        List<Order> originalOrders = new SOM_OrderSelector().selectByIds(new List<String>{ orderId });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(originalOrders)).keySet();
        System.assert(resultIds.contains(orderId), 'No original order record(s) found');
    }

    /**
    * @description Test method of OrderSelector.selectByRelatedOrderIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectByRelatedOrderIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        Order order = [SELECT OriginalOrderId FROM Order LIMIT 1];
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        Test.startTest();
        List<Order> relatedOrders = new SOM_OrderSelector().selectByRelatedOrderIds(new List<String>{order.OriginalOrderId});
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(relatedOrders)).keySet();
        System.assert(resultIds.contains(orderId), 'No related order record(s) found');
    }
}
