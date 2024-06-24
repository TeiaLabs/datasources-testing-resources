/**
* @description CardPaymentMethodStatus class
*/
public class SOM_CardPaymentMethodStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_CardPaymentMethodStatus> STATUSES = new Map<String, SOM_CardPaymentMethodStatus>();
    
    public static final SOM_CardPaymentMethodStatus ACTIVE = new SOM_CardPaymentMethodStatus(SOM_Constants.ACTIVE, SOM_Constants.ACTIVE);
    public static final SOM_CardPaymentMethodStatus INACTIVE = new SOM_CardPaymentMethodStatus(SOM_Constants.INACTIVE, SOM_Constants.INACTIVE);
    public static final SOM_CardPaymentMethodStatus CANCELED = new SOM_CardPaymentMethodStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
         
    private SOM_CardPaymentMethodStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return CardPaymentMethodStatus list
    */
    public static SOM_CardPaymentMethodStatus[] values() {
        return STATUSES.values();
    }
}