/**
* @description PaymentGroup selector interface
*/
public interface SOM_IPaymentGroupSelector {
    /**
    * @description Selects PaymentGroup records based on the Source Object Id list
    * @param sourceObjectIds List of the Ids
    * @return List of PaymentGroup
    */
    List<PaymentGroup> selectBySourceObjectIds(List<String> sourceObjectIds);
}