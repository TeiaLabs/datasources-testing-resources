/**
* @description EmailUtil test class
*/
@isTest
private class SOM_EmailUtilTest {
    /**
    * @description Test method of EmailUtil.sendEmail HTML body
    */
    @isTest
    static void shouldSendEmailWithHtmlBody() {
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        emailAttachment.body = Blob.valueOf('Test');
        emailAttachment.filename = 'Test.txt';

        Test.startTest();
        Messaging.SendEmailResult[] results = SOM_EmailUtil.sendEmail(new List<String>{ 'john@doe.com' }, 'Test', 'Text', 
            new Messaging.EmailFileAttachment[] { emailAttachment }, true);
        Test.stopTest();

        System.assert(results[0].isSuccess(), 'Send email action failed');
    }

    /**
    * @description Test method of EmailUtil.sendEmail plain text body
    */
    @isTest
    static void shouldSendEmailWithPlainTextBody() {
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        emailAttachment.body = Blob.valueOf('Test');
        emailAttachment.filename = 'Test.txt';

        Test.startTest();
        Messaging.SendEmailResult[] results = SOM_EmailUtil.sendEmail(new List<String>{ 'john@doe.com' }, 'Test', 'Text', 
            new Messaging.EmailFileAttachment[] { emailAttachment }, false);
        Test.stopTest();

        System.assert(results[0].isSuccess(), 'Send email action failed');
    }

    /**
    * @description Test method of EmailUtil.sendEmail no attachment
    */
    @isTest
    static void shouldSendEmailWithoutAttachment() {
        Test.startTest();
        Messaging.SendEmailResult[] results = SOM_EmailUtil.sendEmail(new List<String>{ 'john@doe.com' }, 'Test', 'Text', true);
        SOM_LogUtil.createEmailErrors(results);
        Test.stopTest();

        System.assert(results[0].isSuccess(), 'Send email action failed');
    }

    /**
    * @description Test method of EmailUtil.sendEmail fail scenario
    */
    @isTest
    static void shouldNotSendEmail() {
        Test.startTest();
        Messaging.SendEmailResult[] results = SOM_EmailUtil.sendEmail(null, 'Test', 'Text', null, true);
        SOM_LogUtil.createEmailErrors(results);
        Test.stopTest();

        System.assert(!results[0].isSuccess(), 'Send email action should failed');
    }
}