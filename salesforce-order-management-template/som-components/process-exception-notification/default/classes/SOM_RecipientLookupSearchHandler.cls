/** 
 * @description  : Apex controller class of somRecipientLookupSearchInput lwc component
*/
public with sharing class SOM_RecipientLookupSearchHandler {
    /**
    * @description wrapper class which is used parse types of items from different objects
    */
    public class ItemTypeWrapper{
        /**
         * @description label Label of item
        */
        public String label;
        /**
         * @description value Api name of object
        */   
        public String value;
        /**
         * @description labelApiName Api name of label field
        */   
        public String labelApiName;
        /**
         * @description icon Icon displayed for item
        */    
        public String icon;
        /**
         * @description whereClause Where clause used to filter records
        */    
        public String whereClause; 
    }
    
    /**
    * @description wrapper class which is used parse types of items from different objects
    */
    public class ItemWrapper{
        /**
         * @description itemList List of items
        */
        public List<sobject> itemList;
        /**
         * @description itemApiName Api name of item object 
        */
        public String itemApiName;
    }

    /**
    * @description Gets the id and a field of an object
    * @param objectName api name of object
    * @param labelApiName api name of requested field
    * @param whereClause WHERE clause to filter records | whereClause does not support queries with string fields since "'" being escaped internally
    * @return list of sobjects
    */
    @AuraEnabled(cacheable=true)
    public static List<Sobject> getIdAndNameOfItems(String objectName, String labelApiName, String whereClause){
        String whereCondition = '';
        try {
            if(whereClause != null){
                whereCondition = whereClause.length() > 0 ? 'AND ' + whereClause : '';
            }
            String query = 'SELECT Id,' + String.escapeSingleQuotes(labelApiName) + ' FROM '+ 
                            String.escapeSingleQuotes(objectName) + ' WHERE ' + String.escapeSingleQuotes(labelApiName) + 
                            ' != \'\' '+ String.escapeSingleQuotes(whereCondition)  +' WITH SECURITY_ENFORCED ORDER BY '+ String.escapeSingleQuotes(labelApiName) + ' ASC';
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description queries selected items in the component by id
    * @param itemIds ids of selected records
    * @param itemTypes stringified list of ItemTypeWrappers which determines the object types that can be selected in the component, icons of these records and field api name to be used for label.
    * @return stringified list of ItemWrappers which consist of list of records and their object api names
    *         suppress reason: TODO REFACTOR REFACTOR
    */
    @suppressWarnings('PMD.OperationWithLimitsInLoop')
    @AuraEnabled(cacheable=true)
    public static String getSelectedObjectLabelsAndIcons(List<String> itemIds, String itemTypes){
        List<ItemWrapper> selectedObjects = new List<ItemWrapper>();    
        try{
            // Get labels and icons of recipient users
            ItemWrapper recipientUsers = new ItemWrapper();
            recipientUsers.itemList = Database.query('SELECT Id, Name FROM User WHERE Id IN : itemIds WITH SECURITY_ENFORCED');
            recipientUsers.itemApiName = 'User';
            selectedObjects.add(recipientUsers);
            // Get labels and icons of recipient roles
            ItemWrapper recipientRoles = new ItemWrapper();
            recipientRoles.itemList = Database.query('SELECT Id, Name FROM UserRole WHERE Id IN : itemIds WITH SECURITY_ENFORCED');
            recipientRoles.itemApiName = 'UserRole';
            selectedObjects.add(recipientRoles);
            // Get labels and icons of recipient groups
            ItemWrapper recipientGroups = new ItemWrapper();
            recipientGroups.itemList = Database.query('SELECT Id, Name FROM Group WHERE Id IN : itemIds WITH SECURITY_ENFORCED');
            recipientGroups.itemApiName = 'Group';
            selectedObjects.add(recipientGroups);
            return JSON.serialize(selectedObjects);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}