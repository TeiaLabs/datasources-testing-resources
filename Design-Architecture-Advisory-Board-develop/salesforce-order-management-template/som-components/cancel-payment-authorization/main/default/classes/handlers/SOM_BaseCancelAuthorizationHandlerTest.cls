/**
 * @description Cancel authorizations handler test
 */
@isTest
private class SOM_BaseCancelAuthorizationHandlerTest {
    /**
     * @description test setup method for SOM_BaseCancelAuthorizationHandlerTest, SOM_AdyenAuthorizationCancelHandlerTest
     * @return Id of created order summary
     */
    private static Id makeData() {
        //prepare test data and update order summary status
        Map<String, String> testDataOptions = new Map<String, String>
        {
            SOM_TestDataInputOptions.CREATE_PAYMENT_GATEWAY => 'true'
        };
        
        String orderId = SOM_TestDataFactory.createOrderAction(testDataOptions);
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);

        PaymentGateway gateway = [
            SELECT Id
            FROM PaymentGateway
            WHERE ExternalReference = :SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE
        ];
        SOM_TestDataFactory.createPaymentAuthHistory(orderId, orderSummary.Id, Double.valueOf(100), gateway.Id, false);

        orderSummary.Status = SOM_OrderSummaryStatus.CANCELLED.toString();
        update orderSummary;
        Test.getEventBus().deliver();
        return orderSummary.Id;
    }

    //  suppress reason: ConnectApi requires SeeAllData=true annotation
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(seeAllData=true)
    static void handleCancelRequestOnly() {
        Id orderSummaryId = makeData();
        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        List<PaymentAuthorization> authorizations = [
            SELECT
                Id,
                GatewayRefNumber,
                OrderPaymentSummary.OrderSummary.OrderNumber,
                PaymentGateway.ExternalReference,
                OrderPaymentSummary.OrderSummaryId
            FROM PaymentAuthorization
            WHERE OrderPaymentSummary.OrderSummaryId = :orderSummaryId
        ];

        List<Id> param = new List<Id>{ orderSummaryId };
        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        Test.stopTest();
        OrderSummary order = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        System.assertNotEquals(0, authorizations.size(), 'Authorizations should not be empty');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_SENT,
            order.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Sent'
        );
    }

    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void handleCancelResponseSuccess() {
        Id orderSummaryId = makeData();

        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        PaymentAuthorization authorization = getPaymentAuth(orderSummaryId);
        boolean success = true;
        List<Id> param = new List<Id>{ orderSummaryId };
        SOM_CancelPaymentAuthNotification notification = SOM_CancelPaymentAuthNotification.createTestData();

        List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
        Map<String, Boolean> request = new Map<String, Boolean>();
        request.put(authorization.GatewayRefNumber, success);
        requests.add(request);

        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, notification.notificationItems[0]);
        Test.stopTest();
        OrderSummary orderSummaryAfter = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        PaymentAuthorization authorizationAfter = getPaymentAuth(orderSummaryId);
        System.assertNotEquals(null, authorization, 'Authorization should not be null');
        System.assertNotEquals(null, authorizationAfter, 'Authorization after processing should not be null');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED,
            orderSummaryAfter.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Released'
        );
        System.assertEquals(
            SOM_Constants.CANCELED,
            authorizationAfter.status,
            'Payment Authorization status should be set to Canceled'
        );
        System.assertEquals(
            0,
            orderSummaryAfter.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 0'
        );
    }

    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void handleCancelResponseSuccessMultipleRequests() {
        Id orderSummaryId = makeData();
        PaymentAuthorization authorization = getPaymentAuth(orderSummaryId);
        Id orderSummaryId2 = makeData();
        PaymentAuthorization authorization2 = getPaymentAuth(orderSummaryId2);
        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        boolean success = true;
        List<Id> param = new List<Id>{ orderSummaryId };
        SOM_CancelPaymentAuthNotification notification = SOM_CancelPaymentAuthNotification.createTestData();

        List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
        Map<String, Boolean> request = new Map<String, Boolean>();
        request.put(authorization.GatewayRefNumber, success);
        request.put(authorization2.GatewayRefNumber, success);
        requests.add(request);

        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, notification.notificationItems[0]);
        Test.stopTest();
        OrderSummary orderSummaryAfter = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        PaymentAuthorization authorizationAfter = getPaymentAuth(orderSummaryId);
        OrderSummary orderSummaryAfter2 = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId2
        ];

        PaymentAuthorization authorizationAfter2 = getPaymentAuth(orderSummaryId2);
        System.assertNotEquals(null, authorization, 'Authorization should not be null');
        System.assertNotEquals(null, authorizationAfter, 'Authorization after processing should not be null');
        System.assertNotEquals(null, authorization2, 'Authorization 2nd record should not be null');
        System.assertNotEquals(
            null,
            authorizationAfter2,
            'Authorization 2nd record after processing should not be null'
        );
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED,
            orderSummaryAfter.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Released'
        );
        System.assertEquals(
            SOM_Constants.CANCELED,
            authorizationAfter.status,
            'Payment Authorization status should be set to Canceled'
        );
        System.assertEquals(
            0,
            orderSummaryAfter.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 0'
        );

        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED,
            orderSummaryAfter2.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c 2nd record should be set to Request Released'
        );
        System.assertEquals(
            SOM_Constants.CANCELED,
            authorizationAfter2.status,
            'Payment Authorization status 2nd record should be set to Canceled'
        );
        System.assertEquals(
            0,
            orderSummaryAfter2.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c 2nd record should be set to 0'
        );
    }

    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void handleCancelResponseMultipleRequestsMixed() {
        Id orderSummaryId = makeData();
        PaymentAuthorization authorization = getPaymentAuth(orderSummaryId);
        Id orderSummaryId2 = makeData();
        PaymentAuthorization authorization2 = getPaymentAuth(orderSummaryId2);
        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        List<Id> param = new List<Id>{ orderSummaryId };
        SOM_CancelPaymentAuthNotification notification = SOM_CancelPaymentAuthNotification.createTestData();

        List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
        Map<String, Boolean> request = new Map<String, Boolean>();
        request.put(authorization.GatewayRefNumber, true);
        request.put(authorization2.GatewayRefNumber, false);
        requests.add(request);

        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, notification.notificationItems[0]);
        Test.stopTest();
        OrderSummary orderSummaryAfter = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        PaymentAuthorization authorizationAfter = getPaymentAuth(orderSummaryId);
        OrderSummary orderSummaryAfter2 = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId2
        ];

        System.assertNotEquals(null, authorization, 'Authorization should not be null');
        System.assertNotEquals(null, authorizationAfter, 'Authorization after processing should not be null');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED,
            orderSummaryAfter.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Released'
        );
        System.assertEquals(
            SOM_Constants.CANCELED,
            authorizationAfter.status,
            'Payment Authorization status should be set to Canceled'
        );
        System.assertEquals(
            0,
            orderSummaryAfter.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 0'
        );

        System.assertNotEquals(null, authorization2, 'Authorization should not be null');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED,
            orderSummaryAfter2.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Failed'
        );
        System.assertEquals(
            1,
            orderSummaryAfter2.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 1'
        );
    }

    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void handleCancelResponseFailure() {
        Id orderSummaryId = makeData();

        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        PaymentAuthorization authorization = getPaymentAuth(orderSummaryId);
        boolean failure = false;
        List<Id> param = new List<Id>{ orderSummaryId };
        SOM_CancelPaymentAuthNotification notification = SOM_CancelPaymentAuthNotification.createTestData();
        List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
        Map<String, Boolean> request = new Map<String, Boolean>();
        request.put(authorization.GatewayRefNumber, failure);
        requests.add(request);
        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, notification.notificationItems[0]);
        Test.stopTest();
        OrderSummary orderSummaryAfter = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        System.assertNotEquals(null, authorization, 'Authorization should not be null');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED,
            orderSummaryAfter.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Failed'
        );
        System.assertEquals(
            1,
            orderSummaryAfter.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 1'
        );
    }

    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void handleCancelResponseFailureLimitRetries() {
        Id orderSummaryId = makeData();

        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());
        PaymentAuthorization authorization = getPaymentAuth(orderSummaryId);

        OrderSummary orderSummary = [
            SELECT OrderNumber, Status, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        orderSummary.CancelAuthorizationRetryAttempts__c = 4;
        update orderSummary;

        boolean failure = false;
        List<Id> param = new List<Id>{ orderSummaryId };
        SOM_CancelPaymentAuthNotification notification = SOM_CancelPaymentAuthNotification.createTestData();
        List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
        Map<String, Boolean> request = new Map<String, Boolean>();
        request.put(authorization.GatewayRefNumber, failure);
        requests.add(request);
        Test.startTest();
        SOM_BaseCancelAuthorizationHandler.handleCancelRequest(param);
        SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, notification.notificationItems[0]);
        Test.stopTest();
        OrderSummary orderSummaryAfter = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        List<ProcessException> processExceptionList = [
            SELECT Id
            FROM ProcessException
            WHERE OrderSummaryId = :orderSummaryId AND Category = 'Payment'
        ];

        System.assertNotEquals(null, authorization, 'Authorization should not be null');
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED,
            orderSummaryAfter.CancelAuthorizationStatus__c,
            'CancelAuthorizationStatus__c should be set to Request Failed'
        );
        System.assertEquals(
            5,
            orderSummaryAfter.CancelAuthorizationRetryAttempts__c,
            'CancelAuthorizationRetryAttempts__c should be set to 5'
        );
        System.assertEquals(1, processExceptionList.size(), 'Process Exception should have been created');
    }

    static PaymentAuthorization getPaymentAuth(Id orderSummaryId) {
        List<PaymentAuthorization> paymentAuths = [
            SELECT
                Id,
                GatewayRefNumber,
                Status,
                OrderPaymentSummary.OrderSummary.OrderNumber,
                PaymentGateway.ExternalReference,
                OrderPaymentSummary.OrderSummaryId
            FROM PaymentAuthorization
            WHERE OrderPaymentSummary.OrderSummaryId = :orderSummaryId
        ];
        // some incomplete payment authorization may have been added too early
        // always get the last one
        // TODO: fix this. Have one and only one payment authorization
        if (paymentAuths != null && paymentAuths.size() > 0) {
            return paymentAuths[paymentAuths.size() - 1];
        }
        throw new SOM_ApplicationException('No payment authorization for order summary  ' + orderSummaryId);
    }
}
