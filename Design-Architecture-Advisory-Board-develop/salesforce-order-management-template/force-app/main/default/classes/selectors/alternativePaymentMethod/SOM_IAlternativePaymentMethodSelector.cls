/**
* @description AlternativePaymentMethod selector interface
*/
public interface SOM_IAlternativePaymentMethodSelector {
    /**
    * @description Selects AlternativePaymentMethod records based on the Id list
    * @param alternativePaymentMethodIds List of the Ids
    * @return List of AlternativePaymentMethod
    */
    List<AlternativePaymentMethod> selectByIds(List<String> alternativePaymentMethodIds);
}