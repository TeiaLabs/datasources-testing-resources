/**
* @description ProcessException selector interface
*/
@suppressWarnings('PMD.ExcessiveParameterList')
public interface SOM_IProcessExceptionSelector {
    /**
    * @description Selects ProcessException records based on category, status and message
    * @param category category of processException
    * @param status status of processException
    * @param messages processException messages
    * @param querySize query limit
    * @return List of ProcessException
    */
    List<ProcessException> selectByCategoryStatusAndMessage(String category, String status, List<String> messages, Integer querySize);

    /**
    * @description Selects ProcessException records based on Order Summary Id and Status Category
    * @param orderSummaryIds list of order summary ids
    * @param statusValues list of status values
    * @param isCritical isCritical 
    * @param querySize limit
    * @return List of ProcessException
    */
    List<ProcessException> selectByOrderSummaryIdStatusAndIsCritical(List<Id> orderSummaryIds, List<String> statusValues, Boolean isCritical, Integer querySize);

    /**
     * @description Selects ProcessException records based on Attached to Id 
     * @param orderSummaryIds list of prder summary ids
     * @return List of ProcessException 
     */
    List<ProcessException> selectByAttachedToIds(List<String> orderSummaryIds);
}
