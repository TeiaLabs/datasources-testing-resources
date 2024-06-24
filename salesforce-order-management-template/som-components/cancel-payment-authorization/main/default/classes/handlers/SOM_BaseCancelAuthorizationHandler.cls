/**
 * @description Cancel payment authorization
 *      Base Class for CancelAuthorization handlers
 *  suppress reason : TODO refactor
 */
@suppressWarnings('PMD.StdCyclomaticComplexity')
public without sharing class SOM_BaseCancelAuthorizationHandler {
    /**
     * @description Redirects authorizations to related cancel handler according to payment gateway
     * @param orderSummaryIds order summaries to cancel authorizations
     */
    @InvocableMethod(label='Cancel authorizations' description='Cancels authorizations of given order summaries')
    public static void handleCancelRequest(List<Id> orderSummaryIds) {
        if (orderSummaryIds != null && !orderSummaryIds.isEmpty()) {
            // Validates that there is a Payment Authorization value remaining to be released.
            // If there is some, use that amount for processing.
            Map<Id, OrderSummary> orderSummaries = new Map<Id, OrderSummary>(
                [
                    SELECT
                        OrderNumber,
                        Status,
                        CancelAuthorizationRetryAttempts__c,
                        CancelAuthorizationStatus__c,
                        SalesChannel.MerchantAccountId__c
                    FROM OrderSummary
                    WHERE
                        ID IN :orderSummaryIds
                        AND ID IN (SELECT OrderSummaryId FROM OrderPaymentSummary WHERE CapturedAmount = 0)
                ]
            );

            Map<String, List<PaymentAuthorization>> authorizations = getAuthorizationsByOrderSummaryIds(
                orderSummaries.keySet()
            );
            for (String key : authorizations.keySet()) {
                if (key == SOM_CancelPaymentAuthorizationConstants.ADYEN_COMPONENT) {
                    SOM_AdyenAuthorizationCancelHandler.handle(authorizations.get(key), orderSummaries);
                } else {
                    if (
                        Test.isRunningTest() &&
                        key == SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE
                    ) {
                        SOM_AdyenAuthorizationCancelHandler.handle(authorizations.get(key), orderSummaries);
                    }
                }
            }
        }
    }

    private static Map<String, List<PaymentAuthorization>> getAuthorizationsByOrderSummaryIds(Set<Id> orderSummaryIds) {
        Map<String, List<PaymentAuthorization>> result = new Map<String, List<PaymentAuthorization>>();
        List<PaymentAuthorization> items = SOM_Selectors.PaymentAuthorization.selectByOrderSummaryIds(orderSummaryIds);

        for (PaymentAuthorization item : items) {
            if (!result.containsKey(item.PaymentGateway.ExternalReference)) {
                result.put(item.PaymentGateway.ExternalReference, new List<PaymentAuthorization>());
            }
            result.get(item.PaymentGateway.ExternalReference).add(item);
        }

        return result;
    }

    /**
     * @description Cancel authorization from an async request
     *  suppress reason : TODO refactor & Adyen Guess profile issue
     * @param requests List of Maps, where key is the Payment authorization gateway reference number and value is cancel authorization result
     * @param item Notification item
     */
    @suppressWarnings('PMD.CyclomaticComplexity, PMD.ApexCRUDViolation')
    public static void handleCancelResponse(
        List<Map<String, Boolean>> requests,
        SOM_CancelPaymentAuthNotification.NotificationItems item
    ) {
        boolean notificationStatus = false;
        Decimal maxRetryCount = getMaxRetryCount();
        Map<String, Boolean> allRequests = new Map<String, Boolean>();
        List<ProcessException> processExceptionToInsert = new List<ProcessException>();
        List<OrderSummary> orderSummaryToUpdate = new List<OrderSummary>();
        List<PaymentAuthorization> paymentAuthorizationToUpdate = new List<PaymentAuthorization>();
        List<PaymentGatewayLog> paymentGatewayLogToInsert = new List<PaymentGatewayLog>();

        for (Map<String, Boolean> request : requests) {
            for (String gatewayRefNumber : request.keySet()) {
                allRequests.put(gatewayRefNumber, request.get(gatewayRefNumber));
            }
        }
        Set<String> gatewayRefNumbers = allRequests.keySet();
        List<PaymentAuthorization> authorizations = [
            SELECT
                Id,
                GatewayRefNumber,
                PaymentGatewayId,
                OrderPaymentSummary.Id,
                OrderPaymentSummary.OrderSummaryId,
                OrderPaymentSummary.OrderSummary.OrderNumber,
                OrderPaymentSummary.OrderSummary.CancelAuthorizationStatus__c,
                OrderPaymentSummary.OrderSummary.CancelAuthorizationRetryAttempts__c
            FROM PaymentAuthorization
            WHERE Status != :SOM_Constants.CANCELED AND GatewayRefNumber IN :gatewayRefNumbers
        ];

        for (PaymentAuthorization authorization : authorizations) {
            notificationStatus = allRequests.get(authorization.GatewayRefNumber);
            processSingleCancelRequest(
                authorization,
                processExceptionToInsert,
                orderSummaryToUpdate,
                paymentAuthorizationToUpdate,
                notificationStatus,
                maxRetryCount
            );
            paymentGatewayLogToInsert.add(
                new PaymentGatewayLog(
                    InteractionType = 'AuthorizationReversal',
                    IsNotification = 'Yes',
                    OrderPaymentSummaryId = authorization.OrderPaymentSummary.Id,
                    ReferencedEntityId = authorization.Id,
                    Request = JSON.serialize(item),
                    SfResultCode = (notificationStatus ? 'Success' : 'Decline'),
                    InteractionStatus = (notificationStatus ? 'Success' : 'Failed'),
                    PaymentGatewayId = authorization.PaymentGatewayId
                )
            );
        }
        if (orderSummaryToUpdate.size() > 0) {
            SOM_DatabaseUtil.updateRecords(orderSummaryToUpdate, true);
        }
        if (paymentAuthorizationToUpdate.size() > 0) {
            SOM_DatabaseUtil.updateRecords(paymentAuthorizationToUpdate, true);
        }
        if (processExceptionToInsert.size() > 0) {
            SOM_DatabaseUtil.insertRecords(processExceptionToInsert, true);
        }
        if (paymentGatewayLogToInsert.size() > 0) {
            SOM_DatabaseUtil.insertRecords(paymentGatewayLogToInsert, true);
        }

        SOM_Application.commitChanges();
    }

    @suppressWarnings('PMD.ExcessiveParameterList')
    private static void processSingleCancelRequest(
        PaymentAuthorization authorization,
        List<ProcessException> processExceptionToInsert,
        List<OrderSummary> orderSummaryToUpdate,
        List<PaymentAuthorization> paymentAuthorizationToUpdate,
        boolean notificationStatus,
        Decimal maxRetryCount
    ) {
        OrderSummary orderSummary = authorization.OrderPaymentSummary.OrderSummary;
        if (notificationStatus) {
            // authorization cancel success
            authorization.status = SOM_Constants.CANCELED;
            paymentAuthorizationToUpdate.add(authorization);

            orderSummary.CancelAuthorizationStatus__c = SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_RELEASED;
            orderSummaryToUpdate.add(orderSummary);
        } else {
            // authorization cancel failure
            orderSummary.CancelAuthorizationRetryAttempts__c = orderSummary.CancelAuthorizationRetryAttempts__c == null
                ? 1
                : orderSummary.CancelAuthorizationRetryAttempts__c + 1;
            orderSummary.CancelAuthorizationStatus__c = SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED; //RequestFailed
            orderSummaryToUpdate.add(orderSummary);

            if (authorization.OrderPaymentSummary.OrderSummary.CancelAuthorizationRetryAttempts__c >= maxRetryCount) {
                // raise a process exception
                processExceptionToInsert.add(
                    new ProcessException(
                        OrderSummaryId = authorization.OrderPaymentSummary.OrderSummaryId,
                        AttachedToId = authorization.Id,
                        Message = 'Error Processing Payment',
                        Priority = 'High',
                        Severity = 'High',
                        Status = 'New',
                        Category = 'Payment'
                    )
                );
            }
        }
    }

    private static Decimal getMaxRetryCount() {
        SOM_BatchConfiguration__mdt cancelAuthorizationBatchConfiguration = Test.isRunningTest()
            ? SOM_TestDataFactory.createSOMBatchConfigurationRecord()
            : SOM_BatchConfiguration__mdt.getInstance('Cancel_Authorization');
        return cancelAuthorizationBatchConfiguration.retryCount__c;
    }
}
