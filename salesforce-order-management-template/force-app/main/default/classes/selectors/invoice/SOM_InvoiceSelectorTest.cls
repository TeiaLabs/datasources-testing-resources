/**
* @description InvoiceSelector test class
*/
@isTest
public with sharing class SOM_InvoiceSelectorTest {
    /**
    * @description Test method of InvoiceSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [Select Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
       
        Test.startTest();
        List<Invoice> invoices = new SOM_InvoiceSelector().selectByIds(new List<String>{ invoiceId }, 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(invoices)).keySet();
        System.assert(resultIds.contains(invoiceId), 'No Invoice record(s) found');
    }

    /**
    * @description Test method of InvoiceSelector.selectByReferenceEntityIdsAndStatus
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByReferenceEntityIdsAndStatus() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [Select Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        Invoice invoice = [SELECT ReferenceEntityId FROM Invoice WHERE Id =: invoiceId];

        Test.startTest();
        List<Invoice> invoices = new SOM_InvoiceSelector().selectByReferenceEntityIdsAndStatus(new List<String>{ invoice.ReferenceEntityId }, 'Posted', 200);
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(invoices)).keySet();
        System.assert(resultIds.contains(invoiceId), 'No Invoice record(s) found');
    }
}
