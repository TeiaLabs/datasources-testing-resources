/**
* @description OrderItemSummaryStatus class
*/
public class SOM_OrderItemSummaryStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_OrderItemSummaryStatus> STATUSES = new Map<String, SOM_OrderItemSummaryStatus>();
    
    public static final SOM_OrderItemSummaryStatus ALLOCATED = new SOM_OrderItemSummaryStatus(SOM_Constants.ALLOCATED, SOM_Constants.ALLOCATED.toUpperCase());
    public static final SOM_OrderItemSummaryStatus CANCELED = new SOM_OrderItemSummaryStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED.toUpperCase());
    public static final SOM_OrderItemSummaryStatus FULFILLED = new SOM_OrderItemSummaryStatus(SOM_Constants.FULFILLED, SOM_Constants.FULFILLED.toUpperCase());
    public static final SOM_OrderItemSummaryStatus ORDERED = new SOM_OrderItemSummaryStatus(SOM_Constants.ORDERED, SOM_Constants.ORDERED.toUpperCase());
    public static final SOM_OrderItemSummaryStatus PAID = new SOM_OrderItemSummaryStatus(SOM_Constants.PAID, SOM_Constants.PAID.toUpperCase());
    public static final SOM_OrderItemSummaryStatus PARTIALLY_ALLOCATED = new SOM_OrderItemSummaryStatus(SOM_Constants.PARTIALLY_ALLOCATED, SOM_Constants.PARTIALLYALLOCATED);
    public static final SOM_OrderItemSummaryStatus PARTIALLY_FULFILLED = new SOM_OrderItemSummaryStatus(SOM_Constants.PARTIALLY_FULFILLED, SOM_Constants.PARTIALLYFULFILLED);
    public static final SOM_OrderItemSummaryStatus RESHIPPED = new SOM_OrderItemSummaryStatus(SOM_Constants.RESHIPPED, SOM_Constants.RESHIPPED);
    public static final SOM_OrderItemSummaryStatus RETURNED = new SOM_OrderItemSummaryStatus(SOM_Constants.RETURNED, SOM_Constants.RETURNED);
    public static final SOM_OrderItemSummaryStatus RETURN_INITIATED = new SOM_OrderItemSummaryStatus(SOM_Constants.RETURN_INITIATED, SOM_Constants.RETURNINITIATED);
         
    private SOM_OrderItemSummaryStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderItemSummaryStatus list
    */
    public static SOM_OrderItemSummaryStatus[] values() {
        return STATUSES.values();
    }
}