/**
* @description PaymentService test class
*/
@isTest
private class SOM_PaymentServiceTest {
    /**
    * @description Test method of PaymentService.createOrderPaymentSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateOrderSummary() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        SOM_TestDataInput.PaymentInput paymentInput = new SOM_TestDataInput.PaymentInput();
        paymentInput.amount = 100;
        paymentInput.status = SOM_PaymentStatus.PROCESSED.enumValue;
        paymentInput.type = SOM_PaymentType.CAPTURE.enumValue;
        Payment payment = SOM_TestDataFactory.createPayment(paymentInput);
        insert payment;

        ConnectApi.CreateOrderPaymentSummaryInputRepresentation input = new ConnectApi.CreateOrderPaymentSummaryInputRepresentation();
        input.orderSummaryId = orderSummaryId;
        input.paymentIds = new List<String>{ payment.Id };

        Test.startTest();
        ConnectApi.CreateOrderPaymentSummaryOutputRepresentation output = SOM_Services.payment.createOrderPaymentSummary(input);
        Test.stopTest();

        System.assert(output.success, 'Create order payment summary action is failed');
    }
}