/**
* @description PaymentStatus class
*/
public class SOM_PaymentStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_PaymentStatus> STATUSES = new Map<String, SOM_PaymentStatus>();
    
    public static final SOM_PaymentStatus DRAFT = new SOM_PaymentStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_PaymentStatus PROCESSED = new SOM_PaymentStatus(SOM_Constants.PROCESSED, SOM_Constants.PROCESSED);
    public static final SOM_PaymentStatus CANCELED = new SOM_PaymentStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
    public static final SOM_PaymentStatus PENDING = new SOM_PaymentStatus(SOM_Constants.PENDING, SOM_Constants.PENDING);
    public static final SOM_PaymentStatus FAILED = new SOM_PaymentStatus(SOM_Constants.FAILED, SOM_Constants.FAILED);
         
    private SOM_PaymentStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentStatus list
    */
    public static SOM_PaymentStatus[] values() {
        return STATUSES.values();
    }
}