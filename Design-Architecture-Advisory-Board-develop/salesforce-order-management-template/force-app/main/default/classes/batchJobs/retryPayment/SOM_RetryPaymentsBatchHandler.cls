/**
 * @description Retry jobs for payment capture
 */
public with sharing class SOM_RetryPaymentsBatchHandler {
    
    private Map<String, ProcessException> invoiceIdToProcessException = new Map<String, ProcessException>();
    private Map<String, ProcessException> paymentIdToProcessException = new Map<String, ProcessException>();
    private Map<String, ProcessException> orderSummaryIdToProcessException = new Map<String, ProcessException>();
    private List<ProcessException> updatedProcessExceptions = new List<ProcessException>();
    private List<Invoice> updatedInvoices = new List<Invoice>();
    private Integer batchSize;
    private Boolean isActive;
    private Integer querySize;
    private Integer retryCount;

    /**
    * @description Gets configuration
    * @param isActive is configuration active
    * @param querySize query limits
    * @param retryCount retry count
    */
    public SOM_RetryPaymentsBatchHandler(Boolean isActive, Integer querySize, Integer retryCount){
        this.isActive = isActive;
        this.querySize = querySize;
        this.retryCount = retryCount;
    }

    /**
    * @description get private updatedInvoices
    * @return List of Invoice
    */

    public List<Invoice> getUpdatedInvoices(){
        return this.updatedInvoices;
    }

    /**
    * @description get private updatedProcessExceptions
    * @return List of ProcessException
    */

    public List<ProcessException> getUpdatedProcessExceptions(){
        return this.updatedProcessExceptions;
    }

    /**
    * @description Manages to invoke the handle
    * @param processExceptions List of ProcessException
    */

    public void manage(List<ProcessException> processExceptions){
        mapAttachedToIdToProcessException(processExceptions);
        addOrderPaymentSummaryOrPaymentRelatedProcessExceptionsToMap();
        retryEnsureFundsAndUpdateStatus();
    }

    /**
    * @description maps attachedIds with ProcessExceptions
    * @param processExceptions List of ProcessException
    */

    private void mapAttachedToIdToProcessException(List<ProcessException> processExceptions){
        for(ProcessException processExc : processExceptions){
            Schema.SObjectType attachedObjectType = processExc.AttachedToId.getSObjectType();
            if(attachedObjectType == Invoice.sObjectType){
                this.invoiceIdToProcessException.put(processExc.AttachedToId, processExc);
            }else if(attachedObjectType == Payment.sObjectType || attachedObjectType == OrderPaymentSummary.sObjectType){
                this.orderSummaryIdToProcessException.put(processExc.OrderSummaryId, processExc);
            }
        }
    }

    /**
    * @description maps InvoiceId with related ProcessExceptions for OrderPaymentSummary Related ProcessExceptions
    */

    private void addOrderPaymentSummaryOrPaymentRelatedProcessExceptionsToMap() {
        List<String> orderSummaryIds = new List<String>(this.orderSummaryIdToProcessException.keyset());
        for(Invoice relatedInvoice : SOM_Selectors.invoice.selectByReferenceEntityIdsAndStatus(orderSummaryIds, 'Posted', this.querySize)) {
            ProcessException relatedProcessException = this.orderSummaryIdToProcessException.get(relatedInvoice.ReferenceEntityId);
            Decimal amount = this.getPaymentAmountFromProcessExceptionDescription(relatedProcessException);
            if(amount == relatedInvoice.Balance && !this.invoiceIdToProcessException.keyset().contains(relatedInvoice.Id)){
                this.invoiceIdToProcessException.put(relatedInvoice.Id, relatedProcessException);
            }
        }
    }

    /**
    * @description retries ensuring funds and update status of processExceptions
    */

    private void retryEnsureFundsAndUpdateStatus(){
        List<String> invoiceIds = new List<String>(this.invoiceIdToProcessException.keyset());
        for(Invoice relatedInvoice : SOM_Selectors.invoice.selectByIds(invoiceIds, this.querySize)){
            ProcessException processExc = this.invoiceIdToProcessException.get(relatedInvoice.Id);
            if(processExc.OrderSummaryId == NULL && processExc.AttachedToId.getSObjectType() == Invoice.sObjectType){
                processExc.OrderSummaryId = relatedInvoice.ReferenceEntityId;
            }
            if(relatedInvoice.NumberOfRetries__c >= this.retryCount){
                processExc.Status = 'Manual Intervention Required';
            }else{
                this.retryPaymentEnsureFunds(relatedInvoice.Id, processExc.OrderSummaryId);
                processExc.Status = 'Resolved';
                relatedInvoice.NumberOfRetries__c += 1;
                this.updatedInvoices.add(relatedInvoice);
            }
            this.updatedProcessExceptions.add(processExc);
        }
    }
    
    /**
    * @description parses Payment amount from description field of ProcessException
    * @param processException ProcessException to parse
    * @return PaymentAmount Decimal
    */

    private Decimal getPaymentAmountFromProcessExceptionDescription(ProcessException processException) {
        Pattern amountPattern = Pattern.compile('[\\$\\£\\€USDUERGBP ](\\d+(?:\\.\\d+)?)');
        Matcher amountMatcher = amountPattern.matcher(processException.Description.replaceAll(',', ''));
        amountMatcher.find();
        return Decimal.valueOf(amountMatcher.group(1));
    }

    /**
    * @description ensures funds and adds errors occured during process to errorLogs list
    *  @param invoiceId
    *  @param orderSummaryId
    */

    private  void retryPaymentEnsureFunds(Id invoiceId, Id orderSummaryId) {
        ConnectApi.EnsureFundsAsyncInputRepresentation ensureFundsInput = new ConnectApi.EnsureFundsAsyncInputRepresentation();
        ensureFundsInput.invoiceId = invoiceId;
        ConnectApi.BaseOutputRepresentation ensureFundsOutput = SOM_Services.orderSummary.ensureFundsAsync(orderSummaryId, ensureFundsInput);
        if( ensureFundsOutput.errors.size() > 0 ){
            for (ConnectApi.ErrorResponse errorResponse : ensureFundsOutput.errors) {
                SOM_LogUtil.createErrorLog('SOM_RetryPaymentsBatch', errorResponse.message);
            }
        }
    }
}
