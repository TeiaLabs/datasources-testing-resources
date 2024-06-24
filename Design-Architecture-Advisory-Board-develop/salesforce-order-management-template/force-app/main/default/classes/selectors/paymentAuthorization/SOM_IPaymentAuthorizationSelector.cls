/**
* @description Payment Authorization selector interface
*/
public interface SOM_IPaymentAuthorizationSelector {

    /**
    * @description Selects Payment Authorization records based on the Id list
    * @param paymentAuthorizationIds List of the Ids
    * @return List of PaymentAuthorization
    */
    List<PaymentAuthorization> selectByIds(List<String> paymentAuthorizationIds);

    /**
    * @description Selects PaymentAuthorization records based on the orderSummaryIds list
    * @param orderSummaryIds List of the Ids
    * @return List of PaymentAuthorization
    */
    List<PaymentAuthorization> selectByOrderSummaryIds(Set<Id> orderSummaryIds);
}
