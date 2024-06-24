/**
* @description DatabaseUtil test class
*/
@isTest
private class SOM_DatabaseUtilTest {
    /**
    * @description Test method of DatabaseUtil.insertRecords
    */
    @isTest
    static void shouldInsertRecord() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contactToInsert = SOM_TestDataFactory.createContact(contactInput);

        Test.startTest();
        SOM_DatabaseUtil.insertRecords(contactToInsert, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'No contact record found');
    }

    /**
    * @description Test method of DatabaseUtil.insertRecords
    */
    @isTest
    static void shouldInsertRecords() {
        SOM_TestDataInput.ContactInput contactInput1 = new SOM_TestDataInput.ContactInput();
        contactInput1.lastName = SOM_Constants.TEST + '1';
        SOM_TestDataInput.ContactInput contactInput2 = new SOM_TestDataInput.ContactInput();
        contactInput2.lastName = SOM_Constants.TEST + '2';

        Contact[] contactsToInsert = new List<Contact>
        {
            SOM_TestDataFactory.createContact(contactInput1),
            SOM_TestDataFactory.createContact(contactInput2)
        };

        Test.startTest();
        SOM_DatabaseUtil.insertRecords(contactsToInsert, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput1.lastName OR LastName = :contactInput2.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(contactsToInsert.size() == contacts.size(), 'Contact record does not match');
    }

    /**
    * @description Test method of DatabaseUtil.updateRecords
    */
    @isTest
    static void shouldUpdateRecord() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        contact.LastName = contactInput.lastName + '1';

        Test.startTest();
        SOM_DatabaseUtil.updateRecords(contact, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contact.LastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'No contact record found');
    }

    /**
    * @description Test method of DatabaseUtil.updateRecords
    */
    @isTest
    static void shouldUpdateRecords() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        contact.LastName = contactInput.lastName + '1';

        Test.startTest();
        SOM_DatabaseUtil.updateRecords(new List<Contact>{ contact }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contact.LastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'No contact record found');
    }

    /**
    * @description Test method of DatabaseUtil.upsertRecords
    */
    @isTest
    static void shouldUpsertRecord() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        contact.LastName = contactInput.lastName + '1';

        Test.startTest();
        SOM_DatabaseUtil.upsertRecords(contact, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contact.LastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'No contact record found');
    }

    /**
    * @description Test method of DatabaseUtil.upsertRecords
    */
    @isTest
    static void shouldUpsertRecords() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        contact.LastName = contactInput.lastName + '1';

        Test.startTest();
        SOM_DatabaseUtil.upsertRecords(new List<Contact>{ contact }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contact.LastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'No contact record found');
    }

    /**
    * @description Test method of DatabaseUtil.deleteRecord
    */
    @isTest
    static void shouldDeleteRecord() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        Test.startTest();
        SOM_DatabaseUtil.deleteRecords(contact.Id, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(contacts.isEmpty(), 'Records are not deleted');
    }

    /**
    * @description Test method of DatabaseUtil.deleteRecords
    */
    @isTest
    static void shouldDeleteRecords() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        Test.startTest();
        SOM_DatabaseUtil.deleteRecords(new List<String>{ contact.Id }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(contacts.isEmpty(), 'Records are not deleted');
    }

    /**
    * @description Test method of DatabaseUtil.undeleteRecord
    */
    @isTest
    static void shouldUndeleteRecord() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;
        delete contact;

        Test.startTest();
        SOM_DatabaseUtil.undeleteRecords(contact.Id, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'Records are not undeleted');
    }

    /**
    * @description Test method of DatabaseUtil.undeleteRecords
    */
    @isTest
    static void shouldUndeleteRecords() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;
        delete contact;

        Test.startTest();
        SOM_DatabaseUtil.undeleteRecords(new List<String>{ contact.Id }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :contactInput.lastName];
        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(logs.isEmpty(), 'Logs should not be created');
        System.assert(!contacts.isEmpty(), 'Records are not undeleted');
    }

/**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for Insert/Update
    */
    @isTest
    static void shouldInsertDatabaseErrorForInsert() {
        Contact contact = new Contact();

        Test.startTest();
        SOM_DatabaseUtil.insertRecords(contact, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for List Insert/Update
    */
    @isTest
    static void shoulInsertDatabaseErrorsForInsert() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact2 = new Contact();

        Contact[] contacts = new List<Contact>
        {
            SOM_TestDataFactory.createContact(contactInput),
            contact2
        };

        Test.startTest();
        SOM_DatabaseUtil.insertRecords(contacts, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }
    
    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for Upsert
    */
    @isTest
    static void shouldInsertDatabaseErrorForUpsert() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contactToUpdate = SOM_TestDataFactory.createContact(contactInput);
        insert contactToUpdate;

        contactToUpdate.LastName = '';

        Test.startTest();
        SOM_DatabaseUtil.upsertRecords(contactToUpdate, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for List Upsert
    */
    @isTest
    static void shouldInsertDatabaseErrorsForUpsert() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contactToUpdate = SOM_TestDataFactory.createContact(contactInput);
        insert contactToUpdate;

        contactToUpdate.LastName = '';

        Test.startTest();
        SOM_DatabaseUtil.upsertRecords(new List<Contact>{ contactToUpdate }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for Delete
    */
    @isTest
    static void shouldInsertDatabaseErrorForDelete() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;
        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;
        delete contact;

        Test.startTest();
        SOM_DatabaseUtil.deleteRecords(contact.Id, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for List Delete
    */
    @isTest
    static void shouldInsertDatabaseErrorsForDelete() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;

        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;
        delete contact;

        Test.startTest();
        SOM_DatabaseUtil.deleteRecords(new List<String>{ contact.Id }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    */
    @isTest
    static void shouldInsertDatabaseErrorForUndelete() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;
        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        Test.startTest();
        SOM_DatabaseUtil.undeleteRecords(contact.Id, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }

    /**
    * @description Test method of LogUtil.insertDatabaseErrors
    *   for List Delete
    */
    @isTest
    static void shouldInsertDatabaseErrorsForUndelete() {
        SOM_TestDataInput.ContactInput contactInput = new SOM_TestDataInput.ContactInput();
        contactInput.lastName = SOM_Constants.TEST;
        Contact contact = SOM_TestDataFactory.createContact(contactInput);
        insert contact;

        Test.startTest();
        SOM_DatabaseUtil.undeleteRecords(new List<String>{ contact.Id }, false);
        SOM_Application.commitChanges();
        Test.stopTest();

        List<SOM_Log__c> logs = [SELECT Id FROM SOM_Log__c];

        System.assert(!logs.isEmpty(), 'Error log could not found');
    }
}