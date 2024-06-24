/** 
* @description  : Purge jobs for old oms data | Batch class 
*/
public with sharing class SOM_PurgeOldOmsDataBatch extends SOM_BatchJobHandler implements Database.Batchable<SObject>, Schedulable {
    private SOM_PurgeSetting__mdt purgeSetting = new SOM_PurgeSetting__mdt(); 
    private Integer daysOldAllStatus;
    private Integer daysOldApprovedStatus;
    private Integer daysOldFulfilledStatus;
    private String customApprovedStatus;
    private String customFulfilledStatus;
    private Boolean paymentGatewayLogs;
    private Datetime dateDaysOldAllStatus;       
    private Datetime dateDaysOldApprovedStatus;  
    private Datetime dateDaysOldFulfilledStatus; 
    /**
    * @description sends the value of batch to the SOM_BatchJobHandler class
    * @param configurationName name of the configuration
    */
    public SOM_PurgeOldOmsDataBatch(String configurationName) {
        super(configurationName);  

        this.purgeSetting = Test.isRunningTest()
        ? SOM_TestDataFactory.createSOMPurgeSettingRecord()
        : SOM_PurgeSetting__mdt.getInstance(configurationName);
        
        this.daysOldAllStatus = Integer.valueOf(-purgeSetting.DaysOldAllStatus__c);
        this.daysOldApprovedStatus = Integer.valueOf(-purgeSetting.DaysOldApprovedStatus__c);
        this.daysOldFulfilledStatus = Integer.valueOf(-purgeSetting.DaysOldFulfilledStatus__c);

        this.customApprovedStatus = purgeSetting.CustomApprovedStatus__c;
        this.customFulfilledStatus = purgeSetting.CustomFulfilledStatus__c;
        this.paymentGatewayLogs = purgeSetting.PurgePaymentGatewayLogs__c;

        this.dateDaysOldAllStatus= Datetime.now().addDays(daysOldAllStatus);
        this.dateDaysOldApprovedStatus= Datetime.now().addDays(daysOldApprovedStatus);
        this.dateDaysOldFulfilledStatus= Datetime.now().addDays(daysOldFulfilledStatus);
    }

    /**
    * @description Schedulable interface execute method implementation
    * @param sc
    */
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this, this.batchSize);
    }
      
    /**
    * @description gets the order summaries that is required
    * @param bc
    * @return List of order summaries   
    */
	public List<OrderSummary> start(Database.BatchableContext bc) { 
        if (!this.isActive) {
            throw new BatchJobHandlerException('Batch Configuration is not active');
        }
            
        return SOM_Selectors.orderSummary.selectByStatusAndLastModifiedDate(customApprovedStatus,dateDaysOldApprovedStatus, customFulfilledStatus, dateDaysOldFulfilledStatus, dateDaysOldAllStatus, this.querySize);
    }
    
    /**
    * @description collects Ids of objects from the order summary which is queried
    * @param bc
    * @param orderSummariesToBePurged is the list of order summaries which is queried
    */
    public void execute(Database.BatchableContext bc, List<OrderSummary> orderSummariesToBePurged) { 
       SOM_PurgeOldOmsDataBatchHandler.purgeOldOmsRecords(orderSummariesToBePurged, paymentGatewayLogs);
    }
    
    /**
    * @description deletes the old data and sends the error if there is a mistake
    * @param bc
    *     suppress reason : We have managed to do our deleteion on execute 
    */    
    @suppressWarnings('PMD.EmptyStatementBlock')
    public void finish(Database.BatchableContext bc) {         
       
    }
}