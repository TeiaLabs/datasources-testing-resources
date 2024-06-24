/**
* @description Invoice selector class
*/
public with sharing class SOM_InvoiceSelector implements SOM_IInvoiceSelector {
    /**
    * @description Selects Invoice records based on the Id list
    * @param invoiceIds List of the Ids, querySize query limit
    * @param querySize query limit
    * @return List of Invoice
    */
    public List<Invoice> selectByIds(List<String> invoiceIds, Integer querySize){
        return [SELECT  
                    Id,
                    ReferenceEntityId, 
                    NumberOfRetries__c,
                    Status,
                    Balance 
                FROM Invoice 
                WHERE Id IN :invoiceIds
                WITH SECURITY_ENFORCED];
    }
    /**
    * @description Selects Invoice records based on the ReferenceEntityId list and Status
    * @param referenceEntityIds List of the ReferenceEntityIds
    * @param status String 
    * @param querySize query limit
    * @return List of Invoice
    */
    public List<Invoice> selectByReferenceEntityIdsAndStatus(List<String> referenceEntityIds, String status, Integer querySize){
        return [SELECT  
                    Id,
                    ReferenceEntityId, 
                    NumberOfRetries__c,
                    Status,
                    Balance 
                FROM Invoice 
                WHERE ReferenceEntityId IN :referenceEntityIds AND Status =: status
                WITH SECURITY_ENFORCED
                LIMIT :querySize];
    }
}
