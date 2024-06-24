/**
* @description LocationType class
*/
public class SOM_LocationType extends SOM_BaseEnum {
    private static final Map<String, SOM_LocationType> TYPES = new Map<String, SOM_LocationType>();
    
    public static final SOM_LocationType WAREHOUSE = new SOM_LocationType(SOM_Constants.WAREHOUSE, SOM_Constants.WAREHOUSE);
    public static final SOM_LocationType STORE = new SOM_LocationType(SOM_Constants.STORE, SOM_Constants.STORE);
    public static final SOM_LocationType VIRTUAL_C = new SOM_LocationType(SOM_Constants.VIRTUAL_C, SOM_Constants.VIRTUAL_C);
         
    private SOM_LocationType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return LocationType list
    */
    public static SOM_LocationType[] values() {
        return TYPES.values();
    }
}