/**
 * @description Cancel payment authorization
 *       CancelAuthorization handler for Adyen
 */
public with sharing class SOM_AdyenAuthorizationCancelHandler {
    private static List<SObject> upsertData = new List<SObject>();
    public static final String CANCEL_RECEIVED = '[cancel-received]';
    private static SOM_PaymentGatewayInfo__mdt config;

    /**
     * @description do cancel
     * @param authorizations PaymentAuthorization list to cancel
     * @param orderSummaries order summary records
     */
    public static void handle(List<PaymentAuthorization> authorizations, Map<Id, OrderSummary> orderSummaries) {
        String configName = SOM_CancelPaymentAuthorizationConstants.ADYEN_NAME;
        Boolean isSetConfigSucceed = setConfig(configName);
        if (!isSetConfigSucceed) {
            throw new SOM_ApplicationException('Missing SOM_PaymentGatewayInfo__mdt configuration for ' + configName);
        }
        List<PaymentGatewayLog> paymentGatewayLogToInsert = new List<PaymentGatewayLog>();
        for (PaymentAuthorization authorization : authorizations) {
            OrderSummary orderSum = orderSummaries.get(authorization.OrderPaymentSummary.OrderSummaryId);
            PaymentGatewayLog paymentLog = new PaymentGatewayLog(
                InteractionType = 'AuthorizationReversal',
                IsNotification = 'No',
                OrderPaymentSummaryId = authorization.OrderPaymentSummary.Id,
                ReferencedEntityId = authorization.Id,
                PaymentGatewayId = authorization.PaymentGatewayId
            );
    
            try {
                AdyenCancelResponse result = doCancel(authorization, orderSum.SalesChannel.MerchantAccountId__c, paymentLog);

                if (result != null && result.response == CANCEL_RECEIVED) {
                    orderSum.CancelAuthorizationStatus__c = SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_SENT;
                    paymentLog.SfResultCode = 'Success';
                    paymentLog.InteractionStatus = 'Success';
                    upsertData.add(orderSum);
                }
            } catch (Exception ex) {
                SOM_LogUtil.createErrorLog(SOM_Constants.PAYMENT, ex.getMessage() + ' --- ' + ex.getStackTraceString());
            }
            paymentGatewayLogToInsert.add(paymentLog);
        }
        if (paymentGatewayLogToInsert.size() > 0) {
            SOM_DatabaseUtil.insertRecords(paymentGatewayLogToInsert, true);
        }
        if (!upsertData.isEmpty()) {
            List<Database.UpsertResult> results = SOM_DatabaseUtil.upsertRecords(upsertData, false);
            SOM_LogUtil.createInfoLog(
                SOM_CancelPaymentAuthorizationConstants.AUTHORIZATIONS_TO_RECORD,
                JSON.serialize(upsertData)
            );
            SOM_LogUtil.createInfoLog(
                SOM_CancelPaymentAuthorizationConstants.AUTHORIZATIONS_TO_RECORD_RESULTS,
                JSON.serialize(results)
            );
        }
        SOM_Application.commitChanges();
    }

    /**
     * @description method to perform cancel operation
     * @param item PaymentAuthorization
     * @param merchantAccount String obtained from SalesChannel level
     * @param paymentLog PaymentLog record
     * @return AdyenCancelResponse object
     */
    private static AdyenCancelResponse doCancel(PaymentAuthorization item, String merchantAccount, PaymentGatewayLog paymentLog) {
        String uri = config.CalloutURL__c;
        AdyenCancelRequest request = new AdyenCancelRequest();
        request.reference = item.OrderPaymentSummary.OrderSummary.OrderNumber;
        request.originalReference = item.GatewayRefNumber;
        request.merchantAccount = merchantAccount;
        String requestBody = JSON.serialize(request);
        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json');
        HttpResponse httpResponse = SOM_CalloutUtil.doCallout(uri, 'POST', headers, requestBody);
        paymentLog.request = requestBody;
        paymentLog.response = httpResponse.getBody();

        if (
            httpResponse != null &&
            httpResponse.getBody() != null &&
            httpResponse.getStatusCode() == SOM_Constants.HTTP_SUCCESS_CODE
        ) {
            String responseBody = httpResponse.getBody();
            return (AdyenCancelResponse) JSON.deserialize(responseBody, AdyenCancelResponse.class);
        } else {
            SOM_LogUtil.createErrorLog(
                item.OrderPaymentSummary.OrderSummaryId,
                SOM_Constants.PAYMENT,
                'An error occurred while calling the Adyen Cancel API. Authorization: ' + item.Id
            );
            return null;
        }
    }

    /**
     * @description Setter method for config
     * @param configName Name of the configuration
     * @return isSuccess Boolean
     */
    private static Boolean setConfig(String configName) {
        config = SOM_PaymentGatewayUtil.getPaymentGatewayInfo(configName);
        return config != null;
    }

    /**
     * @description Adyen Cancel Authorization request
     */
    public class AdyenCancelRequest {
        public String originalReference;
        public String reference;
        public String merchantAccount;
    }

    /**
     * @description Adyen Cancel Authorization response
     */
    public class AdyenCancelResponse {
        public String response;
        public String pspReference;
    }
}
