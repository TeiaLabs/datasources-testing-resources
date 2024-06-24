/**
* @description PaymentGroup selector class
*/
public with sharing class SOM_PaymentGroupSelector implements SOM_IPaymentGroupSelector {
    /**
    * @description Selects PaymentGroup records based on the Source Object Id list
    * @param sourceObjectIds List of the Ids
    * @return List of PaymentGroup
    */
    public List<PaymentGroup> selectBySourceObjectIds(List<String> sourceObjectIds) {
        return [SELECT SourceObjectId 
                FROM PaymentGroup 
                WHERE SourceObjectId IN :sourceObjectIds
                WITH SECURITY_ENFORCED];
    }
}