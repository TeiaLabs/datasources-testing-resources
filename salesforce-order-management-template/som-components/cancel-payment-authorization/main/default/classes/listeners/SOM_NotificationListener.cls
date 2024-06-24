/**
 * @description Cancel payment authorization
 *      SOM notification listener class
 */
@RestResource(urlMapping='/SOM_NotificationListener')
global without sharing class SOM_NotificationListener {
    private static final Integer HTTP_INTERNAL_ERROR_CODE = 500;
    private static SOM_PaymentGatewayInfo__mdt paymentGatewayInfo;

    /**
     * @description Notification handle
     */
    @HttpPost
    @suppressWarnings('PMD.CyclomaticComplexity')
    global static void handlePost() {
        RestRequest request = RestContext.request;
        RestResponse response;

        String requestBody = request?.requestBody?.toString().trim();

        if (String.isBlank(requestBody)) {
            return;
        }
        Som_LogUtil.createInfoLog(
            SOM_CancelPaymentAuthorizationConstants.HTTP_REQUEST,
            requestBody
        );
        
        // Read in the request the chosen payment gateway.
        String merchantAccountCode = getMerchantAccountCode(requestBody);

        // Then, use it in the getPaymentInfo method
        String uri = SOM_PaymentGatewayUtil.getPaymentGatewayInfo(merchantAccountCode)?.CalloutURL__c;
        // example: 'callout:Adyen_Notification';
        if (String.isBlank(uri)) {
            throw new IllegalArgumentException('Payment gateway not found');
        }

        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json');
        headers.put('Accept', 'application/json');
        try {
            HttpResponse httpResponse = SOM_CalloutUtil.doCallout(uri, 'POST', headers, requestBody);
            response = createResponse(httpResponse.getStatusCode(), httpResponse.getBody());
            Som_LogUtil.createInfoLog(
                SOM_CancelPaymentAuthorizationConstants.HTTP_RESPONSE,
                JSON.serialize(response)
            );
            
            SOM_CancelPaymentAuthNotification data = (SOM_CancelPaymentAuthNotification) JSON.deserialize(
                requestBody,
                SOM_CancelPaymentAuthNotification.class
            );
            if (data != null && data.notificationItems != null && !data.notificationItems.isEmpty()) {
                handleNotifications(data);
            }
        } catch (Exception ex) {
            response = createResponse(
                SOM_Constants.HTTP_INTERNAL_ERROR_CODE,
                ex.getMessage() +
                ' --- ' +
                ex.getStackTraceString()
            );
            Som_LogUtil.createErrorLog(
                SOM_CancelPaymentAuthorizationConstants.HTTP_REQUEST,
                ex.getMessage() +
                ' --- ' +
                ex.getStackTraceString()
            );
        }

        SOM_Application.commitChanges();
    }

    private static String getMerchantAccountCode(String requestBody) {
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        List<Map<String, Object>> notificationItems = new List<Map<String, Object>>();
        for (Object instance : (List<Object>) params.get('notificationItems')) {
            notificationItems.add((Map<String, Object>) instance);
        }
        // Example: ({NotificationRequestItem={additionalData={hmacSignature=1A2S3D1Q2W3E4R5T}, amount={currency=EUR, value=29139}, eventCode=CAPTURE, merchantAccountCode=CLOS19, merchantReference=ORDER-12345, originalReference=1A2S3D4F5G, pspReference=12345, success=true}})
        if (notificationItems != null) {
            Object notificationRequestItem = notificationItems[0].get('NotificationRequestItem');
            if (notificationRequestItem != null) {
                String itemJson = JSON.serialize(notificationRequestItem);
                Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(itemJson);
                return (String) itemMap.get('merchantAccountCode');
            }
        }
        return null;
    }

    private static void handleNotifications(SOM_CancelPaymentAuthNotification data) {
        for (SOM_CancelPaymentAuthNotification.NotificationItems item : data.notificationItems) {
            if (item.NotificationRequestItem.eventCode == SOM_CancelPaymentAuthorizationConstants.EVENT_CANCELLATION) {
                executeAuthorizationCancelFlow(item);
            }
        }
    }

    private static RestResponse createResponse(Integer httpStatusCode, String responseBody) {
        RestResponse response = RestContext.response;
        response.statusCode = httpStatusCode;
        response.responseBody = Blob.valueOf(responseBody);
        return response;
    }

    private static void executeAuthorizationCancelFlow(SOM_CancelPaymentAuthNotification.NotificationItems item) {
        if (item != null) {
            List<Map<String, Boolean>> requests = new List<Map<String, Boolean>>();
            Map<String, Boolean> request = new Map<String, Boolean>();
            request.put(
                item.NotificationRequestItem.originalReference,
                item.NotificationRequestItem.success == SOM_CancelPaymentAuthorizationConstants.TRUE_STRING
            );
            requests.add(request);

            SOM_BaseCancelAuthorizationHandler.handleCancelResponse(requests, item);
        } //else do nothing
    }
}
