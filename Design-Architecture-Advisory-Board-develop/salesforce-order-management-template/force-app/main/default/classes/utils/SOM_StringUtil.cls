/**
* @description String util class 
*/
public with sharing class SOM_StringUtil {
    /**
    * @description Generates unique Id
    * @return Id as String
    */
    public static String generateUUID() {
        Blob blobValue = Crypto.GenerateAESKey(128);
        String hexValue = EncodingUtil.ConvertToHex(blobValue);

        return String.format('{0}-{1}-{2}-{3}-{4}', 
            new List<String>
            { 
                hexValue.SubString(0, 8),
                hexValue.SubString(8, 12),
                hexValue.SubString(12, 16),
                hexValue.SubString(16, 20),
                hexValue.substring(20)
            });
    }
}