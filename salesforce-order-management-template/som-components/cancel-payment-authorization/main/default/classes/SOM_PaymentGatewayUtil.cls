/**
 * @description Cancel payment authorization utility
 *      class with methods related to payment gateways
 */
public with sharing class SOM_PaymentGatewayUtil {
    /**
     * @description retrieves the payment gateway information based on the name given
     *  or save error log if not found
     * @param paymentGatewayName String
     * @return SOM_PaymentGatewayInfo__mdt
     */
    public static SOM_PaymentGatewayInfo__mdt getPaymentGatewayInfo(String paymentGatewayName) {
        SOM_PaymentGatewayInfo__mdt data = Test.isRunningTest()
            ? createPaymentGatewayInfo()
            : SOM_PaymentGatewayInfo__mdt.getInstance(paymentGatewayName);

        if (Test.isRunningTest() && paymentGatewayName.equals('fail')) {
            data = null;
        }

        if (data != null) {
            return data;
        }

        SOM_LogUtil.createErrorLog(
            SOM_Constants.PAYMENT,
            String.format(
                '{0} {1} {2}',
                new List<String>{
                    SOM_CancelPaymentAuthorizationConstants.ERROR_FINDING_PAYMENT_GATEWAY_METADATA,
                    ' Payment Gateway Name: ',
                    paymentGatewayName
                }
            )
        );

        return null;
    }

    /**
     * @description Creates Batch Configuration metadata record
     * @return Batch Configuration metadata record
     */
    private static SOM_PaymentGatewayInfo__mdt createPaymentGatewayInfo() {
        SOM_PaymentGatewayInfo__mdt configuration = new SOM_PaymentGatewayInfo__mdt();
        configuration.CalloutURL__c = 'callout:Adyen_Notification';
        configuration.GatewayName__c = 'Adyen';
        
        return configuration;
    }
}