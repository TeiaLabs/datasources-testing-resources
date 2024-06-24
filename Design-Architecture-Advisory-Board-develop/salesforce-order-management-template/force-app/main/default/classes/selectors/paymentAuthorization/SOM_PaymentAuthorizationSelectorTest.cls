/**
* @description PaymentAuthorizationSelector test class
*/
@isTest
public with sharing class SOM_PaymentAuthorizationSelectorTest {
    /**
    * @description Test method of PaymentAuthorizationSelector.selectByIds
    */
    @isTest
    static void shouldSelectByIds() {
        PaymentAuthorization payAuth = new PaymentAuthorization();
        payAuth.Amount = 100;
        payAuth.status = SOM_PaymentAuthorizationStatus.DRAFT.toString();
        payAuth.ProcessingMode = SOM_ProcessingMode.EXTERNAL.toString();
        insert payAuth;
       
        Test.startTest();
        List<PaymentAuthorization> payments = new SOM_PaymentAuthorizationSelector().selectByIds(new List<String>{ payAuth.Id });
        Test.stopTest();

        System.assert(!payments.isEmpty(), 'No payment authorization record(s) found');
    }

    /**
    * @description Test method of PaymentAuthorizationSelector.shouldSelectByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        OrderPaymentSummary orderPaymentSummary = new OrderPaymentSummary();
        orderPaymentSummary.OrderSummary = orderSummary;
        orderPaymentSummary.type = 'test';
        orderPaymentSummary.method = 'test';
        orderPaymentSummary.orderSummaryId  = orderSummary.Id;
        insert orderPaymentSummary;

        PaymentAuthorization payAuth = new PaymentAuthorization();
        payAuth.Amount = 100;
        payAuth.status = SOM_PaymentAuthorizationStatus.DRAFT.toString();
        payAuth.ProcessingMode = SOM_ProcessingMode.EXTERNAL.toString();
        payAuth.OrderPaymentSummaryId = orderPaymentSummary.id;
        payAuth.GatewayRefNumber = 'test';
        insert payAuth;

        Test.startTest();
        List<PaymentAuthorization> payments = new SOM_PaymentAuthorizationSelector().selectByOrderSummaryIds(new Set<Id>{ orderSummary.id });
        Test.stopTest();

        System.assert(!payments.isEmpty(), 'No payment record(s) found');
    }
}