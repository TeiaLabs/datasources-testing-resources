/**
* @description Test data factory class
*   for Rest Data
*/
@isTest
public class SOM_CancelPaymentAuthRestDataFactory {
    /**
    * @description Returns default success Http response body
    * @return Http response plain text
    */
    public static string getSuccessResponseBody() {
        return '{ "success":true }';
    }

    /**
    * @description Returns default success Http response body
    * @return Http response plain text
    */
    public static string getAdyenSuccessResponseBody() {
        return '{ "response": "[cancel-received]", "pspReference": "' + SOM_CancelPaymentAuthorizationConstants.TEST_PAYMENT_GATEWAY_EXTERNAL_REFERENCE + '" }';
    }

    /**
    * @description Returns default fail Http
    *response body
    * @return Http response plain text
    */
    public static string getErrorResponseBody() {
        return '{ "success":false }';
    }
}