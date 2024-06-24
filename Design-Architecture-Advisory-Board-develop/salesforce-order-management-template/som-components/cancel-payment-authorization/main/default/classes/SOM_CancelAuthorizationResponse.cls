/**
 * @description Cancel payment authorization
 *       response object for CancelAuthorization
 */
public with sharing class SOM_CancelAuthorizationResponse {
    /**
     * @description Payment Authorization id which was cancelled
     */
    @InvocableVariable(label='Payment Authorization Id' required=false)
    public Id paymentAuthorizationId;

    /**
     * @description True if the operation was successful in the payment gateway adapter
     */
    @InvocableVariable(label='Success' required=false)
    public boolean success;

    /**
     * @description Failure message in case of insucessful operation in the payment gateway adapter
     */
    @InvocableVariable(label='Failure message' required=false)
    public String failureMessage;
}
