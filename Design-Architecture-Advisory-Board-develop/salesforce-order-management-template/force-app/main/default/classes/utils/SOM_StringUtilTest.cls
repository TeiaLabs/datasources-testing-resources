/**
* @description StringUtil test class
*/
@isTest
private class SOM_StringUtilTest {
    @isTest
    static void shouldGenerateUUID() {
        List<String> generatedIds = new List<String>();
        Integer generateSize = 100;

        for (Integer i = 0; i < generateSize; i++) {
            String generatedId = SOM_StringUtil.generateUUID();
            System.assert(generatedIds.contains(generatedId) == false, 'The ID is not unique');
            generatedIds.add(generatedId);
        }
    }
}