/**
* @description AlternativePaymentMethodStatus class
*/
public class SOM_AlternativePaymentMethodStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_AlternativePaymentMethodStatus> STATUSES = new Map<String, SOM_AlternativePaymentMethodStatus>();
    
    public static final SOM_AlternativePaymentMethodStatus ACTIVE = new SOM_AlternativePaymentMethodStatus(SOM_Constants.ACTIVE, SOM_Constants.ACTIVE);
    public static final SOM_AlternativePaymentMethodStatus INACTIVE = new SOM_AlternativePaymentMethodStatus(SOM_Constants.INACTIVE, SOM_Constants.INACTIVE);
    public static final SOM_AlternativePaymentMethodStatus CANCELED = new SOM_AlternativePaymentMethodStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
         
    private SOM_AlternativePaymentMethodStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return AlternativePaymentMethodStatus list
    */
    public static SOM_AlternativePaymentMethodStatus[] values() {
        return STATUSES.values();
    }
}
