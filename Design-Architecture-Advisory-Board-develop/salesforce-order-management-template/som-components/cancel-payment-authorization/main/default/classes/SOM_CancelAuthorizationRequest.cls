/**
 * @description Cancel payment authorization
 *       request object for CancelAuthorization
 */
public with sharing class SOM_CancelAuthorizationRequest {
    /** 
     * @description Payment Authorization id to be cancelled 
     */
    @InvocableVariable(label='Payment Authorization Id' required=true)
    public Id paymentAuthorizationId;

    /** 
     * @description Amount to void. If null or, less than or equal to zero, the entire amount will be voided
     */
    @InvocableVariable(label='Cancel Amount' required=false)
    public Decimal amount;
}
