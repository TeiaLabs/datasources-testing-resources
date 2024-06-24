/** 
 * @description  : Helper class of chatter, email and custom notification lighning web components
*/
public with sharing class SOM_ExceptionNotificationHelper {

    private static List<List<String>> recipientUsersListOfEachConfiguration = new List<List<String>>();
    private static List<List<String>> recipientGroupsListOfEachConfiguration = new List<List<String>>();
    private static List<List<String>> recipientRolesListOfEachConfiguration = new List<List<String>>();
    /**
    * @description gets Sales Channel Records
    * @return SalesChannelRecords
    */
    @AuraEnabled(cacheable=true)
    public static List<SalesChannel> getSalesChannelList(){
        try {
            return [SELECT Id, SalesChannelName FROM SalesChannel WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
    * @description gets process exception configurations by configuration type and sales channel id
    * @param configuratonType configuration type
    * @param salesChannelId sales channel Id
    * @return List of ProcessExceptionConfigurations
    */
    @AuraEnabled(cacheable=true)
    public static List<SOM_PEConfiguration__c> selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel(String configuratonType, String salesChannelId) {
        try {
            return [SELECT  
                        Name,
                        ChatterMessage__c,
                        IsPostToRelatedRecordFeedEnabled__c,
                        ConfigurationType__c,
                        CustomNotificationMessage__c,
                        CustomNotificationTitle__c,
                        CustomNotificationTypeId__c,
                        EmailBody__c,
                        EmailSubject__c,
                        ProcessExceptionCategories__c,
                        ProcessExceptionSeverities__c,
                        ProcessExceptionStatuses__c,
                        Recipients__c
                    FROM SOM_PEConfiguration__c 
                    WHERE ConfigurationType__c =: configuratonType AND SalesChannelId__c =: salesChannelId
                    WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
    * @description gets Custom Notification Type records
    * @return list of Custom Notification Type Records
    */
    @AuraEnabled(cacheable=true)
    public static List<CustomNotificationType> getCustomNotificationTypeList(){
        if (Test.isRunningTest()) {
            CustomNotificationType testCustomNotificationType = new CustomNotificationType(CustomNotifTypeName = 'Testing Notification Type');
            return new List<CustomNotificationType>{testCustomNotificationType};
        }
        try {
            return [SELECT Id, CustomNotifTypeName FROM CustomNotificationType WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    *   @description gets user Ids from recipientIds field of SOM_PEConfiguration__c object
    *   @param notificationConfigurations wrapper which includes notification configurations and recipient list
    *   @return list of user ids
    */
    @InvocableMethod(label='Get Ids of users in recipient list')
    public static List<List<String>> getIdsOfUsersInRecipientList(List<SOM_PEConfiguration__c> notificationConfigurations) {
        List<String> recipientGroupsOfAllConfigurations = new List<String>();
        List<String> recipientRolesOfAllConfigurations = new List<String>();
        for (SOM_PEConfiguration__c currentConfiguration : notificationConfigurations) {
            List<String> recipientIdList = currentConfiguration.Recipients__c.split(',');
            // Get Ids to be mentioned in chatter post
            List<String> idsOfRecipientUsers = new List<String>();
            List<String> roleRecipientIds = new List<String>();
            List<String> groupRecipientIds = new List<String>();
            for (String recipientId : recipientIdList) {
                if(Id.valueOf(recipientId).getSObjectType() == User.getSObjectType()){
                    idsOfRecipientUsers.add(recipientId);
                }else if(Id.valueOf(recipientId).getSObjectType() == Group.getSObjectType()){
                    groupRecipientIds.add(recipientId);
                }else if(Id.valueOf(recipientId).getSObjectType() == UserRole.getSObjectType()){
                    roleRecipientIds.add(recipientId);
                }
            }
            recipientRolesOfAllConfigurations.addAll(roleRecipientIds);
            recipientGroupsOfAllConfigurations.addAll(groupRecipientIds);

            recipientUsersListOfEachConfiguration.add(idsOfRecipientUsers);
            recipientGroupsListOfEachConfiguration.add(groupRecipientIds);
            recipientRolesListOfEachConfiguration.add(roleRecipientIds);
        }
        List<GroupMember> membersOfRecipientGroups = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: recipientGroupsOfAllConfigurations WITH SECURITY_ENFORCED];
        List<User> usersOfRecipientRoles = [SELECT Id, UserRoleId FROM User WHERE UserRoleId IN: recipientRolesOfAllConfigurations WITH SECURITY_ENFORCED];
        return getUserIdsFromDifferentRecipientTypes(notificationConfigurations, membersOfRecipientGroups, usersOfRecipientRoles);
    }
    
    /**
    *   @description gets user Ids from different recipient types | Helper method
    *   @param notificationConfigurations wrapper which includes notification configurations and recipient list
    *   @param membersOfRecipientGroups list of members of recipient groups
    *   @param usersOfRecipientRoles list of users which have one of recipient roles
    *   @return recipientIds  | List<List<String>>
    */
    public static List<List<String>> getUserIdsFromDifferentRecipientTypes(List<SOM_PEConfiguration__c> notificationConfigurations, List<GroupMember> membersOfRecipientGroups,  List<User> usersOfRecipientRoles) {
        List<List<String>> recipientIds = new List<List<String>>();
        for (Integer configurationIndex = 0; configurationIndex < notificationConfigurations.size(); configurationIndex++) {
            List<String> recipientsOfCurrentConfiguration = new List<String>();
            recipientsOfCurrentConfiguration.addAll(recipientUsersListOfEachConfiguration[configurationIndex]);
            // Check if groupMember's groupId in recipient list of configuration
            for (GroupMember groupMember : membersOfRecipientGroups) {
                if (recipientGroupsListOfEachConfiguration[configurationIndex].contains(groupMember.GroupId) && Id.valueOf(groupMember.UserOrGroupId).getSObjectType() == User.getSObjectType()) {
                        recipientsOfCurrentConfiguration.add(groupMember.UserOrGroupId);
                }
            }
            // Check if user's role in recipient list of configuration
            for (User userWithSpecifiedRole : usersOfRecipientRoles) {
                if (recipientRolesListOfEachConfiguration[configurationIndex].contains(userWithSpecifiedRole.UserRoleId)) {
                    recipientsOfCurrentConfiguration.add(userWithSpecifiedRole.Id);
                }
            }
            recipientIds.add(recipientsOfCurrentConfiguration);
        }
        return recipientIds;
    }
}