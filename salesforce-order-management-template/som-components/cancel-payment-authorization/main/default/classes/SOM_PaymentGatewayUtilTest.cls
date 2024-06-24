/**
 *  @description Cancel payment authorization - SOM Payment Gateway Util test class
 */
@isTest
public with sharing class SOM_PaymentGatewayUtilTest {
    /**
     * @description SOM_PaymentGatewayUtil.getPaymentGatewayInfo positive test
     */
    @isTest
    static void shouldHandle() {
        // Then, use it in the getPaymentInfo method
        String uri = SOM_PaymentGatewayUtil.getPaymentGatewayInfo('test')?.CalloutURL__c;
        System.assert(uri != null, 'Callout URL should not be null');
    }

    /**
     * @description SOM_PaymentGatewayUtil.getPaymentGatewayInfo negative test
     */
    @isTest
    static void shouldFail() {
        // Then, use it in the getPaymentInfo method
        SOM_PaymentGatewayInfo__mdt paymentMdt = SOM_PaymentGatewayUtil.getPaymentGatewayInfo('fail');
        System.assert(paymentMdt == null, 'Metadata should be null');
    }
}
