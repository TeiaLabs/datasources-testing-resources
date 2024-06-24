/**
* @description PaymentGatewayLogSelector selector interface
*/
public interface SOM_IPaymentGatewayLogSelector {
    /**
    * @description Selects PaymentGatewayLog records based on the OrderPaymentSummary.OrderSummaryId list
    * @param orderSummaryIds List of the Ids
    * @return List of PaymentGatewayLog
    */
    List<PaymentGatewayLog> selectByOrderSummaryIds(List<String> orderSummaryIds);
}