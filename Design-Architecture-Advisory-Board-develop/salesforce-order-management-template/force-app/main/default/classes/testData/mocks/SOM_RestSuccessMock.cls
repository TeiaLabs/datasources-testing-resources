/**
* @description Mock success response class
*/
@isTest
public class SOM_RestSuccessMock implements HttpCalloutMock {
    /**
    * @description Http respond method
    * @param request HttpRequest object
    * @return HttpResponse object
    */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader(SOM_Constants.CONTENT_TYPE, SOM_Constants.APPLICATION_JSON);
        response.setStatusCode(SOM_Constants.HTTP_SUCCESS_CODE);
        response.setBody(SOM_RestDataFactory.getSuccessResponseBody());
        return response;
    }
}