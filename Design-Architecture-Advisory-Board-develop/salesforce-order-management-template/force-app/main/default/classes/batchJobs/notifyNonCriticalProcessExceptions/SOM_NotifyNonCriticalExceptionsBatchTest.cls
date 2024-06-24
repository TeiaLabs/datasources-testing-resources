/**
 * @description Notifications for multiple orders with issues in SOM
 */
@isTest
private with sharing class SOM_NotifyNonCriticalExceptionsBatchTest {
    /**
    * @description Create Order & OrderSummary for tess 
    * @return Id of the OrderSummary
    */
    static String makeData() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        OrderSummary orderSummary = SOM_TestDataFactory.createOrderSummary(orderId);
        return orderSummary.Id;
    }

    /**
    * @description Tests batch class with 9 Process Exceptions whose (order summary id, attached to id, message, priority, severity) 
    *   fields are the same and status is New.
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testNewProcessExceptions() {
        List<Id> objectIdsCreatedForTesting = new List<Id>();
        Integer numberOfProcessExceptionRecords = 8;
        String orderSummaryId = makeData();
        // Creates Process Exceptions
        List<ProcessException> processExceptionList = new List<ProcessException>();
        for (Integer i = 0; i < numberOfProcessExceptionRecords; i++) {
            processExceptionList.add(new ProcessException(OrderSummaryId = orderSummaryId, AttachedToId = orderSummaryId, 
                                        Message = 'Test', Priority = 'Low', Severity = 'High', Status = 'New'));
        }
        insert processExceptionList;
        ProcessException finalProcessException = new ProcessException(OrderSummaryId = orderSummaryId, AttachedToId = orderSummaryId, 
        Message = 'Test', Priority = 'Low', Severity = 'High', Status = 'New');
        insert finalProcessException;
        objectIdsCreatedForTesting.addAll((new Map<Id,SObject>(processExceptionList)).keySet());
        // Executes Batch Class
        Test.startTest();
        SOM_NotifyNonCriticalExceptionsBatch ba= new SOM_NotifyNonCriticalExceptionsBatch('ProcessExceptionsNotification');
        Database.executeBatch(ba);
        Test.stopTest();
        List<ProcessException> voidedProcessExceptions = [SELECT Id FROM ProcessException WHERE Status = 'Voided' AND Id IN: objectIdsCreatedForTesting];
        ProcessException updatedFinalProcessException = [SELECT Status FROM ProcessException WHERE Id =: finalProcessException.Id];
        System.assertEquals(numberOfProcessExceptionRecords,  voidedProcessExceptions.size(), 'Status of the old records should be set to Voided');
        System.assertEquals('Triaged',  updatedFinalProcessException.Status, 'Status of the most recent record should be set to Triaged');
    }

    /**
    * @description Tests batch class with 9 Process Exceptions whose (order summary id, attached to id, message, priority, severity) 
    *   fields are the same and status is Manual Intervention Required.
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void testManualInterventionRequiredProcessExceptions() {
        List<Id> objectIdsCreatedForTesting = new List<Id>();
        Integer numberOfProcessExceptionRecords = 8;
        String orderSummaryId = makeData();
        // Creates Process Exceptions
        List<ProcessException> processExceptionList = new List<ProcessException>();
        for (Integer i = 0; i < numberOfProcessExceptionRecords; i++) {
            processExceptionList.add(new ProcessException(OrderSummaryId = orderSummaryId, AttachedToId = orderSummaryId, 
                                        Message = 'Test', Priority = 'Low', Severity = 'High', Status = 'Manual Intervention Required'));
        }
        insert processExceptionList;
        ProcessException finalProcessException = new ProcessException(OrderSummaryId = orderSummaryId, AttachedToId = orderSummaryId, 
        Message = 'Test', Priority = 'Low', Severity = 'High', Status = 'Manual Intervention Required');
        insert finalProcessException;
        objectIdsCreatedForTesting.addAll((new Map<Id,SObject>(processExceptionList)).keySet());
        // Executes Batch Class
        Test.startTest();
        SOM_NotifyNonCriticalExceptionsBatch ba= new SOM_NotifyNonCriticalExceptionsBatch('ProcessExceptionsNotification');
        Database.executeBatch(ba);
        Test.stopTest();
        List<ProcessException> voidedProcessExceptions = [SELECT Id FROM ProcessException WHERE Status = 'Voided' AND Id IN: objectIdsCreatedForTesting];
        ProcessException updatedFinalProcessException = [SELECT Status FROM ProcessException WHERE Id =: finalProcessException.Id];
        System.assertEquals(numberOfProcessExceptionRecords,  voidedProcessExceptions.size(), 'Status of the old records should be set to Voided');
        System.assertEquals('Manual Intervention Alerted',  updatedFinalProcessException.Status, 'Status of the most recent record should be set to Manual Intervention Alerted');
    }
}
