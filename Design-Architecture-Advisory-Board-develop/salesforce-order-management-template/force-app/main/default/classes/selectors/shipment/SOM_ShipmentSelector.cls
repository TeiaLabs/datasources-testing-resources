/**
* @description Shipment selector class
*/
public with sharing class SOM_ShipmentSelector implements SOM_IShipmentSelector {
    /**
    * @description Selects Shipment records by list of OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of Shipment
    */
    public List<Shipment> selectByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT Id 
                FROM Shipment 
                WHERE OrderSummaryId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }
}