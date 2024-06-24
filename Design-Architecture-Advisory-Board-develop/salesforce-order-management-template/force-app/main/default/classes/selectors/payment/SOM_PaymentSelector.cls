/**
* @description Payment selector class
*/
public with sharing class SOM_PaymentSelector implements SOM_IPaymentSelector{
    /**
    * @description Selects Payment records based on the Id list
    * @param paymentIds List of the Ids
    * @return List of Payment
    */
    public List<Payment> selectByIds(List<String> paymentIds){
        return [SELECT 
                    Id,
                    ClientContext,
                    AccountId
                FROM Payment 
                WHERE Id IN :paymentIds
                WITH SECURITY_ENFORCED];
    }

}
