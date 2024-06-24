/**
* @description Order selector class
*/
public with sharing class SOM_OrderSelector implements SOM_IOrderSelector {
    /**
    * @description Selects RelatedOrder records based on the RelatedOrderId list
    * @param relatedOrderIds List of the Ids
    * @return List of Order
    */
    public List<Order> selectByRelatedOrderIds(List<String> relatedOrderIds) {
        return [SELECT RelatedOrderId 
                FROM Order 
                WHERE RelatedOrderId IN :relatedOrderIds
                WITH SECURITY_ENFORCED];
    }

      /**
    * @description Selects OriginalOrder records based on the Id list
    * @param originalOrderIds List of the Ids
    * @return List of Order
    */
    public List<Order> selectByIds(List<String> originalOrderIds) {
        return [SELECT Id 
                FROM Order 
                WHERE Id IN :originalOrderIds
                WITH SECURITY_ENFORCED];
    }
}