/**
* @description OriginalOrder selector interface
*/
public interface SOM_IOrderSelector {
    /**
    * @description Selects OriginalOrder records based on the Id list
    * @param originalOrderIds List of the Ids
    * @return List of Order
    */
    List<Order> selectByIds(List<String> originalOrderIds);

     /**
    * @description Selects RelatedOrder records based on the RelatedOrderId list
    * @param relatedOrderIds List of the Ids
    * @return List of Order
    */
    List<Order> selectByRelatedOrderIds(List<String> relatedOrderIds);
}