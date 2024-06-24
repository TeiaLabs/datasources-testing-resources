/**
* @description OrderSummarySelector test class
*/
@isTest
private with sharing class SOM_OrderSummarySelectorTest {

    /**
    * @description Test method of OrderSummarySelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        
        Test.startTest();
        List<OrderSummary> orderSummaries = new SOM_OrderSummarySelector().selectByIds(new List<String>{ orderSummary.Id });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(orderSummaries)).keySet();
        System.assert(resultIds.contains(orderSummary.Id), 'No order summary record(s) found');
    }

    /**
    * @description Test method of OrderSummarySelector.selectOrderItemSummariesByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectOrderItemSummariesByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();

        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        
        Test.startTest();
        List<OrderItemSummary> orderItemSummaries = new SOM_OrderSummarySelector().selectOrderItemSummariesByOrderSummaryIds(new List<String>{ orderSummary.Id });
        Test.stopTest();

        System.assert(!orderItemSummaries.isEmpty(), 'No order item summary record(s) found');
    }

    /**
    * @description Test method of OrderSummarySelector.selectByStatusCategoryAndIsCriticalFieldsOfRelatedProcessException
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByRelatedProcessException() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        ProcessException processException = new ProcessException(OrderSummaryId = orderSummary.Id, AttachedToId = orderSummary.Id, 
        Message = 'Test', Priority = 'Low', Severity = 'High');
        insert processException;

        Test.startTest();
        List<OrderSummary> orderSummaries = new SOM_OrderSummarySelector().selectByStatusCategoryAndIsCriticalFieldsOfRelatedProcessException('ACTIVE', false, 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(orderSummaries)).keySet();
        System.assert(resultIds.contains(orderSummary.Id), 'No order summary record(s) found');
    }

    /**
    * @description Test method of OrderSummarySelector.selectByStatusAndLastModifiedDate
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByStatusAndLastModifiedDate() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
    
        Test.startTest();
        List<OrderSummary> orderSummaries = new SOM_OrderSummarySelector().selectByStatusAndLastModifiedDate('Approved', system.today().addDays(3), 'Fulfilled', system.today().addDays(5), system.today().addDays(6), 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(orderSummaries)).keySet();
        System.assert(resultIds.contains(orderSummary.Id), 'No order summary record(s) found');
    }
}