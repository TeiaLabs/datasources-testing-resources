/**
* @description FulfillmentOrderStatus class
*/
public class SOM_FulfillmentOrderStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_FulfillmentOrderStatus> STATUSES = new Map<String, SOM_FulfillmentOrderStatus>();
    
    public static final SOM_FulfillmentOrderStatus DRAFT = new SOM_FulfillmentOrderStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_FulfillmentOrderStatus ALLOCATED = new SOM_FulfillmentOrderStatus(SOM_Constants.ALLOCATED, SOM_Constants.ALLOCATED);
    public static final SOM_FulfillmentOrderStatus ASSIGNED = new SOM_FulfillmentOrderStatus(SOM_Constants.ASSIGNED, SOM_Constants.ASSIGNED);
    public static final SOM_FulfillmentOrderStatus PICKPACK = new SOM_FulfillmentOrderStatus(SOM_Constants.PICKPACK, SOM_Constants.PICKPACK);
    public static final SOM_FulfillmentOrderStatus FULFILLED = new SOM_FulfillmentOrderStatus(SOM_Constants.FULFILLED, SOM_Constants.FULFILLED);
    public static final SOM_FulfillmentOrderStatus CANCELLED = new SOM_FulfillmentOrderStatus(SOM_Constants.CANCELLED, SOM_Constants.CANCELLED);
         
    private SOM_FulfillmentOrderStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return FulfillmentOrderStatus list
    */
    public static SOM_FulfillmentOrderStatus[] values() {
        return STATUSES.values();
    }
}