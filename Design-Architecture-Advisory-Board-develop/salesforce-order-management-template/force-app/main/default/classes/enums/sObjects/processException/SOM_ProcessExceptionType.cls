/**
* @description ProcessExceptionType class
*/
public class SOM_ProcessExceptionType extends SOM_BaseEnum {
    private static final Map<String, SOM_ProcessExceptionType> TYPES = new Map<String, SOM_ProcessExceptionType>();
    
    public static final SOM_ProcessExceptionType ORDER_ACTIVATION = new SOM_ProcessExceptionType(SOM_Constants.ORDER_ACTIVATION, SOM_Constants.ORDER_ACTIVATION);
    public static final SOM_ProcessExceptionType ORDER_APPROVAL = new SOM_ProcessExceptionType(SOM_Constants.ORDER_APPROVAL, SOM_Constants.ORDER_APPROVAL);
    public static final SOM_ProcessExceptionType FULFILLMENT = new SOM_ProcessExceptionType(SOM_Constants.FULFILLMENT, SOM_Constants.FULFILLMENT);
    public static final SOM_ProcessExceptionType PAYMENT = new SOM_ProcessExceptionType(SOM_Constants.PAYMENT, SOM_Constants.PAYMENT);
    public static final SOM_ProcessExceptionType INVOICING = new SOM_ProcessExceptionType(SOM_Constants.INVOICING, SOM_Constants.INVOICING);
         
    private SOM_ProcessExceptionType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return ProcessExceptionType list
    */
    public static SOM_ProcessExceptionType[] values() {
        return TYPES.values();
    }
}