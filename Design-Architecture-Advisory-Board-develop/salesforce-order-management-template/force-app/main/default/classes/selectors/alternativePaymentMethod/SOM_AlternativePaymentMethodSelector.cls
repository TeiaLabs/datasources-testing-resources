/**
* @description AlternativePaymentMethod selector class
*/
public with sharing class SOM_AlternativePaymentMethodSelector implements SOM_IAlternativePaymentMethodSelector {
    /**
    * @description Selects AlternativePaymentMethod records based on the Id list
    * @param alternativePaymentMethodIds List of the Ids
    * @return List of AlternativePaymentMethod
    */
    public List<AlternativePaymentMethod> selectByIds(List<String> alternativePaymentMethodIds) {
        return [SELECT Status
                FROM AlternativePaymentMethod 
                WHERE Id IN :alternativePaymentMethodIds
                WITH SECURITY_ENFORCED];
    }
}