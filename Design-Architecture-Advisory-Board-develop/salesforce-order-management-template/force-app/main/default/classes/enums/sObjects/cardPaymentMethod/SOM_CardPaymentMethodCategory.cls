/**
* @description CardPaymentMethodCategory class
*/
public class SOM_CardPaymentMethodCategory extends SOM_BaseEnum {
    private static final Map<String, SOM_CardPaymentMethodCategory> STATUSES = new Map<String, SOM_CardPaymentMethodCategory>();
    
    public static final SOM_CardPaymentMethodCategory CREDIT_CARD = new SOM_CardPaymentMethodCategory(SOM_Constants.CREDIT_CARD, SOM_Constants.CREDITCARD);
    public static final SOM_CardPaymentMethodCategory DEBIT_CARD = new SOM_CardPaymentMethodCategory(SOM_Constants.DEBIT_CARD, SOM_Constants.DEBITCARD);
         
    private SOM_CardPaymentMethodCategory(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return CardPaymentMethodCategory list
    */
    public static SOM_CardPaymentMethodCategory[] values() {
        return STATUSES.values();
    }
}