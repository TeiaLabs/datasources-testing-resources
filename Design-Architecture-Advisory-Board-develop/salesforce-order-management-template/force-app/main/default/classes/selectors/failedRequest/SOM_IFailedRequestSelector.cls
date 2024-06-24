/**
* @description FailedRequest selector interface
*/
public interface SOM_IFailedRequestSelector {
    /**
    * @description Selects FailedRequest records based on the avaibility of retry and status
    * @param isRetryAttemptLimitReached is retry attempt limit reached 
    * @param status status of failedRequest
    * @param querySize query limit
    * @return List of FailedRequest
    */
    List<SOM_FailedRequest__c> selectByAvaibilityOfRetryAndStatus(Boolean isRetryAttemptLimitReached, String status, Integer querySize);
}
