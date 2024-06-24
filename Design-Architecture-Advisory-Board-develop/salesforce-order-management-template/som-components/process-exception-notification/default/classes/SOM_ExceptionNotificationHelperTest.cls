/** 
 * @description  : SOM_ExceptionNotificationHelper Test class
*/
@isTest
private class SOM_ExceptionNotificationHelperTest {
    /**
    * @description Tests getSalesChannelList method of SOM_ExceptionNotificationHelper class
    */
    @isTest
    static void shouldGetSalesChannelList() {
        SalesChannel testSalesChannel = new SalesChannel(SalesChannelName='testChannel');
        insert testSalesChannel;
        Test.startTest();
        List<SalesChannel> selectedSalesChannels = SOM_ExceptionNotificationHelper.getSalesChannelList();
        Test.stopTest();
        
        System.assert(!selectedSalesChannels.isEmpty(), 'No Sales Channel record(s) found');
    }

    /**
    * @description Tests selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel method of SOM_ExceptionNotificationHelper class
    */
    @isTest
    static void shouldSelectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel() {
        SalesChannel testSalesChannel = new SalesChannel(SalesChannelName='testChannel');
        String salesChannelId = Database.insert(new List<SalesChannel>{testSalesChannel})[0].Id;

        SOM_PEConfiguration__c testConfiguration = new SOM_PEConfiguration__c(
            Name = 'testConfiguration',
            ChatterMessage__c = 'testMessage',
            IsPostToRelatedRecordFeedEnabled__c = true,
            ConfigurationType__c = 'Chatter',
            Recipients__c = String.valueOf(salesChannelId),
            SalesChannelId__c = salesChannelId);
        insert testConfiguration;
        
        Test.startTest();
        List<SOM_PEConfiguration__c> processExceptionConfigurations = SOM_ExceptionNotificationHelper.selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel('Chatter', salesChannelId);
        Test.stopTest();
        
        System.assert(!processExceptionConfigurations.isEmpty(), 'No Process Exception Configuration record(s) found');
    }

    /**
    * @description Tests getCustomNotificationTypeList method of SOM_ExceptionNotificationHelper class
    */
    @isTest
    static void shouldGetCustomNotificationTypeList() {
        Test.startTest();
        List<CustomNotificationType> customNotificationTypes = SOM_ExceptionNotificationHelper.getCustomNotificationTypeList();
        Test.stopTest();

        System.assert(!customNotificationTypes.isEmpty(), 'No Custom Notification Type record(s) found');
    }

    /**
    * @description Tests getIdsOfUsersInRecipientList method of SOM_ExceptionNotificationHelper class
    */
    @isTest
    static void shouldGetIdsOfUsersInRecipientList() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Saleschannel salesChannel = new SalesChannel(SalesChannelName = 'TestSalesChannel');
        insert salesChannel;
        // Insert recipient users
        System.runAs (thisUser) {
            UserRole userRole = new UserRole(Name = 'Finance Approver');
            insert userRole;
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            List<User> newUsersList = new List<User>();
            newUsersList.add(
                new User(alias = 'jsmith', email='jsmith@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, userroleid = userRole.Id,
                timezonesidkey='America/Los_Angeles', 
                username='testUserName1@acme.com')
            );
            newUsersList.add(
                new User(alias = 'jsmith', email='jsmith@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, userroleid = userRole.Id,
                timezonesidkey='America/Los_Angeles', 
                username='testUserName2@acme.com')
            );
            newUsersList.add(
                new User(alias = 'jsmith', email='jsmith@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, userroleid = userRole.Id,
                timezonesidkey='America/Los_Angeles', 
                username='testUserName3@acme.com')
            );
            List<Database.SaveResult> insertionResults = Database.insert(newUsersList);
            Account account = new Account(name='Acme');
            insert account;
            // Create new group and add user to public group
            Group testGroup = new Group();
            testGroup.Name = 'Test Group';
            insert testGroup;
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId = testGroup.Id;
            groupMember.UserOrGroupId = insertionResults[2].Id;
            insert groupMember;
            SOM_PEConfiguration__c notificationConfiguration = new SOM_PEConfiguration__c(SalesChannelId__c = salesChannel.Id, Name = 'TestConfiguration', EmailSubject__c = 'EmailSubject', EmailBody__c = 'EmailBody', ConfigurationType__c = 'Email', Recipients__c = userRole.Id + ',' + insertionResults[2].Id + ',' + testGroup.Id);
            insert notificationConfiguration;
            Test.startTest();
            List<String> userIds = SOM_ExceptionNotificationHelper.getIdsOfUsersInRecipientList(new List<SOM_PEConfiguration__c>{notificationConfiguration})[0];
            Test.stopTest();
            System.assert(userIds.contains(insertionResults[0].Id) && userIds.contains(insertionResults[1].Id) && userIds.contains(insertionResults[2].Id), 'No User Id found');
        }
    }

}