/**
 * @description Authorizantion cancel handler test class
 */
@IsTest
private class SOM_CancelAuthorizationHandlerTest {
    /**
     * @description Test cancel authorization positive test
     */
    @isTest(seeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void cancelAuthorization() {
        PaymentAuthorization auth = initializeAuthObject();
        insert auth;

        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        Test.startTest();
        List<SOM_CancelAuthorizationRequest> input = getCancelAuthorization(
            auth.Id,
            100
        );
        List<SOM_CancelAuthorizationResponse> output = SOM_CancelAuthorizationHandler.voidAuthorization(
            input
        );
        Test.stopTest();

        System.assert(!output.isEmpty(), 'Invocable method returned empty');
        System.assert(output[0].success, 'Success = false ' + output[0].failureMessage);
    }

    /**
     * @description Generate input request
     * @param paymentAuthorizationId payment authorization id
     * @param amount amount to void
     * @return List<SOM_CancelAuthorizationRequest>
     */
    private static List<SOM_CancelAuthorizationRequest> getCancelAuthorization(
        String paymentAuthorizationId,
        Decimal amount
    ) {
        SOM_CancelAuthorizationRequest input = new SOM_CancelAuthorizationRequest();
        input.amount = amount;
        input.paymentAuthorizationId = paymentAuthorizationId;
        return new List<SOM_CancelAuthorizationRequest>{ input };
    }

    /**
     * @description Initialize payment authorization object
     * @return PaymentAuthorization
     */
    private static PaymentAuthorization initializeAuthObject() {
        PaymentAuthorization auth = new PaymentAuthorization();
        auth.amount = 1500;
        auth.Status = 'Processed';
        auth.ProcessingMode = 'External';
        auth.GatewayRefNumber = 'testreferencenumber';
        auth.GatewayRefDetails = '{"method":"credit_card","transaction_id":"ET119982"}';
        list<paymentgateway> paymentGateway = [
            SELECT id
            FROM paymentgateway
            WHERE ExternalReference = :SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE
            LIMIT 1
        ];
        if (paymentGateway.size() > 0) {
            auth.paymentGatewayId = paymentGateway[0].Id;
        }

        return auth;
    }
}
