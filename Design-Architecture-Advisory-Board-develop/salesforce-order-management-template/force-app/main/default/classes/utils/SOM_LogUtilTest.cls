/**
* @description LogUtil test class
*/
@isTest
private class SOM_LogUtilTest {
    /**
    * @description Test method of LogUtil.createErrorLog
    */
    @isTest
    static void shouldLogErrorWithAttachId() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contactToInsert = SOM_TestDataFactory.createContact(contactInput);
        insert contactToInsert;

        String attachId = contactToInsert.Id;

        Test.startTest();
        SOM_Log__c insertedLog = SOM_LogUtil.createErrorLog(attachId, category, message);
        SOM_Application.commitChanges();
        Test.stopTest();

        SOM_Log__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM SOM_Log__c WHERE Id = :insertedLog.Id];

        System.assert(log.AttachedToId__c.equals(attachId), 'Attached to Id does not match');
        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log does not match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log does not match');
        System.assert(log.IsError__c, 'IsError should be checked/true');
    }

    /**
    * @description Test method of LogUtil.createErrorLog
    */
    @isTest
    static void shouldLogError() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        Test.startTest();
        SOM_Log__c insertedLog = SOM_LogUtil.createErrorLog(category, message);
        SOM_Application.commitChanges();
        Test.stopTest();

        SOM_Log__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM SOM_Log__c WHERE Id = :insertedLog.Id];

        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log does not match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log does not match');
        System.assert(log.IsError__c, 'IsError should be checked/true');
    }

    /**
    * @description Test method of LogUtil.createInfoLog
    */
    @isTest
    static void shouldLogInfoWithAttachId() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contactToInsert = SOM_TestDataFactory.createContact(contactInput);
        insert contactToInsert;

        String attachId = contactToInsert.Id;

        Test.startTest();
        SOM_Log__c insertedLog = SOM_LogUtil.createInfoLog(attachId, category, message);
        SOM_Application.commitChanges();
        Test.stopTest();

        SOM_Log__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM SOM_Log__c WHERE Id = :insertedLog.Id];

        System.assert(log.AttachedToId__c.equals(attachId), 'Attached to Id does not match');
        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log does not match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log does not match');
        System.assert(!log.IsError__c, 'IsError should be unchecked/false');
    }

    /**
    * @description Test method of LogUtil.createInfoLog
    */
    @isTest
    static void shouldLogInfo() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        Test.startTest();
        SOM_Log__c insertedLog = SOM_LogUtil.createInfoLog(category, message);
        SOM_Application.commitChanges();
        Test.stopTest();

        SOM_Log__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM SOM_Log__c WHERE Id = :insertedLog.Id];

        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log does not match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log does not match');
        System.assert(!log.IsError__c, 'IsError should be unchecked/false');
    }

    /**
    * @description Test method of LogUtil.createEmailErrors
    */
    @isTest
    static void shouldCreateEmailErrors() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Subject');

        Test.startTest();
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
        SOM_LogUtil.createEmailErrors(results);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for ConnectApi error
    */
    @isTest
    static void shouldInsertConnectApiError() {
        ConnectApi.OrderSummaryOutputRepresentation output = SOM_TestDataFactory.createConnectApiError();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for OCI Base ConnectApi error
    */
    @isTest
    static void shouldInsertOCIGetInventoryAvailabilityConnectApiError() {
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = SOM_OmnichannelInventoryTestDataFactory.createFailedInventoryAvailabilityOutputRepresentation();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for OCI Create Reservation ConnectApi error
    */
    @isTest
    static void shouldInsertOCICreateReservationConnectApiError() {
        ConnectApi.OCICreateReservationOutputRepresentation output = SOM_OmnichannelInventoryTestDataFactory.createFailedCreateReservationOutput();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for OCI Fulfill Reservation ConnectApi error
    */
    @isTest
    static void shouldInsertOCIFulfillReservationConnectApiError() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = SOM_OmnichannelInventoryTestDataFactory.createFailedFulfillReservationOutput();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for OCI Release Reservation ConnectApi error
    */
    @isTest
    static void shouldInsertOCIReleaseReservationConnectApiError() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = SOM_TestDataFactory.createOCIReleaseReservationConnectApiError();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.createConnectApiErrors
    *   for OCI Transfer Reservation ConnectApi error
    */
    @isTest
    static void shouldInsertOCITransferReservationConnectApiError() {
        ConnectApi.OCITransferReservationOutputRepresentation output = SOM_TestDataFactory.createOCITransferReservationConnectApiError();

        Test.startTest();
        SOM_LogUtil.createConnectApiErrors(output);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }
}