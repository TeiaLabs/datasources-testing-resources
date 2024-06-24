/**
 * @description Retry jobs for payment capture
 */
@isTest
private with sharing class SOM_RetryPaymentsBatchTest {
    static final String STATUS_RETRY_COUNT_GREATER_THAN_CONFIGURATION = 'Manual Intervention Required';
    static final String STATUS_RESOLVED = 'Resolved';
    /**
    * @description Tests the case of AttachedToId object type is Invoice and the Invoice number of retries is less than the configuration
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testAttachedToInvoice() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        Sobject location = [SELECT Id FROM Location LIMIT 1];

        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);

        ProcessException processException = new ProcessException(AttachedToId= invoiceId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', Description= 'Unable to capture payment  of $361.61.');
        insert processException;

        Test.startTest();
        SOM_RetryPaymentsBatch ba = new SOM_RetryPaymentsBatch('RetryPayments');
        ba.execute(NULL);
        Test.stopTest();

        ProcessException updatedProcessException = [SELECT Status, OrderSummaryId FROM ProcessException WHERE Id =: processException.Id];
        Invoice updatedInvoice = [SELECT ReferenceEntityId, Balance, NumberOfRetries__c FROM Invoice WHERE Id =: invoiceId];
        System.assertEquals(STATUS_RESOLVED, updatedProcessException.Status, 'Proces Exception should be Resolved');
        System.assertEquals(1, updatedInvoice.NumberOfRetries__c, 'Number of Retries should be incremented');
        System.assertEquals(updatedProcessException.OrderSummaryId, updatedInvoice.ReferenceEntityId, 'OrderSummary field should be filled with Referenced Entity of Invoice');
    }
    /**
    * @description Tests the case of AttachedToId object type is Payment and the Invoice number of retries is less than the configuration
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testAttachedToPayment() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [SELECT Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        Invoice invoice = [SELECT Balance FROM Invoice WHERE Id =: invoiceId];
        invoice.ReferenceEntityId = orderSummary.Id;
        update invoice;

        FulfillmentOrder fulfillmentOrder = [SELECT GrandTotalAmount FROM FulfillmentOrder WHERE Id =: listFulfillmentOrders[0].Id];
        SOM_TestDataInput.PaymentInput paymentInput = new SOM_TestDataInput.PaymentInput();
        paymentInput.status = SOM_PaymentStatus.PROCESSED.enumValue;
        paymentInput.type = SOM_PaymentType.CAPTURE.enumValue;
        paymentInput.amount = 2;
        Payment payment = SOM_TestDataFactory.createPayment(paymentInput);
        insert payment;

        ProcessException processException = new ProcessException(AttachedToId = payment.Id, OrderSummaryId = orderSummary.Id, 
            Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', 
            Description= 'Unable to capture payment  of $'+ String.valueof(fulfillmentOrder.GrandTotalAmount) + '.');
        insert processException;

        Test.startTest();
        SOM_RetryPaymentsBatch ba= new SOM_RetryPaymentsBatch('RetryPayments');
        ba.execute(NULL);
        Test.stopTest();

        ProcessException updatedProcessException = [SELECT Status FROM ProcessException WHERE Id =: processException.Id];
        Invoice updatedInvoice = [SELECT NumberOfRetries__c FROM Invoice WHERE Id =: invoice.Id];
        System.assertEquals(STATUS_RESOLVED, updatedProcessException.Status, 'Process exception should be resolved');
        System.assertEquals(1, updatedInvoice.NumberOfRetries__c, 'Number of retries should be incremented');
    }
    /**
    * @description Tests the case of AttachedToId object type is Order Payment Summary and the Invoice number of retries is less than the configuration
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testAttachedToOrderPaymentSummary() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [SELECT Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        Invoice invoice = [SELECT Balance FROM Invoice WHERE Id =: invoiceId];
        invoice.ReferenceEntityId = orderSummary.Id;
        update invoice;
        OrderPaymentSummary orderPaymentSummary = [SELECT Id FROM OrderPaymentSummary WHERE OrderSummaryId =: orderSummary.Id LIMIT 1];
        FulfillmentOrder fulfillmentOrder = [SELECT GrandTotalAmount FROM FulfillmentOrder WHERE Id =: listFulfillmentOrders[0].Id];
        ProcessException processException = new ProcessException(AttachedToId = orderPaymentSummary.Id, OrderSummaryId = orderSummary.Id, 
            Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', 
            Description= 'Unable to capture payment  of $'+ String.valueof(fulfillmentOrder.GrandTotalAmount) + '.');
        insert processException;

        Test.startTest();
        SOM_RetryPaymentsBatch ba = new SOM_RetryPaymentsBatch('RetryPayments');
        ba.execute(null);
        Test.stopTest();

        ProcessException updatedProcessException = [SELECT Status FROM ProcessException WHERE Id =: processException.Id];
        Invoice updatedInvoice = [SELECT NumberOfRetries__c FROM Invoice WHERE Id =: invoice.Id];
        System.assertEquals(STATUS_RESOLVED, updatedProcessException.Status, 'Process exception should be resolved');
        System.assertEquals(1, updatedInvoice.NumberOfRetries__c, 'Number of retries should be incremented');
    }
    /**
    * @description Tests the case of AttachedToId object type is Invoice and the Invoice number of retries is greater than the configuration
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testRetryCountGreaterThanConfiguration() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        Sobject location = [SELECT Id FROM Location LIMIT 1];
        List<FulfillmentOrder> listFulfillmentOrders = SOM_TestDataFactory.createFulfillmentOrders(String.valueOf(orderSummary.Id), String.valueOf(location.Id), SOM_FulfillmentOrderType.values()[0]);
        String invoiceId = SOM_TestDataFactory.createInvoice(listFulfillmentOrders[0].Id);
        Invoice invoice = [SELECT Id FROM Invoice WHERE Id =: invoiceId];
        invoice.NumberOfRetries__c = 10;
        update invoice;
        ProcessException processException = new ProcessException(AttachedToId= invoiceId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', Description= 'Unable to capture payment  of $361.61.');
        insert processException;

        Test.startTest();
        SOM_RetryPaymentsBatch ba= new SOM_RetryPaymentsBatch('RetryPayments');
        ba.execute(NULL);
        Test.stopTest();

        ProcessException updatedProcessException = [SELECT Status, OrderSummaryId FROM ProcessException WHERE Id =: processException.Id];
        System.assertEquals(STATUS_RETRY_COUNT_GREATER_THAN_CONFIGURATION, updatedProcessException.Status, 'Status field should be Manual Intervention Required');
    }
}