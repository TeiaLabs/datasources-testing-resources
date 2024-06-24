/** 
 * @description  : Email Notification Handler
*/
public with sharing class SOM_EmailNotificationHandler {
    /**  
    * @description  : Wrapper method which includes list of user ids and one notification configuration
    */
    public class EmailConfigurationWrapper{
        /**
         * @description idsOfRecipientUsers List of recipient ids
        */
        @InvocableVariable
        public List<String> idsOfRecipientUsers;
        /**
         * @description notificationConfiguration Notification configuration
        */
        @InvocableVariable
        public SOM_PEConfiguration__c notificationConfiguration;
    }
    /**  
    *   @description  : Sends email notification to users based on configuration wrapper
    *   @param emailConfigurations wrapper which includes notification configurations and recipient list
    */
    @InvocableMethod(label='Sends email notification to recipients')
    public static void sendNotificationEmailToUsers(List<SOM_EmailNotificationHandler.EmailConfigurationWrapper> emailConfigurations) {
        List<String> configurationRecipientIds = new List<String>();
        for (SOM_EmailNotificationHandler.EmailConfigurationWrapper wrapper : emailConfigurations) {
            if (wrapper.idsOfRecipientUsers != null) {
                configurationRecipientIds.addAll(wrapper.idsOfRecipientUsers);
            }
        }
        List<User> recipientList = [SELECT Id, Email FROM User WHERE Id IN: configurationRecipientIds WITH SECURITY_ENFORCED];
        for (SOM_EmailNotificationHandler.EmailConfigurationWrapper wrapper : emailConfigurations) {
            List<String> emailAddresses = new List<String>();
            for (User recipient : recipientList) {
                if (wrapper.idsOfRecipientUsers.contains(recipient.Id)) {
                    emailAddresses.add(recipient.Email);
                }
            }
            SOM_EmailUtil.sendEmail(emailAddresses, wrapper.notificationConfiguration.EmailSubject__c, wrapper.notificationConfiguration.EmailBody__c.unescapeHtml4(), true);
        }
    }
}