/**
 * @description Retry fail batch request handler
 */
public with sharing class SOM_RetryFailedRequestsBatchHandler {

    private List<SObject> allSObjectListToBeUpdated = new List<SObject>();
    private List<Id> allSObjectIdListToBeDeleted = new List<Id>();
    
    /**
    * @description get allSObjectListToBeUpdated
    * @return List of Sobjects
    */

    public List<SOM_FailedRequest__c> getAllSObjectListToBeUpdated() {
        return this.allSObjectListToBeUpdated;
    }

    /**
    * @description get allSObjectIdListToBeDeleted
    * @return List of Ids
    */

    public List<Id> getAllSObjectIdListToBeDeleted() {
        return this.allSObjectIdListToBeDeleted;
    }
    
    /**
    * @description updates status field of FailedRequests to "IN PROGRESS"
    * @param failedRequests List of FailedRequests
    */
    public void updateStatusToInProgress(List<SOM_FailedRequest__c> failedRequests) {
        List<SOM_FailedRequest__c> failedRequestInProgress = new List<SOM_FailedRequest__c>();
        
        for(SOM_FailedRequest__c failedRequest : failedRequests) {
            failedRequest.Status__c = 'IN PROGRESS';
            failedRequestInProgress.add(failedRequest);
        }
        
        SOM_DatabaseUtil.updateRecords(failedRequestInProgress, false);
        SOM_Application.commitChanges();
    }
    
    /**
    * @description Manages to invoke the handle
    * @param failedRequestRecordList List of FailedRequests
    */
    public void manage(List<SOM_FailedRequest__c> failedRequestRecordList) {
        for(SOM_FailedRequest__c failedRequest : failedRequestRecordList) {
            if(retryFailedRequest(failedRequest)) {
                this.allSObjectIdListToBeDeleted.add(failedRequest.Id);
            } else {
                failedRequest.Status__c = 'NOT STARTED';
                failedRequest.RetryAttempts__c +=1;
                this.allSObjectListToBeUpdated.add(failedRequest);
            }
        }
    }

    /**
    * @description Retries failed request
    * @param failedRequest failed Request
    * @return Returns whether the response was successfully handled
    */
    private Boolean retryFailedRequest(SOM_FailedRequest__c failedRequest) {
        // Create request instance and cast it to SOM_AbstractRequest
        SOM_AbstractRequest request = (SOM_AbstractRequest) Type.forName(failedRequest.Name).newInstance();
        // Send request
        HttpResponse result = request.process(failedRequest);
        // Handle Response
        Boolean isResponseHandledSuccessfully = request.handleResponse(result);
        return isResponseHandledSuccessfully;
    }
}
