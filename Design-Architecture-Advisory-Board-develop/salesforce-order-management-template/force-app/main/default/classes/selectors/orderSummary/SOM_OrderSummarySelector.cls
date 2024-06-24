/**
* @description OrderSummary selector class
*/
public with sharing class SOM_OrderSummarySelector implements SOM_IOrderSummarySelector {
    
    /**
    * @description Selects OrderSummary records based on the Id list
    * @param orderSummaryIds List of the Ids
    * @return List of OrderSummary
    */
    public List<OrderSummary> selectByIds(List<String> orderSummaryIds) {
        return [SELECT Id 
                FROM OrderSummary 
                WHERE Id IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects OrderItemSummary records by OrderSummary Id
    * @param orderSummaryIds List of the OrderSummary Ids
    * @return List of OrderItemSummary
    */
    public List<OrderItemSummary> selectOrderItemSummariesByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT
                    OrderSummaryId,
                    Quantity,
                    QuantityAvailableToCancel,
                    QuantityAvailableToReturn,
                    QuantityReturnInitiated,
                    QuantityReturned,
                    QuantityAllocated, 
                    QuantityFulfilled, 
                    TotalAmtWithTax,
                    Type
                FROM OrderItemSummary 
                WHERE OrderSummaryId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects OrderSummary records based on status category and isCritical fields of related ProcessException
    * @param statusCategory
    * @param isCritical 
    * @param querySize limit of queries
    * @return List of OrderSummary
    */
    public List<OrderSummary> selectByStatusCategoryAndIsCriticalFieldsOfRelatedProcessException(String statusCategory, Boolean isCritical, Integer querySize){
        return [SELECT
                    Id
                FROM OrderSummary 
                WHERE Id IN 
                    (SELECT 
                        OrderSummaryId 
                    FROM ProcessException 
                    WHERE StatusCategory =: statusCategory 
                    AND IsCritical__c =: isCritical)
                WITH SECURITY_ENFORCED
                LIMIT :querySize];
    }

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
    @suppressWarnings('PMD.ExcessiveParameterList')
    public List<OrderSummary> selectByStatusAndLastModifiedDate(String approvedStatus, Datetime approvedStatusDate, String fulfilledStatus, Datetime fulfilledStatusDate, Datetime allStatusDate, Integer querySize ){
        return [SELECT OriginalOrderId 
                FROM OrderSummary 
                WHERE (STATUS = :approvedStatus AND LastModifiedDate <= :approvedStatusDate) 
                    OR (STATUS = :fulfilledStatus AND LastModifiedDate <= :fulfilledStatusDate) 
                    OR (LastModifiedDate <= :allStatusDate) 
                WITH SECURITY_ENFORCED
                LIMIT :querySize];
    }
}