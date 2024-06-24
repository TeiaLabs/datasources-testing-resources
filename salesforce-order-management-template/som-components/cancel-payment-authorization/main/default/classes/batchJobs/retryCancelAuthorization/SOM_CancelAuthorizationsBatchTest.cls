/**
 * @description  Cancel payment authorization
 *       test class of batch job for CancelAuthorization retry
 */
@isTest
private with sharing class SOM_CancelAuthorizationsBatchTest {
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
        orderSummary.CancelAuthorizationStatus__c = SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED;
        orderSummary.CancelAuthorizationRetryAttempts__c = 0;
        update orderSummary;

        Test.getEventBus().deliver();
        return orderSummary.Id;
    }

    /**
     * @description Tests the case when a retry event needs to be published
     */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldPublishEvent() {
        Id orderSummaryId = makeData();
        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());

        OrderSummary orderSummary = [
            SELECT OrderNumber, Status, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        orderSummary.CancelAuthorizationRetryAttempts__c = 4;
        update orderSummary;

        Test.startTest();
        SOM_CancelAuthorizationsBatch ba = new SOM_CancelAuthorizationsBatch('Cancel Authorization');
        ba.execute(null);

        Test.stopTest();
        String infoMessage =
            'Creating platform event record for sending cancel authorization request for order:' + orderSummaryId;
        SOM_Log__c logEntry = [
            SELECT Message__c
            FROM SOM_Log__c
            WHERE Category__c = 'Payment'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        System.assertEquals(infoMessage, logEntry.Message__c, 'Platform event should be created');
    }

    /**
     * @description Tests the case when a retry event needs to be published
     */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldNotPublishEventMaxAttempts() {
        Id orderSummaryId = makeData();
        Test.setMock(HttpCalloutMock.class, new SOM_CancelPaymentAuthRestSuccessMock());

        OrderSummary orderSummary = [
            SELECT OrderNumber, Status, CancelAuthorizationStatus__c, CancelAuthorizationRetryAttempts__c
            FROM OrderSummary
            WHERE Id = :orderSummaryId
        ];

        orderSummary.CancelAuthorizationRetryAttempts__c = 5;
        update orderSummary;

        Test.startTest();
        SOM_CancelAuthorizationsBatch ba = new SOM_CancelAuthorizationsBatch('Cancel Authorization');
        ba.execute(null);

        Test.stopTest();
        List<SOM_Log__c> logEntry = [
                SELECT Message__c
                FROM SOM_Log__c
                WHERE Category__c = 'Payment'
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];

        System.assertEquals(0, logEntry.size(), 'Platform event should not have been created');
    }
}
