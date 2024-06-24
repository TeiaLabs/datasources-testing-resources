/**
 * @description Abstract Request class for Http Retry
 */
public with sharing abstract class SOM_AbstractRequest {
    /**
    * @description method which returns request method
    * @return request method
    */
    abstract public String createMethod();

    /**
    * @description method which returns a map of headers
    * @return Map of headers
    */
    abstract public Map<String, String>  createHeaders();

    /**
    * @description method which returns request endpoint
    * @return request endpoint
    */
    abstract public String createEndpoint();

    /**
    * @description method which creates a new request body using list of Ids
    * @param idList list of ids
    * @return Generated request body
    */
    abstract public String createRequestBody(List<Id> idList);

    /**
    * @description Auth method
    */
    abstract public void auth();

    /**
     * @description Handles Response
     * @param response Http Response to be handled
     * @return Returns whether the response was successfully handled
     */
    abstract public Boolean handleResponse(
        HttpResponse response
    );

    /**
     * @description Overloading for process method
     * @param idList To be used id list, for creating request body
     * @return Return HttpResponse as result of process
     */
    public virtual HttpResponse process(List<Id> idList){
        this.auth();
        // Send HttpRequest
        HttpResponse res = SOM_CalloutUtil.doCallout(this.createEndpoint(), this.createMethod(), this.createHeaders(), this.createRequestBody(idList));
        return res;
    }

    /**
     * @description Overloading for process method
     * @param failedRequest To be used failed request, for creating HttpRequest class instance and setting request body
     * @return Return HttpResponse as result of process
     */
    public virtual HttpResponse process(SOM_FailedRequest__c failedRequest) {
        this.auth();
        String body = '';
        // Create request body
        if(failedRequest.RegenerateData__c) {
            List<Id> idlist = (List<Id>)JSON.deserialize(failedRequest.RegenerateDataParameter__c, List<Id>.class);
            body = this.createRequestBody(idList);
        } else {
            if(String.isNotBlank(failedRequest.Data__c)){
                body = failedRequest.Data__c;
            }
        }

        // Send HttpRequest
        HttpResponse res = SOM_CalloutUtil.doCallout(this.createEndpoint(), this.createMethod(), this.createHeaders(), body);
        return res;
    }
}