/**
* @description Mock success response class
*/
@isTest
public class SOM_CancelPaymentAuthRestSuccessMock implements HttpCalloutMock {
    /**
    * @description Http respond method
    * @param request HttpRequest object
    * @return HttpResponse object
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader(SOM_Constants.CONTENT_TYPE, SOM_Constants.APPLICATION_JSON);
        response.setStatusCode(SOM_Constants.HTTP_SUCCESS_CODE);
        if (request.getEndpoint().contains(SOM_CancelPaymentAuthorizationConstants.ADYEN_NAME)){
            response.setBody(SOM_CancelPaymentAuthRestDataFactory.getAdyenSuccessResponseBody());
        } else {
            response.setBody(SOM_CancelPaymentAuthRestDataFactory.getSuccessResponseBody());
        }
        return response;
    }
}