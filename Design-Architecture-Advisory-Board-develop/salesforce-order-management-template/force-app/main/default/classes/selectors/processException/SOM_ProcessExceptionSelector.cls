/**
* @description ProcessException selector class
*/
public with sharing class SOM_ProcessExceptionSelector implements SOM_IProcessExceptionSelector {
    /**
    * @description Selects ProcessException records based on catehory, status and message
    * @param category category of processException
    * @param status status of processException
    * @param messages processException messages
    * @param querySize query limit
    * @return List of ProcessException
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public List<ProcessException> selectByCategoryStatusAndMessage(String category, String status, List<String> messages, Integer querySize){
        return [SELECT 
                    AttachedToId, 
                    Description, 
                    Category, 
                    Message, 
                    OrderSummaryId
                FROM ProcessException
                WHERE
                    Category =: category
                    AND Status =: status
                    AND Message IN: messages
                WITH SECURITY_ENFORCED
                LIMIT :querySize];
    }

    /**
    * @description Selects ProcessException records based on Order Summary Id and Status Category
    * @param orderSummaryIds list of order summary ids
    * @param statusValues list of status values
    * @param isCritical isCritical 
    * @param querySize limit
    * @return List of ProcessException
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public List<ProcessException> selectByOrderSummaryIdStatusAndIsCritical(List<Id> orderSummaryIds, List<String> statusValues, Boolean isCritical, Integer querySize){
        return [SELECT 
                    OrderSummaryId,
                    AttachedToId, 
                    Description, 
                    Category, 
                    Message, 
                    Priority,
                    Severity,
                    CreatedDate,
                    Status
                FROM ProcessException
                WHERE
                    OrderSummaryId IN: orderSummaryIds
                    AND Status IN: statusValues
                    AND IsCritical__c =: isCritical
                WITH SECURITY_ENFORCED
                ORDER BY CreatedDate ASC
                ];
    }

    /**
    * @description Selects ProcessException records based on Order Summary Id 
    * @param orderSummaryIds
    * @return List of ProcessException
    */
    public List<ProcessException> selectByOrderSummaryIds(List<String> orderSummaryIds) {
        return [SELECT 
                    OrderSummaryId
                FROM ProcessException
                WHERE
                    OrderSummaryId IN :orderSummaryIds
                    WITH SECURITY_ENFORCED];
    }

    /**
    * @description Selects ProcessException records based on AthacedToId 
    * @param orderSummaryIds
    * @return List of ProcessException
    */
    public List<ProcessException> selectByAttachedToIds(List<String> orderSummaryIds) {
        return [SELECT AttachedToId
                FROM ProcessException
                WHERE AttachedToId IN :orderSummaryIds
                WITH SECURITY_ENFORCED];
    }
}