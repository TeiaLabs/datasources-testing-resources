/**
* @description CardPaymentMethod selector class
*/
public with sharing class SOM_CardPaymentMethodSelector implements SOM_ICardPaymentMethodSelector {
    /**
    * @description Selects CardPaymentMethod records based on the Id list
    * @param cardPaymentMethodIds List of the Ids
    * @return List of CardPaymentMethod
    */
    public List<CardPaymentMethod> selectByIds(List<String> cardPaymentMethodIds) {
        return [SELECT Status
                FROM CardPaymentMethod 
                WHERE Id IN :cardPaymentMethodIds
                WITH SECURITY_ENFORCED];
    }
}