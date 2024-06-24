/**
 * @description Retry jobs for payment capture
 */
public with sharing class SOM_RetryPaymentsBatch extends SOM_BatchJobHandler implements Schedulable, Database.Batchable<SObject>, Database.Stateful {


    private List<ProcessException> updatedProcessExceptions = new List<ProcessException>();
    private List<Invoice> updatedInvoices = new List<Invoice>();

    /**
    * @description Gets configuration by the name
    * @param configurationName The name of the configuration
    */
    public SOM_RetryPaymentsBatch(String configurationName) {
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
     * @return List of ProcessException records
    */
    public List<ProcessException> start(Database.BatchableContext bc){
        if (!this.isActive) {
            throw new BatchJobHandlerException('Batch Configuration is not active');
        }
        return SOM_Selectors.processException.selectByCategoryStatusAndMessage('Payment', 'New', new List<String>{ 'Unable to Apply Payment', 'Unable to Capture Payment'}, super.querySize);
    }

    /**
     * @description Batchable interface execute method implementation
     * @param bc
     * @param processExceptionList 
     */
    public void execute(Database.BatchableContext bc, List<ProcessException> processExceptionList){
        try {
            SOM_RetryPaymentsBatchHandler handler = new SOM_RetryPaymentsBatchHandler(this.isActive, this.querySize, this.retryCount);
            handler.manage(processExceptionList);
            updatedProcessExceptions.addAll(handler.getUpdatedProcessExceptions());
            updatedInvoices.addAll(handler.getUpdatedInvoices());
        } catch (Exception e) {
            SOM_LogUtil.createErrorLog('SOM_RetryPaymentsBatch', e.getMessage());
        }
        SOM_Application.commitChanges();
    }

    /**
    * @description Batchable finish method implementation
    * @param bc
    */
    public void finish(Database.BatchableContext bc){
        SOM_DatabaseUtil.updateRecords(updatedProcessExceptions, false);
        SOM_DatabaseUtil.updateRecords(updatedInvoices, false);
        SOM_Application.commitChanges();
    }
}