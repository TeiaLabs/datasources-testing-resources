/**
* @description DigitalWallet selector interface
*/
public interface SOM_IDigitalWalletSelector {
    /**
    * @description Selects DigitalWallet records based on the Id list
    * @param digitalWalletIds List of the Ids
    * @return List of DigitalWallet
    */
    List<DigitalWallet> selectByIds(List<String> digitalWalletIds);
}