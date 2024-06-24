/**
 * @description Cancel payment authorization
*       batch job for CancelAuthorization retry
 */
public without sharing class SOM_CancelAuthorizationsBatch extends SOM_BatchJobHandler implements Database.Batchable<sObject>, Database.AllowsCallouts {
    /**
    * @description Gets configuration by the name
    * @param configurationName The name of the configuration
    */
    public SOM_CancelAuthorizationsBatch(String configurationName) {
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
    * @description batch start.
    * @param bc Database.BatchableContext
    * @return List<OrderSummary> 
    */
    public List<OrderSummary> start(Database.BatchableContext bc){
        return [SELECT 
                    OrderNumber,
                    Status,
                    CancelAuthorizationStatus__c, 
                    CancelAuthorizationRetryAttempts__c
                FROM OrderSummary 
                WHERE CancelAuthorizationStatus__c =:SOM_CancelPaymentAuthorizationConstants.AUTHORIZATION_CANCEL_REQUEST_FAILED 
                  AND (CancelAuthorizationRetryAttempts__c < :this.retryCount OR CancelAuthorizationRetryAttempts__c = NULL)];
    }

    /**
    * @description Cancel authorizations of given payment summaries
    * @param bc Database.BatchableContext
    * @param items OrderPaymentSummary order payment summaries to cancel related authorizations
    */
    public void execute(Database.BatchableContext bc, List<OrderSummary> items){
        try{
            List<SOM_CancelAuthorizationEvent__e> events = new List<SOM_CancelAuthorizationEvent__e>();
            for (OrderSummary item : items) {
                SOM_CancelAuthorizationEvent__e event = new SOM_CancelAuthorizationEvent__e();
                event.OrderSummaryId__c = item.Id;
                events.add(event);
                
                SOM_LogUtil.createInfoLog(SOM_Constants.PAYMENT, 'Creating platform event record for sending cancel authorization request for order:' + item.Id);
            }
            
            SOM_DatabaseUtil.publishEvents(events);
        }
        catch (Exception ex){
            SOM_LogUtil.createErrorLog(SOM_Constants.PAYMENT, 'An error occurred when cancelling authorizations:' + ex.getMessage() + ' --- ' + ex.getStackTraceString());
        }

        SOM_Application.commitChanges();
    }

    /**
    * @description batch finish.
    * @param bc Database.BatchableContext
    */
    @SuppressWarnings('PMD.EmptyStatementBlock')
        public void finish(Database.BatchableContext bc){
    }   
}