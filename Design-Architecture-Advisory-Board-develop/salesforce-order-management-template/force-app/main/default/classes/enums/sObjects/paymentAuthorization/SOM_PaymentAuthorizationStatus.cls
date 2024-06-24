/**
* @description PaymentAuthorizationStatus class
*/
public class SOM_PaymentAuthorizationStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_PaymentAuthorizationStatus> STATUSES = new Map<String, SOM_PaymentAuthorizationStatus>();
    
    public static final SOM_PaymentAuthorizationStatus DRAFT = new SOM_PaymentAuthorizationStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_PaymentAuthorizationStatus PROCESSED = new SOM_PaymentAuthorizationStatus(SOM_Constants.PROCESSED, SOM_Constants.PROCESSED);
    public static final SOM_PaymentAuthorizationStatus CANCELED = new SOM_PaymentAuthorizationStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
    public static final SOM_PaymentAuthorizationStatus PENDING = new SOM_PaymentAuthorizationStatus(SOM_Constants.PENDING, SOM_Constants.PENDING);
    public static final SOM_PaymentAuthorizationStatus FAILED = new SOM_PaymentAuthorizationStatus(SOM_Constants.FAILED, SOM_Constants.FAILED);
         
    private SOM_PaymentAuthorizationStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentAuthorizationStatus list
    */
    public static SOM_PaymentAuthorizationStatus[] values() {
        return STATUSES.values();
    }
}