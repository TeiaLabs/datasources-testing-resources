/** 
 * @description  : Chatter Notification Handler class
*/
public with sharing class SOM_ChatterNotificationHandler {
    /**  
    * @description  : Wrapper method which includes list of user ids and one notification configuration
    */
    public class ChatterConfigurationWrapper{
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
    *   @description  : Adds mentioned users to chatter message
    *   @param chatterConfigurations wrapper which includes notification configurations and recipient list
    *   @return chatterMessage with mentioned users
    */
    @InvocableMethod(label='Get Chatter message with mentioned users')
    public static List<String> getChatterMessageWithMentions(List<SOM_ChatterNotificationHandler.ChatterConfigurationWrapper> chatterConfigurations) {
        List<String> chatterMessagesList = new List<String>();
        for (SOM_ChatterNotificationHandler.ChatterConfigurationWrapper wrapper : chatterConfigurations) {
            if (wrapper.idsOfRecipientUsers != null) {
                Integer numberOfRecipientsInConfigurations = wrapper.idsOfRecipientUsers.size();
                Integer numberOfMentions = numberOfRecipientsInConfigurations < 25 ? numberOfRecipientsInConfigurations : 25;
                String chatterMessage = wrapper.notificationConfiguration.ChatterMessage__c + ' ';
                for (Integer i = 0; i < numberOfMentions; i++) {
                    chatterMessage += '@[' + wrapper.idsOfRecipientUsers[i] + ']';
                }
                chatterMessagesList.add(chatterMessage);
            }
        }
        
        return chatterMessagesList;
    }
}