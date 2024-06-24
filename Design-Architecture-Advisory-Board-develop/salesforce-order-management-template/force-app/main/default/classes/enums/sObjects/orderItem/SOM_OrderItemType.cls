/**
* @description OrderItemType class
*/
public class SOM_OrderItemType extends SOM_BaseEnum {
    private static final Map<String, SOM_OrderItemType> TYPES = new Map<String, SOM_OrderItemType>();
    
    public static final SOM_OrderItemType ORDER_PRODUCT = new SOM_OrderItemType(SOM_Constants.ORDER_PRODUCT, SOM_Constants.ORDER_PRODUCT);
    public static final SOM_OrderItemType DELIVERY_CHARGE = new SOM_OrderItemType(SOM_Constants.DELIVERY_CHARGE, SOM_Constants.DELIVERY_CHARGE);
         
    private SOM_OrderItemType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return OrderItemType list
    */
    public static SOM_OrderItemType[] values() {
        return TYPES.values();
    }
}