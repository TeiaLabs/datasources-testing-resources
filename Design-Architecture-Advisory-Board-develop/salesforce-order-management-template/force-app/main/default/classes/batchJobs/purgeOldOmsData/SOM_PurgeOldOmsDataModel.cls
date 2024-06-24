/**
* @description  : Purge jobs for old oms data | Batch class data model
*    suppress reason : TODO needs refactor
*/
@suppressWarnings('PMD.TooManyFields')
public with sharing class SOM_PurgeOldOmsDataModel {
    public List<String> fulfillmentOrderIdsToBePurged;  
    public List<String> orderSummaryIdsToBePurged;     
    public List<String> cardPaymentMethodIdsToBePurged;
    public List<String> digitalWalletIdsToBePurged;
    public List<String> paymentGroupIdsToBePurged;
    public List<String> shipmentIdsToBePurged;
    public List<String> processExceptionIdsToBePurged;
    public List<String> paymentGatewayLogIdsToBePurged;
    public List<String> returnOrderIdsToBePurged;
    public List<String> relatedOrderIdsToBePurged;
    public List<String> alternativePaymentMethodIdsToBePurged;
    public List<String> originalOrderIdsToBePurged; 
    
    public List<PaymentGatewayLog> paymentGatewayLogList;
    public List<Order> relatedOrdersToBeUpdated;                         
    public List<Order> originalOrdersToBeUpdated;                      
    public List<CardPaymentMethod> cardPaymentMethodsToBeUpdated;
    public List<AlternativePaymentMethod> alternativePaymentMethodsToBeUpdated;
    public List<DigitalWallet> digitalWalletsToBeUpdated;                     
}