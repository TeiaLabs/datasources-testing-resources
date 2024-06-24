/**
* @description Handler class for batches and 
*   scheduled jobs
*/
public with sharing virtual class SOM_BatchJobHandler {
    private SOM_BatchConfiguration__mdt configuration;
    @testVisible
    protected Integer batchSize;
    @testVisible
    protected Boolean isActive;
    @testVisible
    protected Integer querySize;
    @testVisible
    protected Integer retryCount;
    @testVisible
    protected Boolean sendErrorEmail;
    @testVisible
    protected String errorEmailRecipients;
    @testVisible
    protected Boolean sendSuccessEmail;
    @testVisible
    protected String successEmailRecipients;

    /**
    * @description Gets configuration by the name
    * @param configurationName The name of the configuration
    */
    public SOM_BatchJobHandler(String configurationName) {
        this.configuration = Test.isRunningTest() 
            ? SOM_TestDataFactory.createSOMBatchConfigurationRecord()
            : SOM_BatchConfiguration__mdt.getInstance(configurationName);
            
        if (configuration == null) {
            throw new BatchJobHandlerException('Missing configuration: ' + configurationName);
        }     
        
        this.isActive = configuration.IsActive__c;
        this.batchSize = Integer.valueOf(configuration.BatchSize__c);
        this.querySize = Integer.valueOf(configuration.QuerySize__c);
        this.retryCount = Integer.valueOf(configuration.RetryCount__c);
        this.sendErrorEmail = Boolean.valueOf(configuration.SendErrorEmail__c);
        this.errorEmailRecipients = configuration.ErrorEmailRecipients__c;
        this.sendSuccessEmail = Boolean.valueOf(configuration.SendSuccessEmail__c);
        this.successEmailRecipients = configuration.SuccessEmailRecipients__c;
    }

    /**
    * @description Send success email if enabled
    * @return List of Messaging.SendEmailResult
    */
    @testVisible
    protected List<Messaging.SendEmailResult> sendSuccessEmail() {
        return configuration.SendSuccessEmail__c 
            ? SOM_EmailUtil.sendEmail(configuration.SuccessEmailRecipients__c.split(','), SOM_Constants.SUCCESS, SOM_Constants.SUCCESS, false)
            : new List<Messaging.SendEmailResult>();
    }

    /**
    * @description Send error email if enabled
    * @param errorMessage The error message
    * @return List of Messaging.SendEmailResult
    */
    @testVisible
    protected List<Messaging.SendEmailResult> sendErrorEmail(String errorMessage) {
        return configuration.SendErrorEmail__c
            ? SOM_EmailUtil.sendEmail(configuration.ErrorEmailRecipients__c.split(','), SOM_Constants.ERROR, errorMessage, false)
            : new List<Messaging.SendEmailResult>();
    }

    /**
    * @description Batch job handler exception 
    */
    public class BatchJobHandlerException extends Exception { }
}