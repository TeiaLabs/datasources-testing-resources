/**
* @description Invoice selector interface
*/
public interface SOM_IInvoiceSelector {
    /**
    * @description Selects Invoice records based on the Id list
    * @param invoiceIds List of the Ids, querySize query limit
    * @param querySize query limit
    * @return List of Invoice
    */
    List<Invoice> selectByIds(List<String> invoiceIds, Integer querySize);
    /**
    * @description Selects Invoice records based on the ReferenceEntityId list and Status
    * @param referenceEntityIds List of the ReferenceEntityIds
    * @param status String 
    * @param querySize query limit
    * @return List of Invoice
    */
    List<Invoice> selectByReferenceEntityIdsAndStatus(List<String> referenceEntityIds, String status, Integer querySize);
}
