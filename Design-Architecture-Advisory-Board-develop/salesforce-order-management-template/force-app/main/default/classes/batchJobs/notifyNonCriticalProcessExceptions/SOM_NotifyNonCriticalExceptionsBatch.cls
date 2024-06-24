/**
 * @description Notifications for multiple orders with issues in SOM
 */
public with sharing class SOM_NotifyNonCriticalExceptionsBatch extends SOM_BatchJobHandler implements Database.Batchable<SObject>, Database.Stateful {
    static final String EMAIL_SUBJECT = 'Report of process exceptions ' + Datetime.now().format('dd/MM/yyyy hh:mm:ss');
    String emailHtmlBody = '';
    SOM_NotifyNonCriticalExceptionsHandler handler = new SOM_NotifyNonCriticalExceptionsHandler(this.querySize);
    List<SObject> allSObjectListToBeUpdated = new List<SObject>();
    List<String> recipientsList = new List<String>();

    /**
    * @description Gets configuration by the name
    * @param configurationName The name of the configuration
    */
    public SOM_NotifyNonCriticalExceptionsBatch(String configurationName) {
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
     * @return List of OrderSummary records
     */
    public List<OrderSummary> start(Database.BatchableContext bc) {
        if (!this.isActive) {
            throw new BatchJobHandlerException('Batch Configuration is not active');
        }
        // Check recipients and add to list
        for (String recipientId : this.successEmailRecipients.split(',')) {
            if (recipientId instanceof Id){  
                this.recipientsList.add(recipientId);
            }
        }
        return SOM_Selectors.orderSummary.selectByStatusCategoryAndIsCriticalFieldsOfRelatedProcessException('ACTIVE', false, this.querySize);
    }
    
    /**
     * @description Batchable interface execute method implementation
     * @param bc
     * @param orderSummaryRecordList
     */
    public void execute(Database.BatchableContext bc, List<OrderSummary> orderSummaryRecordList) {
        try {
            Set<Id> orderSummaryIds = (new Map<Id,SObject>(orderSummaryRecordList)).keySet();
            emailHtmlBody = handler.getEmailHtmlBody(new List<Id>(orderSummaryIds));
            allSObjectListToBeUpdated.addAll(handler.getAllSObjectListToBeUpdated());
        } catch (Exception e) {
            SOM_LogUtil.createErrorLog('SOM_NotifyNonCriticalExceptionsBatch', e.getMessage());
        }
        SOM_Application.commitChanges();
    }

    /**
     * @description Batchable finish method implementation
     * @param bc
     */
    public void finish(Database.BatchableContext bc) {
        // Check if there are any rows and configuration
        if (!String.isBlank(emailHtmlBody) && this.sendSuccessEmail) {
            handler.sendNotificationEmailToRecipients(recipientsList, emailHtmlBody, EMAIL_SUBJECT);
        }
        SOM_DatabaseUtil.updateRecords(allSObjectListToBeUpdated, false);
        SOM_Application.commitChanges();
    }
}