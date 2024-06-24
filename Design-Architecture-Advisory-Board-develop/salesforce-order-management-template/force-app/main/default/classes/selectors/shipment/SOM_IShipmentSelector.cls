/**
* @description Shipment selector interface
*/
public interface SOM_IShipmentSelector {
    /**
    * @description Selects Shipment records by list of OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of Shipment
    */
    List<Shipment> selectByOrderSummaryIds(List<String> orderSummaryIds);
}