/**
* @description Payment selector interface
*/
public interface SOM_IPaymentSelector {
    /**
    * @description Selects Payment records based on the Id list
    * @param paymentIds List of the Ids
    * @return List of Payment
    */
    List<Payment> selectByIds(List<String> paymentIds);
}
