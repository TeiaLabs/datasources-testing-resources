/**
* @description DigitalWallet selector class
*/
public with sharing class SOM_DigitalWalletSelector implements SOM_IDigitalWalletSelector {
    /**
    * @description Selects DigitalWallet records based on the Id list
    * @param digitalWalletIds List of the Ids
    * @return List of DigitalWallet
    */
    public List<DigitalWallet> selectByIds(List<String> digitalWalletIds) {
        return [SELECT Status
                FROM DigitalWallet 
                WHERE Id IN :digitalWalletIds
                WITH SECURITY_ENFORCED];
    }
}