/**
* @description PaymentAuthorization selector class
*/
public with sharing class SOM_PaymentAuthorizationSelector implements SOM_IPaymentAuthorizationSelector{

    /**
    * @description Selects PaymentAuthorization records based on the Id list
    * @param paymentAuthorizationIds List of the Ids
    * @return List of PaymentAuthorization
    */
    public List<PaymentAuthorization> selectByIds(List<String> paymentAuthorizationIds) {
        return [SELECT 
                    AccountId, Amount, Balance, Comments, Date, EffectiveDate, Email, ExpirationDate, GatewayAuthCode, GatewayDate, 
                    GatewayRefDetails, GatewayRefNumber, GatewayResultCode, GatewayResultCodeDescription, IpAddress, MacAddress, 
                    OrderPaymentSummaryId, PaymentAuthorizationNumber, PaymentGatewayId, PaymentGroupId, PaymentMethodId, Phone, ProcessingMode, 
                    SfResultCode, Status, TotalAuthReversalAmount, TotalPaymentCaptureAmount,
                    OrderPaymentSummary.OrderSummaryId
                FROM PaymentAuthorization
                WHERE Id IN :paymentAuthorizationIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects PaymentAuthorization records based on the orderSummaryIds list
    * @param orderSummaryIds List of the Ids
    * @return List of PaymentAuthorization
    */
    public List<PaymentAuthorization> selectByOrderSummaryIds(Set<Id> orderSummaryIds) {
        return [SELECT 
                    Amount,
                    GatewayRefNumber,
                    PaymentGatewayId,
                    OrderPaymentSummary.Id,
                    PaymentGateway.ExternalReference, 
                    OrderPaymentSummary.OrderSummaryId,
                    OrderPaymentSummary.OrderSummary.OrderNumber
                FROM PaymentAuthorization
                WHERE OrderPaymentSummary.OrderSummaryId IN :orderSummaryIds 
                    AND Status != :SOM_Constants.CANCELED 
                    AND GatewayRefNumber != NULL
                WITH SECURITY_ENFORCED];
    }
}