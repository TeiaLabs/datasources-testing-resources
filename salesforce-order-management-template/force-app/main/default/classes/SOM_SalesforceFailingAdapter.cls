/**
* @description Salesforce mock adapter (provided by Salesforce)
*   suppress reason: Adapter requires global access modifier
*/
@suppressWarnings('PMD.AvoidGlobalModifier')
global class SOM_SalesforceFailingAdapter implements commercepayments.PaymentGatewayAdapter {
    private static final commercepayments.SalesforceResultCodeInfo SUCCESS_SALESFORCE_RESULT_CODE_INFO = 
        new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Success);
    private static final commercepayments.SalesforceResultCodeInfo DECLINE_SALESFORCE_RESULT_CODE_INFO = 
        new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Decline);
    
    /**
    * @description Processes request
    * @param gatewayContext PaymentGateway context
    * @return PaymentGateway response
    */
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        commercepayments.GatewayResponse response;

        try 
        {
            if (requestType == commercepayments.RequestType.Authorize) 
            {
                response = createAuthResponse((commercepayments.AuthorizationRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Capture)
            {
                response = createCaptureResponse((commercepayments.CaptureRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Sale)
            {
                response = createSaleResponse((commercepayments.SaleRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.ReferencedRefund) 
            {
                response = createRefundResponse((commercepayments.ReferencedRefundRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.Tokenize) 
            {
                response = createTokenizeResponse((commercepayments.PaymentMethodTokenizationRequest)gatewayContext.getPaymentRequest());
            }
            else if (requestType == commercepayments.RequestType.AuthorizationReversal) 
            {
                response = createAuthReversalResponse((commercepayments.AuthorizationReversalRequest) gatewayContext.getPaymentRequest());
            }
            return response;
        }
        catch(SalesforceFailingAdapterException e)
        {
             commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse('400', e.getMessage());
             return error;
        }
    }

    /**
    * @description Creates response for tokenize request
    * @param tokenizeRequest Tokenize request
    * @return PaymentGateway response
    */
    public commercepayments.GatewayResponse createTokenizeResponse(commercepayments.PaymentMethodTokenizationRequest tokenizeRequest) {
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

        if(authRequest.amount == null)
        {
            throw new SalesforceFailingAdapterException('Required Field Missing : Amount');
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

        if(captureRequest.amount == null)
        {
            throw new SalesforceFailingAdapterException('Required Field Missing : Amount');             
        }

//        captureResponse.setAmount(captureRequest.amount);
        captureResponse.setAsync(false);
//        captureResponse.setGatewayAvsCode('none');
        captureResponse.setGatewayDate(System.now());
//        captureResponse.setGatewayMessage('[capture failed]');
//        captureResponse.setGatewayReferenceDetails('Trying to fail');
//        captureResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
//        captureResponse.setGatewayResultCode('DECLINE');
//        captureResponse.setGatewayResultCodeDescription('This adapter will always fail');
        captureResponse.setSalesforceResultCodeInfo(new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.SystemError));
//        captureResponse.setSalesforceResultCodeInfo(DECLINE_SALESFORCE_RESULT_CODE_INFO);
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

        if(saleRequest.amount == null)
        {
            throw new SalesforceFailingAdapterException('Required Field Missing : Amount');             
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
    public commercepayments.GatewayResponse createRefundResponse(commercepayments.ReferencedRefundRequest refundRequest) {
        commercepayments.ReferencedRefundResponse refundResponse = new commercepayments.ReferencedRefundResponse();
        
        if (refundRequest.amount == null) 
        {
            throw new SalesforceFailingAdapterException('Required Field Missing : Amount');
        } 


        refundResponse.setAsync(false);
        refundResponse.setGatewayDate(System.now());
        refundResponse.setSalesforceResultCodeInfo(new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.SystemError));
        return refundResponse;
    }  

    /**
        * @description Creates a new AuthReversalResponse object
        * @param authReversalRequest AuthReversalRequest object
        * @return AuthReversalResponse object
    */
    global commercepayments.GatewayResponse createAuthReversalResponse(commercepayments.AuthorizationReversalRequest authReversalRequest) {
        commercepayments.AuthorizationReversalResponse authReversalResponse = new commercepayments.AuthorizationReversalResponse();
        if(authReversalRequest.amount!=null )
        {
            authReversalResponse.setAmount(authReversalRequest.amount);
        }
        else
        {
             throw new SalesforceFailingAdapterException('Required Field Missing : Amount');             
        }
   
        authReversalResponse.setGatewayDate(system.now());
        authReversalResponse.setGatewayResultCode('00');
        authReversalResponse.setGatewayResultCodeDescription('Transaction Normal');
        authReversalResponse.setGatewayReferenceNumber('SF' + getRandomNumber(6));
        authReversalResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
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
    public class SalesforceFailingAdapterException extends Exception { }
}