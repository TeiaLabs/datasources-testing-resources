/** 
 * @description  : SOM_EmailNotificationHandler Test class
*/
@isTest
private class SOM_EmailNotificationHandlerTest {
    /**
    * @description Tests sendNotificationEmailToUsers method of SOM_EmailNotificationHandler class
    */
    @isTest
    static void shouldSendNotificationEmailToUsers() {
        String userId = UserInfo.getUserId();
        List<String> recipientList = new List<String>();            
        recipientList.add(userId);

        SOM_TestDataInput.SalesChannelInput salesChannelInput = new SOM_TestDataInput.SalesChannelInput();
        salesChannelInput.name = 'TestSalesChannel';
        SalesChannel salesChannel = SOM_TestDataFactory.createSalesChannel(salesChannelInput);
        insert salesChannel;

        SOM_PEConfiguration__c notificationConfiguration = new SOM_PEConfiguration__c(SalesChannelId__c = salesChannel.Id, Name = 'TestConfiguration', EmailSubject__c = 'EmailSubject', EmailBody__c = 'EmailBody', ConfigurationType__c = 'Email', Recipients__c = String.join(recipientList, ', '));
        insert notificationConfiguration;

        SOM_EmailNotificationHandler.EmailConfigurationWrapper wrapper = new SOM_EmailNotificationHandler.EmailConfigurationWrapper();
        wrapper.idsOfRecipientUsers = recipientList;
        wrapper.notificationConfiguration = notificationConfiguration;
        
        Test.startTest();
        SOM_EmailNotificationHandler.sendNotificationEmailToUsers(new List<SOM_EmailNotificationHandler.EmailConfigurationWrapper>{wrapper});
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        // Assert emails have been sent
        System.assertEquals(1, invocations,  'An email should be sent');
    }
}