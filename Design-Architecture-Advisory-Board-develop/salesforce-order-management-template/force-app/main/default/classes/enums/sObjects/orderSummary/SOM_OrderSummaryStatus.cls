/**
* @description OrderSummaryStatus class
*/
public class SOM_OrderSummaryStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_OrderSummaryStatus> STATUSES = new Map<String, SOM_OrderSummaryStatus>();
    
    public static final SOM_OrderSummaryStatus CREATED = new SOM_OrderSummaryStatus(SOM_Constants.CREATED, SOM_Constants.CREATED);
    public static final SOM_OrderSummaryStatus CANCELLED = new SOM_OrderSummaryStatus(SOM_Constants.CANCELLED, SOM_Constants.CANCELLED);
         
    private SOM_OrderSummaryStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderSummaryStatus list
    */
    public static SOM_OrderSummaryStatus[] values() {
        return STATUSES.values();
    }
}