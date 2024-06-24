/**
* @description ReturnOrderLineItemRejectionReason class
*/
public class SOM_ReturnOrderLineItemRejectionReason extends SOM_BaseEnum {
    private static final Map<String, SOM_ReturnOrderLineItemRejectionReason> STATUSES = new Map<String, SOM_ReturnOrderLineItemRejectionReason>();
    
    public static final SOM_ReturnOrderLineItemRejectionReason DAMAGED_ITEM = new SOM_ReturnOrderLineItemRejectionReason(SOM_Constants.DAMAGED_ITEM, SOM_Constants.DAMAGED_ITEM);
    public static final SOM_ReturnOrderLineItemRejectionReason MISSING_ITEM_OR_PART = new SOM_ReturnOrderLineItemRejectionReason(SOM_Constants.MISSING_ITEM_OR_PART, SOM_Constants.MISSING_ITEM_OR_PART);
    public static final SOM_ReturnOrderLineItemRejectionReason WRONG_ITEM = new SOM_ReturnOrderLineItemRejectionReason(SOM_Constants.WRONG_ITEM, SOM_Constants.WRONG_ITEM);
    public static final SOM_ReturnOrderLineItemRejectionReason EXPIRED_WARRANTY = new SOM_ReturnOrderLineItemRejectionReason(SOM_Constants.WRONG_QUANTITY, SOM_Constants.WRONG_QUANTITY);
         
    private SOM_ReturnOrderLineItemRejectionReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ReturnOrderLineItemRejectionReason list
    */
    public static SOM_ReturnOrderLineItemRejectionReason[] values() {
        return STATUSES.values();
    }
}