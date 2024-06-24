/**
* @description Mock fail response class
*/
@isTest
public class SOM_RestFailMock implements HttpCalloutMock {
    /**
    * @description Http respond method
    * @param request HttpRequest object
    * @return HttpResponse object
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(SOM_Constants.HTTP_INTERNAL_ERROR_CODE);
        response.setBody(SOM_RestDataFactory.getErrorResponseBody());
        return response;
    }
}