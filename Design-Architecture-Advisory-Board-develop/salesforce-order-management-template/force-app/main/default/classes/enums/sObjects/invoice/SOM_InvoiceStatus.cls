/**
* @description InvoiceStatus class
*/
public class SOM_InvoiceStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_InvoiceStatus> STATUSES = new Map<String, SOM_InvoiceStatus>();
    
    public static final SOM_InvoiceStatus DRAFT = new SOM_InvoiceStatus(SOM_Constants.DRAFT, SOM_Constants.DRAFT);
    public static final SOM_InvoiceStatus PENDING = new SOM_InvoiceStatus(SOM_Constants.PENDING, SOM_Constants.PENDING);
    public static final SOM_InvoiceStatus POSTED = new SOM_InvoiceStatus(SOM_Constants.POSTED, SOM_Constants.POSTED);
    public static final SOM_InvoiceStatus CANCELED = new SOM_InvoiceStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
    public static final SOM_InvoiceStatus ERROR_POSTING = new SOM_InvoiceStatus(SOM_Constants.ERROR_POSTING, SOM_Constants.ERROR_POSTING);
         
    private SOM_InvoiceStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return InvoiceStatus list
    */
    public static SOM_InvoiceStatus[] values() {
        return STATUSES.values();
    }
}
