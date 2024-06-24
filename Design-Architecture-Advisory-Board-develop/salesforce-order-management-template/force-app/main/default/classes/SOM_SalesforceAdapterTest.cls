/**
* @description Test class of SalesforceAdapter
*/
@isTest
private class SOM_SalesforceAdapterTest {
    /**
    * @description Test method of SalesforceAdapter capture
    *   suppress reason: Query PaymentGateway
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldCapture() {
        Double amount = 291.39;
        Id orderId = SOM_TestDataFactory.createOrderAction();

        SOM_TestDataInput.PaymentGroupInput paymentGroupInput = new SOM_TestDataInput.PaymentGroupInput();
        paymentGroupInput.sourceObjectId = orderId;
        PaymentGroup paymentGroup = SOM_TestDataFactory.createPaymentGroup(paymentGroupInput);
        insert paymentGroup;

        SOM_TestDataInput.PaymentAuthorizationInput paymentAuthorizationInput = new SOM_TestDataInput.PaymentAuthorizationInput();
        paymentAuthorizationInput.amount = amount;
        paymentAuthorizationInput.paymentGroupId = paymentGroup.Id;
        paymentAuthorizationInput.status = SOM_PaymentAuthorizationStatus.PROCESSED.enumValue;

        PaymentAuthorization paymentAuthorization = SOM_TestDataFactory.createPaymentAuthorization(paymentAuthorizationInput);
        insert paymentAuthorization;

        commercepayments.CaptureRequest captureRequest = new commercepayments.CaptureRequest(amount, paymentAuthorization.id);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            captureRequest,
            commercepayments.RequestType.Capture);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
    }

    /**
    * @description Test method of SalesforceAdapter refund
    *   suppress reason: Query PaymentGateway
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldRefund() {
        Double amount = 291.39;
        Id orderId = SOM_TestDataFactory.createOrderAction();

        SOM_TestDataInput.PaymentGroupInput paymentGroupInput = new SOM_TestDataInput.PaymentGroupInput();
        paymentGroupInput.sourceObjectId = orderId;
        PaymentGroup paymentGroup = SOM_TestDataFactory.createPaymentGroup(paymentGroupInput);
        insert paymentGroup;

        SOM_TestDataInput.PaymentAuthorizationInput paymentAuthorizationInput = new SOM_TestDataInput.PaymentAuthorizationInput();
        paymentAuthorizationInput.amount = amount;
        paymentAuthorizationInput.paymentGroupId = paymentGroup.Id;
        paymentAuthorizationInput.status = SOM_PaymentAuthorizationStatus.PROCESSED.enumValue;
        PaymentAuthorization paymentAuthorization = SOM_TestDataFactory.createPaymentAuthorization(paymentAuthorizationInput);
        insert paymentAuthorization;

        commercepayments.ReferencedRefundRequest refundRequest = new commercepayments.ReferencedRefundRequest(amount, paymentAuthorization.id);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            refundRequest,
            commercepayments.RequestType.ReferencedRefund);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
    }

    /**
    * @description Test method of SalesforceAdapter sale
    */
    @isTest
    static void shouldSale() {
        commercepayments.SaleRequest saleRequest = new commercepayments.SaleRequest((Double)291.39);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            saleRequest,
            commercepayments.RequestType.Sale);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
    }

    /**
    * @description Test method of SalesforceAdapter authorization
    */
    @isTest
    static void shouldAuthorize() {
        commercepayments.AuthorizationRequest authRequest = new commercepayments.AuthorizationRequest((Double)291.39);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            authRequest,
            commercepayments.RequestType.Authorize);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
    }

    /**
    * @description Test method of SalesforceAdapter tokenize
    */
    @isTest
    static void shouldTokenize() {
        commercepayments.PaymentMethodTokenizationRequest tokenRequest = null;
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            tokenRequest,
            commercepayments.RequestType.Tokenize);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
    }
    
    /**
    * @description Test method of SalesforceAdapter tokenize
    */
    @isTest(seeAllData=True)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldAuthReversal() {
        Double amount = 291.39;
        Id orderId = SOM_TestDataFactory.createOrderAction();

        SOM_TestDataInput.PaymentGroupInput paymentGroupInput = new SOM_TestDataInput.PaymentGroupInput();
        paymentGroupInput.sourceObjectId = orderId;
        PaymentGroup paymentGroup = SOM_TestDataFactory.createPaymentGroup(paymentGroupInput);
        insert paymentGroup;

        SOM_TestDataInput.PaymentAuthorizationInput paymentAuthorizationInput = new SOM_TestDataInput.PaymentAuthorizationInput();
        paymentAuthorizationInput.amount = amount;
        paymentAuthorizationInput.paymentGroupId = paymentGroup.Id;
        paymentAuthorizationInput.status = SOM_PaymentAuthorizationStatus.PROCESSED.enumValue;
        PaymentAuthorization paymentAuthorization = SOM_TestDataFactory.createPaymentAuthorization(paymentAuthorizationInput);
        insert paymentAuthorization;

       commercepayments.AuthorizationReversalRequest authReversalRequest = new commercepayments.AuthorizationReversalRequest((Double)291.39, paymentAuthorization.Id);
       commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
        authReversalRequest,
            commercepayments.RequestType.AuthorizationReversal);

        Test.startTest();
        SOM_SalesforceAdapter adapter = new SOM_SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response should not be null');
        System.assert(!(response instanceof commercepayments.GatewayErrorResponse), 'Gateway error response');
    }
}