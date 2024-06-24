/**
* @description ProcessExceptionStatus class
*/
public class SOM_ProcessExceptionStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_ProcessExceptionStatus> STATUSES = new Map<String, SOM_ProcessExceptionStatus>();
    
    public static final SOM_ProcessExceptionStatus IGNORED = new SOM_ProcessExceptionStatus(SOM_Constants.IGNORED, SOM_Constants.IGNORED);
    public static final SOM_ProcessExceptionStatus MANUAL_INTERVENTION_ALERTED = new SOM_ProcessExceptionStatus(SOM_Constants.MANUAL_INTERVENTION_ALERTED, SOM_Constants.MANUAL_INTERVENTION_ALERTED);
    public static final SOM_ProcessExceptionStatus MANUAL_INTERVENTION_REQUIRED = new SOM_ProcessExceptionStatus(SOM_Constants.MANUAL_INTERVENTION_REQUIRED, SOM_Constants.MANUAL_INTERVENTION_REQUIRED);
    public static final SOM_ProcessExceptionStatus NEW_C = new SOM_ProcessExceptionStatus(SOM_Constants.NEW_C, SOM_Constants.NEW_C);
    public static final SOM_ProcessExceptionStatus PAUSED = new SOM_ProcessExceptionStatus(SOM_Constants.PAUSED, SOM_Constants.PAUSED);
    public static final SOM_ProcessExceptionStatus RESOLVED = new SOM_ProcessExceptionStatus(SOM_Constants.RESOLVED, SOM_Constants.RESOLVED);
    public static final SOM_ProcessExceptionStatus TRIAGED = new SOM_ProcessExceptionStatus(SOM_Constants.TRIAGED, SOM_Constants.TRIAGED);
    public static final SOM_ProcessExceptionStatus VOIDED = new SOM_ProcessExceptionStatus(SOM_Constants.VOIDED, SOM_Constants.VOIDED);
    
         
    private SOM_ProcessExceptionStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ProcessExceptionStatus list
    */
    public static SOM_ProcessExceptionStatus[] values() {
        return STATUSES.values();
    }
}