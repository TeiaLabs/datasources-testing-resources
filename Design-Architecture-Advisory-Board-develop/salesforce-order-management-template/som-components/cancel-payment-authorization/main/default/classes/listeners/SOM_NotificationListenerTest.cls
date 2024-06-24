/**
 * @description Cancel payment authorization
 *      SOM notification listener test class
 */
@isTest
private class SOM_NotificationListenerTest {
    /**
     * @description Test method of SOM_NotificationListener.handlePost (positive, response pre-created)
     */
    @isTest
    static void shouldSuccess() {
        createResponse(SOM_Constants.HTTP_SUCCESS_CODE);

        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode, 'The Http status code should be 200');
    }

    /**
     * @description Test method of SOM_NotificationListener.handlePost (negative, response pre-created)
     */
    @isTest
    static void shouldFail() {
        createResponse(SOM_Constants.HTTP_INTERNAL_ERROR_CODE);

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode, 'The Http status code should be 500');
    }

    /**
     * @description Test method of SOM_NotificationListener.handlePost (negative, with empty request)
     */
    @isTest
    static void emptyRequestBody() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        response.statusCode = SOM_Constants.HTTP_SUCCESS_CODE;
        request.requestURI = '/services/apexrest/SOM_NotificationListener';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        System.assertEquals(null, RestContext.response.responseBody, 'Response body is null');
    }

    /**
     * @description Test method of SOM_NotificationListener.handlePost (positive, checks order 
     *  summary and payment authorization in the end)
     *      suppress reason: ConnectApi requires SeeAllData=true annotation
     */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void successfulCancelNotification() {
        Id orderSummaryId = makeData();

        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        setNotificationBody(getPaymentAuth(orderSummaryId), true);

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        OrderSummary order = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        PaymentAuthorization paymentAuthAfterExec = getPaymentAuth(orderSummaryId);
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED,
            order.CancelAuthorizationStatus__c,
            'flag should be updated on order summary'
        );
        System.assertEquals('Canceled', paymentAuthAfterExec.Status, 'Payment auth status should be Cancelled');
    }

    /**
     * @description Test method of SOM_NotificationListener.handlePost (negative, checks order
     *  summary and that number of attempts has increased)
     *      suppress reason: ConnectApi requires SeeAllData=true annotation
     */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void failCancelNotification() {
        Id orderSummaryId = makeData();

        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());

        OrderSummary prevOrder = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        setNotificationBody(getPaymentAuth(orderSummaryId), false);

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        OrderSummary order = [
            SELECT CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED,
            order.CancelAuthorizationStatus__c,
            'flag should be updated on order summary'
        );
        System.assertEquals(
            prevOrder.CancelAuthorizationRetryAttempts__c + 1,
            order.CancelAuthorizationRetryAttempts__c,
            'Failed attemp count should be increased'
        );
    }

    /**
     * @description Updates Order.CancelAuthorizationRetryAttempts__c
     * @param orderSummaryId Id of OrderSummary
     * @param tries Number of tries
     * @return Updated orderSummary record
     */
    static OrderSummary setOrderRetries(Id orderSummaryId, Decimal tries) {
        OrderSummary order = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        order.CancelAuthorizationRetryAttempts__c = tries;
        update order;
        return order;
    }

    /**
     * @description Test method of SOM_NotificationListener.handlePost (negative case, max attempts reached)
     *      suppress reason: ConnectApi requires SeeAllData=true annotation
     */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void failCancelNotificationWithMaxAttempts() {
        SOM_BatchConfiguration__mdt config = SOM_TestDataFactory.createSOMBatchConfigurationRecord();

        Id orderSummaryId = makeData();
        OrderSummary prevOrder = setOrderRetries(orderSummaryId, config.RetryCount__c - 1);

        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        setNotificationBody(getPaymentAuth(orderSummaryId), false);

        Test.startTest();
        SOM_NotificationListener.handlePost();
        Test.stopTest();

        OrderSummary order = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];
        List<ProcessException> exceptions = [
            SELECT Id
            FROM ProcessException
            WHERE Category = :SOM_Constants.Payment AND OrderSummaryId = :orderSummaryId
        ];

        System.assertEquals(
            SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED,
            order.CancelAuthorizationStatus__c,
            'flag should be updated on order summary'
        );
        System.assertEquals(
            prevOrder.CancelAuthorizationRetryAttempts__c + 1,
            order.CancelAuthorizationRetryAttempts__c,
            'Failed attemp count should be increased'
        );
        System.assertEquals(
            config.RetryCount__c,
            order.CancelAuthorizationRetryAttempts__c,
            'Max attempts count should be reached'
        );
        System.assertEquals(1, exceptions.size(), 'An exception for max attempt count should be created');
    }

    /**
     * @description Simulates the Notification body received by the listener
     * @param paymentAuthorization - PaymentAuthorization record
     * @param isSuccess - Boolean to indicate if the notification is a success or a failure
     */
    static void setNotificationBody(PaymentAuthorization paymentAuthorization, Boolean isSuccess) {
        SOM_CancelPaymentAuthNotification notification = new SOM_CancelPaymentAuthNotification();
        notification.live = SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notification.notificationItems = new List<SOM_CancelPaymentAuthNotification.NotificationItems>();
        SOM_CancelPaymentAuthNotification.NotificationRequestItem notificationRequestItem = new SOM_CancelPaymentAuthNotification.NotificationRequestItem();
        notificationRequestItem.eventCode = SOM_CancelPaymentAuthorizationConstants.EVENT_CANCELLATION;
        notificationRequestItem.success = isSuccess
            ? SOM_CancelPaymentAuthorizationConstants.TRUE_STRING
            : SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notificationRequestItem.merchantAccountCode = 'ECO_FR';
        notificationRequestItem.pspReference = SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE;
        notificationRequestItem.merchantReference = 'ORDER-12345';
        notificationRequestItem.originalReference = paymentAuthorization.GatewayRefNumber;
        SOM_CancelPaymentAuthNotification.AdditionalData additionalData = new SOM_CancelPaymentAuthNotification.AdditionalData();
        additionalData.paymentMethodVariant = 'visa';

        notificationRequestItem.amount = new SOM_CancelPaymentAuthNotification.Amount(29139);
        notificationRequestItem.additionalData = additionalData;

        notification.notificationItems.add(
            new SOM_CancelPaymentAuthNotification.NotificationItems(notificationRequestItem)
        );

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        response.statusCode = SOM_Constants.HTTP_SUCCESS_CODE;
        request.requestURI = '/services/apexrest/adyenNotify';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(notification));
        RestContext.request = request;
        RestContext.response = response;
    }

    /**
     * @description Creates the data necessary to run the test.
     * @return Id of the OrderSummary record created
     */
    private static Id makeData() {
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

        OrderSummary prevOrder = [
            SELECT OrderNumber, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c, Status
            FROM OrderSummary
            WHERE Id = :orderSummary.Id
        ];
        prevOrder.CancelAuthorizationStatus__c = SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_SENT;
        prevOrder.CancelAuthorizationRetryAttempts__c = 0;
        update prevOrder;

        return orderSummary.Id;
    }

    /**
     * @description Prepares Adyen Rest response
     * @param statusCode Adyen response status code
     */
    private static void createResponse(Integer statusCode) {
        SOM_CancelPaymentAuthNotification notification = new SOM_CancelPaymentAuthNotification();
        notification.notificationItems = new List<SOM_CancelPaymentAuthNotification.NotificationItems>();
        SOM_CancelPaymentAuthNotification.NotificationRequestItem notificationRequestItem = new SOM_CancelPaymentAuthNotification.NotificationRequestItem();
        SOM_CancelPaymentAuthNotification.AdditionalData additionalData = new SOM_CancelPaymentAuthNotification.AdditionalData();

        notification.live = SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        additionalData.hmacSignature = '1A2S3D1Q2W3E4R5T';
        notificationRequestItem.eventCode = SOM_CancelPaymentAuthorizationConstants.EVENT_CAPTURE;
        notificationRequestItem.success = SOM_CancelPaymentAuthorizationConstants.TRUE_STRING;
        notificationRequestItem.merchantAccountCode = 'CLOS19';
        notificationRequestItem.pspReference = SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE;
        notificationRequestItem.merchantReference = 'ORDER-12345';
        notificationRequestItem.originalReference = '1A2S3D4F5G';
        notificationRequestItem.amount = new SOM_CancelPaymentAuthNotification.Amount(29139);
        notificationRequestItem.additionalData = additionalData;
        notification.notificationItems.add(
            new SOM_CancelPaymentAuthNotification.NotificationItems(notificationRequestItem)
        );

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        response.statusCode = statusCode;
        request.requestURI = '/services/apexrest/SOM_NotificationListeners';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(notification));
        RestContext.request = request;
        RestContext.response = response;
    }

    static void setPaymentAuthorizationNotificationBody(
        PaymentAuthorization paymentAuthorization,
        Boolean isSuccess,
        String paymentMethod
    ) {
        SOM_CancelPaymentAuthNotification notification = new SOM_CancelPaymentAuthNotification();
        notification.notificationItems = new List<SOM_CancelPaymentAuthNotification.NotificationItems>();
        SOM_CancelPaymentAuthNotification.NotificationRequestItem notificationRequestItem = new SOM_CancelPaymentAuthNotification.NotificationRequestItem();
        SOM_CancelPaymentAuthNotification.AdditionalData additionalData = new SOM_CancelPaymentAuthNotification.AdditionalData();

        additionalData.paymentLinkId = 'T35TN0T1F1C4T10N';
        notification.live = SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notificationRequestItem.eventCode = SOM_CancelPaymentAuthorizationConstants.EVENT_AUTHORIZATION;
        notificationRequestItem.success = isSuccess
            ? SOM_CancelPaymentAuthorizationConstants.TRUE_STRING
            : SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notificationRequestItem.paymentMethod = paymentMethod;
        notificationRequestItem.merchantAccountCode = 'ECO_FR';
        notificationRequestItem.pspReference = SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE;
        notificationRequestItem.merchantReference = paymentAuthorization.OrderPaymentSummary.OrderSummary.OrderNumber;
        notificationRequestItem.originalReference = paymentAuthorization.GatewayRefNumber;
        notificationRequestItem.amount = new SOM_CancelPaymentAuthNotification.Amount(29139);
        notificationRequestItem.additionalData = additionalData;

        notification.notificationItems.add(
            new SOM_CancelPaymentAuthNotification.NotificationItems(notificationRequestItem)
        );

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        response.statusCode = SOM_Constants.HTTP_SUCCESS_CODE;
        request.requestURI = '/services/apexrest/adyenNotify';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(notification));
        RestContext.request = request;
        RestContext.response = response;
    }

    static void setPostponedNotificationBody(String orderNumber, Boolean isSuccess) {
        SOM_CancelPaymentAuthNotification notification = new SOM_CancelPaymentAuthNotification();
        notification.notificationItems = new List<SOM_CancelPaymentAuthNotification.NotificationItems>();
        SOM_CancelPaymentAuthNotification.NotificationRequestItem notificationRequestItem = new SOM_CancelPaymentAuthNotification.NotificationRequestItem();
        SOM_CancelPaymentAuthNotification.AdditionalData additionalData = new SOM_CancelPaymentAuthNotification.AdditionalData();

        additionalData.paymentLinkId = 'T35TN0T1F1C4T10N';
        notification.live = SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notificationRequestItem.eventCode = SOM_CancelPaymentAuthorizationConstants.EVENT_AUTHORIZATION;
        notificationRequestItem.success = isSuccess
            ? SOM_CancelPaymentAuthorizationConstants.TRUE_STRING
            : SOM_CancelPaymentAuthorizationConstants.FALSE_STRING;
        notificationRequestItem.paymentMethod = 'paypal';
        notificationRequestItem.merchantAccountCode = 'ECO_FR';
        notificationRequestItem.pspReference = SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE;
        notificationRequestItem.merchantReference = orderNumber;
        notificationRequestItem.originalReference = orderNumber;
        notificationRequestItem.amount = new SOM_CancelPaymentAuthNotification.Amount(29139);
        notificationRequestItem.additionalData = additionalData;

        notification.notificationItems.add(
            new SOM_CancelPaymentAuthNotification.NotificationItems(notificationRequestItem)
        );

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        response.statusCode = SOM_Constants.HTTP_SUCCESS_CODE;
        request.requestURI = '/services/apexrest/adyenNotify';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(notification));
        RestContext.request = request;
        RestContext.response = response;
    }

    static PaymentAuthorization getPaymentAuth(Id orderSummaryId) {
        List<PaymentAuthorization> paymentAuths = [
            SELECT Status, GatewayRefNumber
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