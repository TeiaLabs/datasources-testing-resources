/**
* @description CardPaymentMethodType class
*/
public class SOM_CardPaymentMethodType extends SOM_BaseEnum {
    private static final Map<String, SOM_CardPaymentMethodType> TYPES = new Map<String, SOM_CardPaymentMethodType>();
    
    public static final SOM_CardPaymentMethodType VISA = new SOM_CardPaymentMethodType(SOM_Constants.VISA, SOM_Constants.VISA);
    public static final SOM_CardPaymentMethodType MASTER_CARD = new SOM_CardPaymentMethodType(SOM_Constants.MASTER_CARD, SOM_Constants.MASTER_CARD);
    public static final SOM_CardPaymentMethodType AMERICAN_EXPRESS = new SOM_CardPaymentMethodType(SOM_Constants.AMERICAN_EXPRESS, SOM_Constants.AMERICAN_EXPRESS);
    public static final SOM_CardPaymentMethodType DINERS_CLUB = new SOM_CardPaymentMethodType(SOM_Constants.DINERS_CLUB, SOM_Constants.DINERS_CLUB);
    public static final SOM_CardPaymentMethodType JCB = new SOM_CardPaymentMethodType(SOM_Constants.JCB, SOM_Constants.JCB);
    public static final SOM_CardPaymentMethodType MAESTRO = new SOM_CardPaymentMethodType(SOM_Constants.MAESTRO, SOM_Constants.MAESTRO);
         
    private SOM_CardPaymentMethodType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return CardPaymentMethodType list
    */
    public static SOM_CardPaymentMethodType[] values() {
        return TYPES.values();
    }
}