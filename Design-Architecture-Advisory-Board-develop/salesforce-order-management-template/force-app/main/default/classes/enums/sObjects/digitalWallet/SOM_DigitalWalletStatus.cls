/**
* @description DigitalWalletStatus class
*/
public class SOM_DigitalWalletStatus extends SOM_BaseEnum {
    private static final Map<String, SOM_DigitalWalletStatus> STATUSES = new Map<String, SOM_DigitalWalletStatus>();
    
    public static final SOM_DigitalWalletStatus ACTIVE = new SOM_DigitalWalletStatus(SOM_Constants.ACTIVE, SOM_Constants.ACTIVE);
    public static final SOM_DigitalWalletStatus INACTIVE = new SOM_DigitalWalletStatus(SOM_Constants.INACTIVE, SOM_Constants.INACTIVE);
    public static final SOM_DigitalWalletStatus CANCELED = new SOM_DigitalWalletStatus(SOM_Constants.CANCELED, SOM_Constants.CANCELED);
         
    private SOM_DigitalWalletStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return DigitalWalletStatus list
    */
    public static SOM_DigitalWalletStatus[] values() {
        return STATUSES.values();
    }
}
