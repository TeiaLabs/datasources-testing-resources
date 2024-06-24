/**
* @description ReturnOrderStatus class
*/
public class SOM_ReturnOrderStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_ReturnOrderStatus> STATUSES = new Map<String, SOM_ReturnOrderStatus>();
    
    public static final SOM_ReturnOrderStatus DRAFT = new SOM_ReturnOrderStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_ReturnOrderStatus SUBMITTED = new SOM_ReturnOrderStatus(SOM_Constants.SUBMITTED, SOM_Constants.SUBMITTED);
    public static final SOM_ReturnOrderStatus APPROVED = new SOM_ReturnOrderStatus(SOM_Constants.APPROVED, SOM_Constants.APPROVED);
    public static final SOM_ReturnOrderStatus CANCELLED = new SOM_ReturnOrderStatus(SOM_Constants.CANCELLED, SOM_Constants.CANCELLED);
    public static final SOM_ReturnOrderStatus CLOSED = new SOM_ReturnOrderStatus(SOM_Constants.CLOSED, SOM_Constants.CLOSED);
         
    private SOM_ReturnOrderStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ReturnOrderStatus list
    */
    public static SOM_ReturnOrderStatus[] values() {
        return STATUSES.values();
    }
}