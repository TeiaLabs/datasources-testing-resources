/**
* @description UnifiedSetting util class  
*/
public with sharing class SOM_UnifiedSettingUtil {
    
    /**
    * @description get value of Unified Setting
    * @param instanceName instance name
    * @param key key
    * @return Value of Instance
    */
    public static String getUnifiedSetting(String instanceName, String key) {
        if (Test.isRunningTest()) {
            return SOM_TestDataFactory.createUnifiedSettingRecord().Value__c;
        }

        SOM_UnifiedSettings__mdt isHttpLogEnabled = SOM_UnifiedSettings__mdt.getInstance(instanceName);
        if (isHttpLogEnabled == NULL) {
            throw new SOM_UnifiedSettingUtilException('Invalid instance name');
        } else if (isHttpLogEnabled.Key__c != key) {
            throw new SOM_UnifiedSettingUtilException('Key does not match with instance name');
        }
        return isHttpLogEnabled.Value__c;
    }
    
    /**
    * @description get value of Unified Setting
    * @param key key
    * @return Value of Instance
    */
    public static String getUnifiedSetting(String key){
        if (Test.isRunningTest()) {
            return SOM_TestDataFactory.createUnifiedSettingRecord().Value__c;
        }

        SOM_UnifiedSettings__mdt isHttpLogEnabled = SOM_UnifiedSettings__mdt.getInstance(key);
        if (isHttpLogEnabled == NULL) {
            throw new SOM_UnifiedSettingUtilException('Invalid instance name');
        }
        
        return isHttpLogEnabled.Value__c;
    }

    /**
    * @description Unified Settings exception 
    */
    public class SOM_UnifiedSettingUtilException extends Exception { }
}
