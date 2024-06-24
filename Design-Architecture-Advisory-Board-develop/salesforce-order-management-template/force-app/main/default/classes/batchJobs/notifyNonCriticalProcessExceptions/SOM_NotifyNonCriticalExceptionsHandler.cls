/**
 * @description Notifications for multiple orders with issues in SOM
 *      Although this class is handler of SOM_NotifyNonCriticalExceptionsBatch,
 *      due to the naming limitations  of SF it is 
 *      named as SOM_NotifyNonCriticalExceptionsHandler
 */
public with sharing class SOM_NotifyNonCriticalExceptionsHandler {
    
    static final String LINKSTYLE = 'style="text-decoration:none;"';
    static final String HEADERROW = '<tr><th>Order Summary Id</th><th>Attached To Id</th><th>Message</th><th>Priority</th><th>Severity</th><th>Max Created Date</th><th>Number Of Occurrences</th></tr>';
    private Map<String, ProcessException> tableRowToProcessException = new Map<String, ProcessException>();
    private Map<String, Decimal> tableRowToNumberOfOccurrences = new Map<String, Decimal>();
    private List<SObject> allSObjectListToBeUpdated = new List<SObject>();
    private Integer querySize;

    /**
    * @description Gets configuration
    * @param querySize query limits
    */
    public SOM_NotifyNonCriticalExceptionsHandler(Integer querySize){
        this.querySize = querySize;
    }

    /**
    * @description get private allSObjectListToBeUpdated
    * @return List of SObject
    */

    public List<SObject> getAllSObjectListToBeUpdated(){
        return this.allSObjectListToBeUpdated;
    }

    /**
    * @description generates direct Salesforce link to object
    * @param idToProccess object Id
    * @return directSalesforceLink | String
    */
    private String getSobjectLink(Id idToProccess){
        String sobjectType = idToProccess.getSObjectType().getDescribe(SObjectDescribeOptions.FULL).getName();
        return System.URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/'+ sobjectType +'/' + (String) idToProccess + '/view';
    }

    /**
    * @description generates an html table rows using fields of Process Exception
    * @param processException Process Exception
    * @return HTML Table Row | String
    */

    private String createTableRowFromProcessException(ProcessException processException){
        return '<td><a '+ LINKSTYLE +' href="'+ getSobjectLink(processException.OrderSummaryId) +'">' + (String)processException.OrderSummaryId + '</a></td>' + '<td><a '+ LINKSTYLE +'href="'+ getSobjectLink(processException.AttachedToId) +'">' + (String)processException.AttachedToId + '</a></td>'
                +'<td>' + processException.Message + '</td>' + '<td>' + processException.Priority + '</td>'
                +'<td>' + processException.Severity + '</td>';
    }

    private Map<String,String> returnStatusToNewStatusMap(){
        Map<String, String> statusToNewStatus = new Map<String, String>();
        statusToNewStatus.put(SOM_ProcessExceptionStatus.NEW_C.toString(), SOM_ProcessExceptionStatus.TRIAGED.toString());
        statusToNewStatus.put(SOM_ProcessExceptionStatus.MANUAL_INTERVENTION_REQUIRED.toString(), SOM_ProcessExceptionStatus.MANUAL_INTERVENTION_ALERTED.toString());
        return statusToNewStatus;
    }

    /**
    * @description Manages to invoke the handle 
    * @param orderSummaryIds | List of Ids
    * @return EmailHtmlBody | String
    */

    public String getEmailHtmlBody(List<Id> orderSummaryIds){
        List<ProcessException> processExceptionRecordList = SOM_Selectors.processException.selectByOrderSummaryIdStatusAndIsCritical(orderSummaryIds, new List<String>{SOM_ProcessExceptionStatus.NEW_C.toString(), SOM_ProcessExceptionStatus.MANUAL_INTERVENTION_REQUIRED.toString()}, false, this.querySize);
        return this.createTable(processExceptionRecordList);
    }

    /**
    * @description creates a html table using processExceptions fields
    * @param processExceptions | List of processException
    * @return HTMLtable | String
    */

    private String createTable(List<ProcessException> processExceptions){
        // Creates Rows
        Map<String,String> statusToNewStatus = returnStatusToNewStatusMap();
        for (ProcessException processException : processExceptions){
            String processExceptionRow = createTableRowFromProcessException(processException);
            if (tableRowToProcessException.containsKey(processExceptionRow)){
                // Increaments number of occurrances
                tableRowToNumberOfOccurrences.put(processExceptionRow, tableRowToNumberOfOccurrences.get(processExceptionRow) + 1);
                ProcessException processedProcessException = tableRowToProcessException.get(processExceptionRow);
                if (processException.CreatedDate >= processedProcessException.CreatedDate){
                    // Updates max created date
                    tableRowToProcessException.put(processExceptionRow, processException);
                    processedProcessException.status = SOM_ProcessExceptionStatus.VOIDED.toString();
                    allSObjectListToBeUpdated.add(processedProcessException);
                }
            } else {
                // Creates Row
                tableRowToProcessException.put(processExceptionRow, processException);
                tableRowToNumberOfOccurrences.put(processExceptionRow, 1);
            }
        }

        // Checks whether there are any rows
        if (tableRowToProcessException.values().size() == 0) {
            return '';
        }
        
        // Creates table using rows
        String table = '<table style="width:100%">' + HEADERROW;
        for (String tableRow : tableRowToProcessException.keySet()) {
            table+='<tr>';
            ProcessException finalProcessException = tableRowToProcessException.get(tableRow);
            if (statusToNewStatus.containsKey(finalProcessException.status)){
                finalProcessException.status = statusToNewStatus.get(finalProcessException.status);
                allSObjectListToBeUpdated.add(finalProcessException);
            }
            table += tableRow + '<td>' + String.valueof(finalProcessException.CreatedDate) + '</td>' + '<td>' + String.valueof(tableRowToNumberOfOccurrences.get(tableRow)) + '</td></tr>';
        }
        return table + '</table>';
    }

    /**
    * @description sends email to recipients
    * @param recipientIds recipientId list
    * @param htmlBody 
    * @param subject email subject
    */
    public void sendNotificationEmailToRecipients(List<Id> recipientIds, String htmlBody, String subject){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for (Id recipientId : recipientIds) {
            if (recipientId.getSObjectType() == User.getSObjectType()) {  
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(recipientId);
                email.setHtmlBody(htmlBody);
                email.setSubject(subject);
                email.setSaveAsActivity(false);
                emailList.add(email);
            }
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList, false);
        SOM_LogUtil.createEmailErrors(results);
        SOM_Application.commitChanges();
    }
}