/**
* @description UnifiedSetting test class
*/

@isTest
private with sharing class SOM_UnifiedSettingUtilTest {

    /**
    * @description Test method of SOM_UnifiedSettingUtil getUnifiedSetting 
    */
    @isTest
    static void shouldGetValueByKeyAndInstanceName() {
        String value = SOM_UnifiedSettingUtil.getUnifiedSetting('HttpLogEnabled', 'HttpLogEnabled');
        System.assert(!String.isBlank(value), 'Settings could not be received');
    }

    /**
    * @description Test method of SOM_UnifiedSettingUtil overloaded getUnifiedSetting 
    */
    @isTest
    static void shouldGetValueByKey() {
        String value = SOM_UnifiedSettingUtil.getUnifiedSetting('HttpLogEnabled');
        System.assert(!String.isBlank(value), 'Settings could not be received');
    }
}
