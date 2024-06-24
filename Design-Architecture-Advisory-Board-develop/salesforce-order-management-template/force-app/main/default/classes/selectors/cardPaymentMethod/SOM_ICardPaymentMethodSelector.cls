/**
* @description CardPaymentMethod selector interface
*/
public interface SOM_ICardPaymentMethodSelector {
    /**
    * @description Selects CardPaymentMethod records based on the Id list
    * @param cardPaymentMethodIds List of the Ids
    * @return List of CardPaymentMethod
    */
    List<CardPaymentMethod> selectByIds(List<String> cardPaymentMethodIds);
}