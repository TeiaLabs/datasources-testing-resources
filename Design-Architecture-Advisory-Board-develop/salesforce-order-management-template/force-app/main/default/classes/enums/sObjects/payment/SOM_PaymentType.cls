/**
* @description PaymentType class
*/
public class SOM_PaymentType extends SOM_BaseEnum {
    private static final Map<String, SOM_PaymentType> STATUSES = new Map<String, SOM_PaymentType>();
    
    public static final SOM_PaymentType CAPTURE = new SOM_PaymentType(SOM_Constants.CAPTURE, SOM_Constants.CAPTURE);
    public static final SOM_PaymentType SALE = new SOM_PaymentType(SOM_Constants.SALE, SOM_Constants.SALE);
         
    private SOM_PaymentType(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentType list
    */
    public static SOM_PaymentType[] values() {
        return STATUSES.values();
    }
}