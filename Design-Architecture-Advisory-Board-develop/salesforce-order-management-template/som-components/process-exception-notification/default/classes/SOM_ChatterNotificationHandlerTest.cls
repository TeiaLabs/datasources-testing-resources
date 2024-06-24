/** 
 * @description  : SOM_ChatterNotificationHandler Test Class
*/
@isTest
private with sharing class SOM_ChatterNotificationHandlerTest {
    /**
    * @description Tests getChatterMessageWithMentions method of SOM_ChatterNotificationHandler class
    */
    @isTest
    static void shouldGetChatterMessageWithMentions() {
        String userId = UserInfo.getUserId();
        List<String> recipientList = new List<String>();
        for (Integer i = 0; i < 30; i++) {
            recipientList.add(userId);
        }
        SOM_TestDataInput.SalesChannelInput salesChannelInput = new SOM_TestDataInput.SalesChannelInput();
        salesChannelInput.name = 'TestSalesChannel';
        SalesChannel salesChannel = SOM_TestDataFactory.createSalesChannel(salesChannelInput);
        insert salesChannel;

        SOM_PEConfiguration__c notificationConfiguration = new SOM_PEConfiguration__c(SalesChannelId__c = salesChannel.Id, Name = 'TestConfiguration', ChatterMessage__c = 'Test:', ConfigurationType__c = 'Chatter', Recipients__c = String.join(recipientList, ', '));
        insert notificationConfiguration;

        SOM_ChatterNotificationHandler.ChatterConfigurationWrapper wrapper = new SOM_ChatterNotificationHandler.ChatterConfigurationWrapper();
        wrapper.idsOfRecipientUsers = recipientList;
        wrapper.notificationConfiguration = notificationConfiguration;
        Test.startTest();
        String chatterMessage = SOM_ChatterNotificationHandler.getChatterMessageWithMentions(new List<SOM_ChatterNotificationHandler.ChatterConfigurationWrapper>{wrapper})[0];
        Test.stopTest();

        String expectedMessage = 'Test: ';
        for (Integer i = 0; i < 25; i++) {
            expectedMessage += '@['+ userId +']';
        }
        system.assertEquals(expectedMessage, chatterMessage, 'Unexpected chatter message');
    }
}