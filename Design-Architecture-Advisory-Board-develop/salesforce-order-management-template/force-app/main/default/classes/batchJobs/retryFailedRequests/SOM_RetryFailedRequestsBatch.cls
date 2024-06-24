/**
 * @description HTTP retry logic
 */
public with sharing class SOM_RetryFailedRequestsBatch extends SOM_BatchJobHandler implements Schedulable, Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    
    List<SObject> allSObjectListToBeUpdated = new List<SObject>();
    List<Id> allSObjectIdListToBeDeleted = new List<String>();
    SOM_RetryFailedRequestsBatchHandler handler = new SOM_RetryFailedRequestsBatchHandler();

    /**
    * @description Gets configuration by the name
    * @param configurationName The name of the configuration
    */
    public SOM_RetryFailedRequestsBatch(String configurationName) {
        super(configurationName);
    }

    /**
     * @description Schedulable interface execute method implementation
     * @param sc
    */
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this, this.batchSize);
    }

    /**
     * @description Batchable interface start method implementation
     * @param bc
     * @return List of SOM_FailedRequest__c records
    */
    public List<SOM_FailedRequest__c> start(Database.BatchableContext bc) {
        if (!this.isActive) {
            throw new BatchJobHandlerException('Batch Configuration is not active');
        }
        List<SOM_FailedRequest__c> failedRequests = SOM_Selectors.failedRequest.selectByAvaibilityOfRetryAndStatus(false, 'NOT STARTED', this.querySize);
        handler.updateStatusToInProgress(failedRequests);
        return failedRequests;
    }

    /**
     * @description Batchable interface execute method implementation
     * @param bc
     * @param failedRequestRecordList
    */
    public void execute(Database.BatchableContext bc, List<SOM_FailedRequest__c> failedRequestRecordList) {
        try {
            handler.manage(failedRequestRecordList);
            allSObjectListToBeUpdated.addAll(handler.getAllSObjectListToBeUpdated());
            allSObjectIdListToBeDeleted.addAll(handler.getAllSObjectIdListToBeDeleted());
        } catch (Exception e) {
            for (SOM_FailedRequest__c failedRequest : failedRequestRecordList) {
                failedRequest.Status__c = 'NOT STARTED';
                allSObjectListToBeUpdated.add(failedRequest);
            }
            SOM_LogUtil.createErrorLog('SOM_RetryFailedRequestsBatch', e.getMessage());
        }
        
        SOM_Application.commitChanges();
    }
    
    /**
    * @description Batchable finish method implementation
    * @param bc
    */
    public void finish(Database.BatchableContext bc) {
        SOM_DatabaseUtil.updateRecords(allSObjectListToBeUpdated, false);
        SOM_DatabaseUtil.deleteRecords(allSObjectIdListToBeDeleted, false);
        SOM_Application.commitChanges();
    }
}