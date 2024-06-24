/**
 * @description Salesforce mock adapter (provided by Salesforce)
 *   suppress reason: Adapter requires global access modifier
 */
@suppressWarnings('PMD.AvoidGlobalModifier')
global class SOM_PaypalPaymentAdapter implements commercepayments.PaymentGatewayAdapter {
    private static final commercepayments.SalesforceResultCodeInfo SUCCESS_SALESFORCE_RESULT_CODE_INFO = new commercepayments.SalesforceResultCodeInfo(
        commercepayments.SalesforceResultCode.Success
    );
    private static final commercepayments.SalesforceResultCodeInfo DECLINE_SALESFORCE_RESULT_CODE_INFO = new commercepayments.SalesforceResultCodeInfo(
        commercepayments.SalesforceResultCode.Decline
    );
    private static SOM_PaymentGatewayInfo__mdt config;
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
     * @description Processes request
     * @param gatewayContext PaymentGateway context
     * @return PaymentGateway response
     */
    @suppressWarnings('PMD.CyclomaticComplexity')
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        commercepayments.GatewayResponse response;

        String configName = SOM_CancelPaymentAuthorizationConstants.PAYPAL_NAME;
        Boolean isSetConfigSucceed = setConfig(configName);
        if (!isSetConfigSucceed) {
            throw new SOM_ApplicationException('Missing SOM_PaymentGatewayInfo__mdt configuration for ' + configName);
        }

        try {
            if (requestType == commercepayments.RequestType.Authorize) {
                response = createAuthResponse(
                    (commercepayments.AuthorizationRequest) gatewayContext.getPaymentRequest()
                );
            } else if (requestType == commercepayments.RequestType.Capture) {
                response = createCaptureResponse((commercepayments.CaptureRequest) gatewayContext.getPaymentRequest());
            } else if (requestType == commercepayments.RequestType.Sale) {
                response = createSaleResponse((commercepayments.SaleRequest) gatewayContext.getPaymentRequest());
            } else if (requestType == commercepayments.RequestType.ReferencedRefund) {
                response = createRefundResponse(
                    (commercepayments.ReferencedRefundRequest) gatewayContext.getPaymentRequest()
                );
            } else if (requestType == commercepayments.RequestType.Tokenize) {
                response = createTokenizeResponse(
                    (commercepayments.PaymentMethodTokenizationRequest) gatewayContext.getPaymentRequest()
                );
            } else if (requestType == commercepayments.RequestType.AuthorizationReversal) {
                response = createAuthReversalResponse(
                    (commercepayments.AuthorizationReversalRequest) gatewayContext.getPaymentRequest()
                );
            } else {
                commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse(
                    '400',
                    'requestType not supported:' + requestType
                );
                return error;
            }
            return response;
        } catch (SalesforceAdapterException e) {
            commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse(
                '400',
                e.getMessage()
            );
            return error;
        }
    }

    /**
     * @description Creates response for tokenize request
     * @param tokenizeRequest Tokenize request
     * @return PaymentGateway response
     */
    public commercepayments.GatewayResponse createTokenizeResponse(
        commercepayments.PaymentMethodTokenizationRequest tokenizeRequest
    ) {
        commercepayments.PaymentMethodTokenizationResponse tokenizeResponse = new commercepayments.PaymentMethodTokenizationResponse();
        tokenizeResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayTokenDetails(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayAvsCode(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayMessage(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayResultCode(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayResultCodeDescription(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        tokenizeResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        tokenizeResponse.setGatewayDate(System.now());
        return tokenizeResponse;
    }

    /**
     * @description Creates response for authorization request
     * @param authRequest Authorization request
     * @return PaymentGateway response
     */
    public commercepayments.GatewayResponse createAuthResponse(commercepayments.AuthorizationRequest authRequest) {
        commercepayments.AuthorizationResponse authResponse = new commercepayments.AuthorizationResponse();
        commercepayments.PaymentMethodTokenizationResponse paymentMethodTokenizationResponse = new commercepayments.PaymentMethodTokenizationResponse();

        if (authRequest.amount == null) {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }

        authResponse.setAmount(authRequest.amount);
        authResponse.setGatewayResultCode('00');
        authResponse.setGatewayResultCodeDescription('Transaction Normal');
        authResponse.setGatewayAuthCode('SF' + getRandomNumber(6));
        authResponse.setGatewayReferenceNumber(getRandomNumber(10));
        authResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        authResponse.setGatewayDate(System.now());
        paymentMethodTokenizationResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        authResponse.setPaymentMethodTokenizationResponse(paymentMethodTokenizationResponse);
        return authResponse;
    }

    /**
     * @description Creates response for capture request
     * @param captureRequest Capture request
     * @return PaymentGateway response
     */
    public commercepayments.GatewayResponse createCaptureResponse(commercepayments.CaptureRequest captureRequest) {
        commercepayments.CaptureResponse captureResponse = new commercepayments.CaptureResponse();

        if (captureRequest.amount == null) {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }

        captureResponse.setAmount(captureRequest.amount);
        captureResponse.setGatewayDate(System.now());
        captureResponse.setGatewayResultCode('00');
        captureResponse.setGatewayResultCodeDescription('Transaction Normal');
        captureResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        captureResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return captureResponse;
    }

    /**
     * @description Creates response for sale request
     * @param saleRequest Sale request
     * @return PaymentGateway response
     */
    public commercepayments.GatewayResponse createSaleResponse(commercepayments.SaleRequest saleRequest) {
        commercepayments.SaleResponse saleResponse = new commercepayments.SaleResponse();
        commercepayments.PaymentMethodTokenizationResponse paymentMethodTokenizationResponse = new commercepayments.PaymentMethodTokenizationResponse();

        if (saleRequest.amount == null) {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }

        saleResponse.setAmount(saleRequest.amount);
        saleResponse.setGatewayDate(System.now());
        saleResponse.setGatewayResultCode('00');
        saleResponse.setGatewayResultCodeDescription('Transaction Normal');
        saleResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        saleResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        paymentMethodTokenizationResponse.setGatewayToken(getRandomNumber(8) + getRandomNumber(8));
        saleResponse.setPaymentMethodTokenizationResponse(paymentMethodTokenizationResponse);
        return saleResponse;
    }

    /**
     * @description Creates response for refund request
     * @param refundRequest Refund request
     * @return PaymentGateway response
     */
    public commercepayments.GatewayResponse createRefundResponse(
        commercepayments.ReferencedRefundRequest refundRequest
    ) {
        commercepayments.ReferencedRefundResponse refundResponse = new commercepayments.ReferencedRefundResponse();

        if (refundRequest.amount == null) {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }

        refundResponse.setAmount(refundRequest.amount);
        refundResponse.setGatewayResultCode('00');
        refundResponse.setGatewayDate(System.now());
        refundResponse.setGatewayResultCodeDescription('Transaction Normal');
        refundResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        refundResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return refundResponse;
    }

    /**
     * @description Creates a new AuthReversalResponse object
     * @param authReversalRequest AuthReversalRequest object
     * @return AuthReversalResponse object
     */
    global commercepayments.GatewayResponse createAuthReversalResponse(
        commercepayments.AuthorizationReversalRequest authReversalRequest
    ) {
        commercepayments.AuthorizationReversalResponse authReversalResponse = new commercepayments.AuthorizationReversalResponse();
        if (authReversalRequest.amount == null) {
            throw new SalesforceAdapterException('Required Field Missing : Amount');
        }
        List<String> paymentAuthIds = new List<String>();
        paymentAuthIds.add(authReversalRequest.paymentAuthorizationId);
        List<PaymentAuthorization> paymentAuthorizations = SOM_Selectors.PaymentAuthorization.selectByIds(
            paymentAuthIds
        );
        if (paymentAuthorizations.size() > 1) {
            throw new SalesforceAdapterException('Too many payment authorizations retrieved');
        }

        Map<String, String> headers = new Map<String, String>();
        headers.put('Content-Type', 'application/json');
        headers.put('Authorization', getAuthorizationBasic());
        String requestBody = '';

        for (PaymentAuthorization pa : paymentAuthorizations) {
            String uri = config.CalloutURL__c + '/' + pa.GatewayRefNumber + '/void';
            // do call for the paypal endpoint
            HttpResponse httpResponse = SOM_CalloutUtil.doCalloutCommercePayments(uri, 'POST', headers, requestBody);
            authReversalResponse = validatePaypalResponse(httpResponse, pa);
            authReversalResponse.setAmount(authReversalRequest.amount);
        }

        return authReversalResponse;
    }

    /**
     * @description Validate paypal http response for a authorization reversal request
     * @param httpResponse Paypal http response
     * @param pa Payment authorization
     * @return commercepayments.AuthorizationReversalResponse
     */
    private commercepayments.AuthorizationReversalResponse validatePaypalResponse(HttpResponse httpResponse, PaymentAuthorization pa) {
        commercepayments.AuthorizationReversalResponse authReversalResponse = new commercepayments.AuthorizationReversalResponse();
        if (
            httpResponse != null &&
            (httpResponse.getStatusCode() == SOM_Constants.HTTP_NO_CONTENT ||
            httpResponse.getStatusCode() == SOM_Constants.HTTP_CREATED ||
            httpResponse.getStatusCode() == SOM_Constants.HTTP_SUCCESS_CODE)
        ) {
            authReversalResponse.setGatewayDate(system.now());
            authReversalResponse.setGatewayMessage('Reversed');
            authReversalResponse.setGatewayResultCode('SUCCESS');
            authReversalResponse.setGatewayResultCodeDescription('Transaction Normal');
            authReversalResponse.setGatewayReferenceDetails('Reversed');
            authReversalResponse.setGatewayReferenceNumber(pa.GatewayRefNumber);
            authReversalResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        } else {
            // this means there was a failure on paypal side
            SOM_LogUtil.createErrorLog(
                pa.OrderPaymentSummary.OrderSummaryId,
                SOM_Constants.PAYMENT,
                'An error occurred while calling the Paypal Cancel Authorization API. PaymentAuthorizationId: ' + pa.Id
            );

            // parse the response
            PaypalResponseV2 paypalReponse;
            if (httpResponse.getBody() != null) {
                paypalReponse = (PaypalResponseV2) System.JSON.deserialize(
                    httpResponse.getBody(),
                    PaypalResponseV2.class
                );
            }

            authReversalResponse.setGatewayDate(system.now());
            authReversalResponse.setGatewayResultCode('DECLINE');
            authReversalResponse.setGatewayResultCodeDescription(paypalReponse == null ? '' : paypalReponse.status);
            authReversalResponse.setGatewayReferenceNumber(pa.GatewayRefNumber);
            authReversalResponse.setSalesforceResultCodeInfo(DECLINE_SALESFORCE_RESULT_CODE_INFO);
        }
        return authReversalResponse;
    }
    /**
     * @description Generates random number based on length
     * @param stringLength Length of the string
     * @return Random number as string
     */
    private String getRandomNumber(integer stringLength) {
        Integer max = integer.valueOf(Math.pow(10, stringLength) - 1);
        return String.valueOf(Math.Round(Math.Random() * MAX)).leftPad(stringLength, '0');
    }

    /**
     * @description Salesforce adapter exception
     */
    public class SalesforceAdapterException extends Exception {
    }

    private static String getAuthorizationBasic() {
        Blob headerValue = Blob.valueOf('{!$Credential.Username}:{!$Credential.Password}');
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        return authorizationHeader;
    }

    /**
     * @description Paypal v2 response model class
     */
    public class PaypalResponseV2 {
        /**
         * @description id field
         */
        public string id { get; set; }
        /**
         * @description status field
         */
        public string status { get; set; } // Status: COMPLETED, VOIDED
    }
}
