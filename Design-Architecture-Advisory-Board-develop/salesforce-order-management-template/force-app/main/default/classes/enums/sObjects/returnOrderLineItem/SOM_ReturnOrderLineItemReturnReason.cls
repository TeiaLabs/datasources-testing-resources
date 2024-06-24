/**
* @description ReturnOrderLineItemReturnReason class
*/
public class SOM_ReturnOrderLineItemReturnReason extends SOM_BaseEnum {
    private static final Map<String, SOM_ReturnOrderLineItemReturnReason> STATUSES = new Map<String, SOM_ReturnOrderLineItemReturnReason>();
    
    public static final SOM_ReturnOrderLineItemReturnReason DAMAGED = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.DAMAGED, SOM_Constants.DAMAGED);
    public static final SOM_ReturnOrderLineItemReturnReason DEFECTIVE = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.DEFECTIVE, SOM_Constants.DEFECTIVE);
    public static final SOM_ReturnOrderLineItemReturnReason DUPLICATE_ORDER = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.DUPLICATE_ORDER, SOM_Constants.DUPLICATE_ORDER);
    public static final SOM_ReturnOrderLineItemReturnReason WRONG_ITEM = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.WRONG_ITEM, SOM_Constants.WRONG_ITEM);
    public static final SOM_ReturnOrderLineItemReturnReason WRONG_QUANTITY = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.WRONG_QUANTITY, SOM_Constants.WRONG_QUANTITY);
    public static final SOM_ReturnOrderLineItemReturnReason NOT_SATISFIED = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.NOT_SATISFIED, SOM_Constants.NOT_SATISFIED);
    public static final SOM_ReturnOrderLineItemReturnReason OUTDATED = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.OUTDATED, SOM_Constants.OUTDATED);
    public static final SOM_ReturnOrderLineItemReturnReason OTHER = new SOM_ReturnOrderLineItemReturnReason(SOM_Constants.OTHER, SOM_Constants.OTHER);
         
    private SOM_ReturnOrderLineItemReturnReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ReturnOrderLineItemReturnReason list
    */
    public static SOM_ReturnOrderLineItemReturnReason[] values() {
        return STATUSES.values();
    }
}