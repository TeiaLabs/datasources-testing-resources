/**
* @description ProcessExceptionSelector test class
*/
@isTest
public with sharing class SOM_ProcessExceptionSelectorTest {
    /**
    * @description Test method of ProcessExceptionSelector.selectByCategoryStatusAndMessage
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldselectByCategoryStatusAndMessage() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [Select Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        ProcessException processException = new ProcessException(AttachedToId= invoiceId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment');
        insert processException;
        
        Test.startTest();
        List<ProcessException> processExceptions = new SOM_ProcessExceptionSelector().selectByCategoryStatusAndMessage('Payment', 'New', new List<String>{ 'Unable to Apply Payment' }, 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(processExceptions)).keySet();
        System.assert(resultIds.contains(processException.Id), 'No process exception record(s) found');
    }

    /**
    * @description Test method of ProcessExceptionSelector.selectByOrderSummaryIdStatusAndIsCritical
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldselectByOrderSummaryIdStatusAndIsCritical() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [Select Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        ProcessException processException = new ProcessException(OrderSummaryId = orderSummary.Id, AttachedToId= invoiceId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment');
        insert processException;
        
        Test.startTest();
        List<ProcessException> processExceptions = new SOM_ProcessExceptionSelector().selectByOrderSummaryIdStatusAndIsCritical(new List<Id>{orderSummary.Id}, new List<String>{'New'}, false, 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(processExceptions)).keySet();
        System.assert(resultIds.contains(processException.Id), 'No process exception record(s) found');
    }

    /**
    * @description Test method of ProcessExceptionSelector.SelectByAttachedToIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByAttachedToIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        ProcessException processException = new ProcessException(AttachedToId = orderSummaryId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', Description= 'Unable to capture payment  of $251.61.');    
        insert processException;
    
        Test.startTest();
        List<ProcessException> processExceptions = new SOM_ProcessExceptionSelector().selectByAttachedToIds(new List<String>{String.valueOf(orderSummaryId)});
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(processExceptions)).keySet();
        System.assert(resultIds.contains(processException.Id), 'No process exception record(s) found');
    }
}