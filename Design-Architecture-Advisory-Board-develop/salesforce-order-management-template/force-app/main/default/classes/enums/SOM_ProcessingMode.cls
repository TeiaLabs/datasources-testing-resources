/**
* @description ProcessingMode class
*/
public class SOM_ProcessingMode extends SOM_BaseEnum {
    private static final Map<String, SOM_ProcessingMode> STATUSES = new Map<String, SOM_ProcessingMode>();
    
    public static final SOM_ProcessingMode EXTERNAL = new SOM_ProcessingMode(SOM_Constants.EXTERNAL, SOM_Constants.EXTERNAL);
    public static final SOM_ProcessingMode SALESFORCE = new SOM_ProcessingMode(SOM_Constants.SALESFORCE, SOM_Constants.SALESFORCE);
         
    private SOM_ProcessingMode(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ProcessingMode list
    */
    public static SOM_ProcessingMode[] values() {
        return STATUSES.values();
    }
}