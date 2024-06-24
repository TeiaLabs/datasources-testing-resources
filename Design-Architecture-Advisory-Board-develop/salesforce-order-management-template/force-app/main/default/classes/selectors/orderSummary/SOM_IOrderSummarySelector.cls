/**
* @description OrderSummary selector interface
*/
@suppressWarnings('PMD.ExcessiveParameterList')
public interface SOM_IOrderSummarySelector {
    
    /**
    * @description Selects OrderSummary records based on the Id list
    * @param orderSummaryIds List of the Ids
    * @return List of OrderSummary
    */
    List<OrderSummary> selectByIds(List<String> orderSummaryIds);

    /**
    * @description Selects OrderItemSummary records by OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of OrderItemSummary
    */
    List<OrderItemSummary> selectOrderItemSummariesByOrderSummaryIds(List<String> orderSummaryIds);

    /**
    * @description Selects OrderSummary records based on status category and isCritical fields of related ProcessException
    * @param statusCategory
    * @param isCritical 
    * @param querySize limit of queries
    * @return List of OrderSummary
    */
    List<OrderSummary> selectByStatusCategoryAndIsCriticalFieldsOfRelatedProcessException(String statusCategory, Boolean isCritical, Integer querySize);

    /**
    * @description Selects OrderSummary records based on LastModifiedDate and Status
    * @param approvedStatus
    * @param approvedStatusDate 
    * @param fulfilledStatus  
    * @param fulfilledStatusDate
    * @param allStatusDate 
    * @param querySize limit of queries
    * @return List of OrderSummary
    */
    List<OrderSummary> selectByStatusAndLastModifiedDate(String approvedStatus, Datetime approvedStatusDate, String fulfilledStatus, Datetime fulfilledStatusDate, Datetime allStatusDate, Integer querySize);
}