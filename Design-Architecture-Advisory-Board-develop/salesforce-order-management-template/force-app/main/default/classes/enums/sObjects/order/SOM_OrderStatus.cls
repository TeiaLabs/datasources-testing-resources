/**
* @description OrderStatus class
*/
public class SOM_OrderStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_OrderStatus> TYPES = new Map<String, SOM_OrderStatus>();
    
    public static final SOM_OrderStatus DRAFT = new SOM_OrderStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_OrderStatus ACTIVATED = new SOM_OrderStatus(SOM_Constants.ACTIVATED, SOM_Constants.ACTIVATED);
         
    private SOM_OrderStatus(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return OrderStatus list
    */
    public static SOM_OrderStatus[] values() {
        return TYPES.values();
    }
}