/**
 * @description Authorizantion cancel handler
 */
public with sharing class SOM_CancelAuthorizationHandler {
    /**
     * @description Void a list of authorizations
     * @param cancelRequests List of authorization requests to void
     * @return List of responses for each authorization voided
     */
    @InvocableMethod(label='VoidAuthorization' description='VoidAuthorization' category='Orders')
    public static List<SOM_CancelAuthorizationResponse> voidAuthorization(
        List<SOM_CancelAuthorizationRequest> cancelRequests
    ) {
        List<SOM_CancelAuthorizationResponse> cancelResponses = new List<SOM_CancelAuthorizationResponse>();

        for (SOM_CancelAuthorizationRequest request : cancelRequests) {
            ConnectApi.AuthorizationReversalRequest authReversalInput = new ConnectApi.AuthorizationReversalRequest();
            if (request.amount != null && request.amount > 0) {
                authReversalInput.amount = request.amount;
            }
            Id authorizationId = request.paymentAuthorizationId;
            SOM_CancelAuthorizationResponse response = new SOM_CancelAuthorizationResponse();
            response.paymentAuthorizationId = authorizationId;

            try {
                ConnectApi.AuthorizationReversalResponse caResponse;
                if (!Test.isRunningTest()) {
                    caResponse = ConnectApi.Payments.reverseAuthorization(authReversalInput, authorizationId);
                } else {
                    caResponse = new ConnectApi.AuthorizationReversalResponse();
                }

                if (caResponse.error == null) {
                    response.success = true;
                } else {
                    response.success = false;
                    response.failureMessage = caResponse.error.message;
                }
            } catch (ConnectApi.ConnectApiException e) {
                response.success = false;
                response.failureMessage = e.getMessage();
                response.paymentAuthorizationId = authorizationId;
            }
            cancelResponses.add(response);
        }

        return cancelResponses;
    }
}
