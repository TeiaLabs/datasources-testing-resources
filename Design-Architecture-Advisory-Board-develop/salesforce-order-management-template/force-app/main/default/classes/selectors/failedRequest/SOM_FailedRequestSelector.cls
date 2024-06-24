/**
* @description FailedRequest selector class
*/
public with sharing class SOM_FailedRequestSelector implements SOM_IFailedRequestSelector {
    /**
    * @description Selects FailedRequest records based on the avaibility of retry and status
    * @param isRetryAttemptLimitReached is retry attempt limit reached 
    * @param status status of failedRequest
    * @param querySize query limit
    * @return List of FailedRequest
    */
    public List<SOM_FailedRequest__c> selectByAvaibilityOfRetryAndStatus(Boolean isRetryAttemptLimitReached, String status, Integer querySize) {
        return [SELECT 
                    Id,
                    Name,
                    Data__c,
                    RegenerateData__c,
                    RetryAttempts__c,
                    RegenerateDataParameter__c
                FROM SOM_FailedRequest__c 
                WHERE IsRetryAttemptLimitReached__c =: isRetryAttemptLimitReached
                AND Status__c =: status
                WITH SECURITY_ENFORCED
                LIMIT :querySize];
    }
}