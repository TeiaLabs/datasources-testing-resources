/**
* @description OrderItemSummaryChangeReason class
*/
public class SOM_OrderItemSummaryChangeReason extends SOM_BaseEnum {
    private static final Map<String, SOM_OrderItemSummaryChangeReason> STATUSES = new Map<String, SOM_OrderItemSummaryChangeReason>();
    
    public static final SOM_OrderItemSummaryChangeReason UNKNOWN = new SOM_OrderItemSummaryChangeReason(SOM_Constants.UNKNOWN, SOM_Constants.UNKNOWN);
         
    private SOM_OrderItemSummaryChangeReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderItemSummaryChangeReason list
    */
    public static SOM_OrderItemSummaryChangeReason[] values() {
        return STATUSES.values();
    }
}