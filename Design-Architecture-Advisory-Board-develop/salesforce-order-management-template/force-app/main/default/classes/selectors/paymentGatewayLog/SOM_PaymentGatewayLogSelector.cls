/**
* @description PaymentGatewayLog selector class
*/
public with sharing class SOM_PaymentGatewayLogSelector implements SOM_IPaymentGatewayLogSelector {
    /**
    * @description Selects PaymentGatewayLog records based on the RelatedOrderId list
    * @param orderSummaryIds List of the Ids
    * @return List of Order
    */
    public List<PaymentGatewayLog> selectByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT OrderPaymentSummary.OrderSummaryId
                FROM PaymentGatewayLog 
                WHERE OrderPaymentSummary.OrderSummaryId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }
}