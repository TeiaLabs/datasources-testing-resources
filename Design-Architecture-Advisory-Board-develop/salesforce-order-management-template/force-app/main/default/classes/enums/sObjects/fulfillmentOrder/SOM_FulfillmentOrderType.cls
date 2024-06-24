/**
* @description FulfillmentOrderType class
*/
public class SOM_FulfillmentOrderType extends SOM_BaseEnum {
    private static final Map<String, SOM_FulfillmentOrderType> TYPES = new Map<String, SOM_FulfillmentOrderType>();
    
    public static final SOM_FulfillmentOrderType WAREHOUSE = new SOM_FulfillmentOrderType(SOM_Constants.WAREHOUSE, SOM_Constants.WAREHOUSE);
    public static final SOM_FulfillmentOrderType RETAIL_STORE = new SOM_FulfillmentOrderType(SOM_Constants.RETAIL_STORE, SOM_Constants.RETAIL_STORE);
    public static final SOM_FulfillmentOrderType IN_STORE_PICKUP = new SOM_FulfillmentOrderType(SOM_Constants.IN_STORE_PICKUP, SOM_Constants.IN_STORE_PICKUP);
         
    private SOM_FulfillmentOrderType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return FulfillmentOrderType list
    */
    public static SOM_FulfillmentOrderType[] values() {
        return TYPES.values();
    }
}