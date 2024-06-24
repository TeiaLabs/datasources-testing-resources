/**
* @description ShipmentStatus class
*/
public class SOM_ShipmentStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_ShipmentStatus> STATUSES = new Map<String, SOM_ShipmentStatus>();
    
    public static final SOM_ShipmentStatus SHIPPED = new SOM_ShipmentStatus(SOM_Constants.SHIPPED, SOM_Constants.SHIPPED);
    public static final SOM_ShipmentStatus DELIVERED = new SOM_ShipmentStatus(SOM_Constants.DELIVERED, SOM_Constants.DELIVERED);
         
    private SOM_ShipmentStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ShipmentStatus list
    */
    public static SOM_ShipmentStatus[] values() {
        return STATUSES.values();
    }
}