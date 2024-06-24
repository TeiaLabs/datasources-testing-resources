/**
* @description LifeCycleType class
*/
public class SOM_LifeCycleType extends SOM_BaseEnum {
    private static final Map<String, SOM_LifeCycleType> STATUSES = new Map<String, SOM_LifeCycleType>();
    
    public static final SOM_LifeCycleType MANAGED = new SOM_LifeCycleType(SOM_Constants.MANAGED, SOM_Constants.MANAGED);
    public static final SOM_LifeCycleType UNMANAGED = new SOM_LifeCycleType(SOM_Constants.UNMANAGED, SOM_Constants.UNMANAGED);
         
    private SOM_LifeCycleType(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return LifeCycleType list
    */
    public static SOM_LifeCycleType[] values() {
        return STATUSES.values();
    }
}
