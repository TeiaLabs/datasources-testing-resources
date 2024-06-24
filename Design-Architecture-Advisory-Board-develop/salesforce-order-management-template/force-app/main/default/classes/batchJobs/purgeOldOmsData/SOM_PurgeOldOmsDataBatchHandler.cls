/** 
* @description  : Purge jobs for old oms data | Batch class handler
*    supress reason : TODO needs refactor
*/
@suppressWarnings('PMD.CyclomaticComplexity')
public with sharing class SOM_PurgeOldOmsDataBatchHandler {
    private static List<Database.DeleteResult> deleteResults = new List<Database.DeleteResult>();
    private static List<Database.SaveResult> updateResults = new List<Database.SaveResult>();
                     
    private static List<Id> originalOrderIdsList;
    private static List<Id> paymentMethodIdsList;
    private static Map<Id, OrderSummary> osPurgeMap;

    /**
    * @description Collects Ids of old objects
    * @param orderSummaryList
    * @param purgePaymentGatewayLogs
    *   supress reason : TODO needs refactor
    */
    @suppressWarnings('PMD.NcssMethodCount')
    public static void purgeOldOmsRecords(List<orderSummary> orderSummaryList, Boolean purgePaymentGatewayLogs) {
        collectOriginalOrderAndPaymentMethodIds(orderSummaryList);

        // Collects ids of objects which will be deleted
        SOM_PurgeOldOmsDataModel purgeOldOmsDataModel = new SOM_PurgeOldOmsDataModel();
        purgeOldOmsDataModel.orderSummaryIdsToBePurged = new List<String>((new Map<String, OrderSummary>(SOM_Selectors.orderSummary.selectByIds(new List<Id>(osPurgeMap.keySet())))).keySet());
        purgeOldOmsDataModel.processExceptionIdsToBePurged = new List<String>((new Map<String, ProcessException>(SOM_Selectors.processException.selectByAttachedToIds(new List<Id>(osPurgeMap.keySet())))).keySet());
        purgeOldOmsDataModel.fulfillmentOrderIdsToBePurged = new List<String>((new Map<String, FulfillmentOrder>(SOM_Selectors.fulfillmentOrder.selectByOrderSummaryIds(new List<Id>(osPurgeMap.keySet())))).keySet());
        purgeOldOmsDataModel.paymentGroupIdsToBePurged = new List<String>((new Map<String, PaymentGroup>(SOM_Selectors.paymentGroup.selectBySourceObjectIds(originalOrderIdsList))).keySet());
        purgeOldOmsDataModel.returnOrderIdsToBePurged = new List<String>((new Map<String, ReturnOrder>(SOM_Selectors.returnOrder.selectByOrderSummaryIds(new List<Id>(osPurgeMap.keySet())))).keySet());
        purgeOldOmsDataModel.shipmentIdsToBePurged = new List<String>((new Map<String, Shipment>(SOM_Selectors.shipment.selectByOrderSummaryIds(new List<Id>(osPurgeMap.keySet())))).keySet());
        purgeOldOmsDataModel.relatedOrdersToBeUpdated = SOM_Selectors.order.selectByRelatedOrderIds(originalOrderIdsList);
        purgeOldOmsDataModel.originalOrdersToBeUpdated = SOM_Selectors.order.selectByIds(originalOrderIdsList);
        purgeOldOmsDataModel.alternativePaymentMethodsToBeUpdated = SOM_Selectors.alternativePaymentMethod.selectByIds(paymentMethodIdsList);
        purgeOldOmsDataModel.digitalWalletsToBeUpdated = SOM_Selectors.digitalWallet.selectByIds(paymentMethodIdsList);
        purgeOldOmsDataModel.cardPaymentMethodsToBeUpdated = SOM_Selectors.cardPaymentMethod.selectByIds(paymentMethodIdsList);

        // Checks if purgePaymentGatewayLogs true 
        if (purgePaymentGatewayLogs) { 
            purgeOldOmsDataModel.paymentGatewayLogList = SOM_Selectors.paymentGatewayLog.selectByOrderSummaryIds(new List<Id>(osPurgeMap.keySet()));    
        }
        
        // Creates new lists
        purgeOldOmsDataModel.alternativePaymentMethodIdsToBePurged = new List<String>();
        purgeOldOmsDataModel.digitalWalletIdsToBePurged = new List<String>();
        purgeOldOmsDataModel.cardPaymentMethodIdsToBePurged = new List<String>();
        purgeOldOmsDataModel.originalOrderIdsToBePurged = new List<String>();
        purgeOldOmsDataModel.relatedOrderIdsToBePurged = new List<String>();
        purgeOldOmsDataModel.paymentGatewayLogIdsToBePurged = new List<String>();
        
        // With the collectObjectIds method collects Ids
        collectObjectIds(purgeOldOmsDataModel.relatedOrdersToBeUpdated, purgeOldOmsDataModel.relatedOrderIdsToBePurged);
        collectObjectIds(purgeOldOmsDataModel.paymentGatewayLogList, purgeOldOmsDataModel.paymentGatewayLogIdsToBePurged);
        collectObjectIds(purgeOldOmsDataModel.originalOrdersToBeUpdated, purgeOldOmsDataModel.originalOrderIdsToBePurged);
        collectObjectIds(purgeOldOmsDataModel.alternativePaymentMethodsToBeUpdated, purgeOldOmsDataModel.alternativePaymentMethodIdsToBePurged);
        collectObjectIds(purgeOldOmsDataModel.digitalWalletsToBeUpdated, purgeOldOmsDataModel.digitalWalletIdsToBePurged);
        collectObjectIds(purgeOldOmsDataModel.cardPaymentMethodsToBeUpdated, purgeOldOmsDataModel.cardPaymentMethodIdsToBePurged);

        // Changes Order stasuses
        changeOrderStatusToDraft(purgeOldOmsDataModel.originalOrdersToBeUpdated, purgeOldOmsDataModel.originalOrderIdsToBePurged);
        changeOrderStatusToDraft(purgeOldOmsDataModel.relatedOrdersToBeUpdated, purgeOldOmsDataModel.relatedOrderIdsToBePurged);

        // Changes the status of Card Payment Method
        for (CardPaymentMethod cardPaymentMethodToBePurged : purgeOldOmsDataModel.cardPaymentMethodsToBeUpdated) {     
            cardPaymentMethodToBePurged.Status = SOM_CardPaymentMethodStatus.INACTIVE.toString();
           
            purgeOldOmsDataModel.cardPaymentMethodIdsToBePurged.add(String.valueOf(cardPaymentMethodToBePurged.Id));                     
        }
        
        // Changes the status of Alternative Payment Method
        for (AlternativePaymentMethod alternativePaymentMethodToBePurged : purgeOldOmsDataModel.alternativePaymentMethodsToBeUpdated) { 
            alternativePaymentMethodToBePurged.Status = 'inActive';
           
            purgeOldOmsDataModel.alternativePaymentMethodIdsToBePurged.add(String.valueOf(alternativePaymentMethodToBePurged.Id));            
        }

        // Changes the status of Digital Wallet
        for (DigitalWallet digitalWalletToBePurged : purgeOldOmsDataModel.digitalWalletsToBeUpdated) {     
            digitalWalletToBePurged.Status = 'inActive';
            purgeOldOmsDataModel.digitalWalletIdsToBePurged.add(String.valueOf(digitalWalletToBePurged.Id));  
        }

        // Updates records
        updateRecords(purgeOldOmsDataModel.cardPaymentMethodsToBeUpdated);
        updateRecords(purgeOldOmsDataModel.digitalWalletsToBeUpdated);
        updateRecords(purgeOldOmsDataModel.alternativePaymentMethodsToBeUpdated);
        updateRecords(purgeOldOmsDataModel.relatedOrdersToBeUpdated);
        updateRecords(purgeOldOmsDataModel.originalOrdersToBeUpdated);
        
        // Deletes records
        deleteRecords(purgeOldOmsDataModel.paymentGroupIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.returnOrderIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.processExceptionIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.shipmentIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.paymentGatewayLogIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.fulfillmentOrderIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.orderSummaryIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.relatedOrderIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.originalOrderIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.cardPaymentMethodIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.digitalWalletIdsToBePurged);
        deleteRecords(purgeOldOmsDataModel.alternativePaymentMethodIdsToBePurged);
        
        // Collects errors
        SOM_Application.commitChanges();
    }

    /**
    * @description changes orders status' to draft
    * @param orderList is related and original orders that we have queried
    * @param stringOrderIdsList List Id's of orders to be purged
    */
    private static void changeOrderStatusToDraft(List<Order> orderList, List<String> stringOrderIdsList) {
        for (Order ordersToBeMenaged : orderList) {
            ordersToBeMenaged.Status = SOM_OrderStatus.DRAFT.toString();
            stringOrderIdsList.add(String.valueOf(ordersToBeMenaged.Id));
        }
    }

    /**
    * @description updates records and adds resulst to a List
    * @param objectList objects to be updated 
    */    
    private static void updateRecords(List<sObject> objectList) {
        updateResults.addAll(SOM_DatabaseUtil.updateRecords(objectList, false));
    }

    /**
    * @description deletes records and adds resulst to a List
    * @param idList objects' Ids to be updated 
    */    
    private static void deleteRecords(List<String> idList) {
        deleteResults.addAll(SOM_DatabaseUtil.deleteRecords(idList, false));
    }

    /**
    * @description collects ids of objects to be purged
    * @param sObjectList List of objects that we have queried
    * @param stringIdsList Id's of objects to be purged
    */    
    private static void collectObjectIds(List<sObject> sObjectList, List<String> stringIdsList) {
        for (sObject objectIdToBeCollected : sObjectList) {
            stringIdsList.add(string.valueOf(objectIdToBeCollected.Id));
        }
    }

    /**
    * @description collects original orders and payment methods
    * @param orderSummaryList 
    */
    private static void collectOriginalOrderAndPaymentMethodIds(List<OrderSummary> orderSummaryList) {
        originalOrderIdsList = new List<Id>();
        paymentMethodIdsList = new List<Id>();
        osPurgeMap = new Map<Id, OrderSummary>();
        for (OrderSummary orderSummary :orderSummaryList) {
            osPurgeMap.put(orderSummary.Id, orderSummary);
            originalOrderIdsList.add(orderSummary.OriginalOrderId);
        }

        List<orderPaymentSummary> orderPaymentSummaries = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId IN :osPurgeMap.keySet() WITH SECURITY_ENFORCED];
        for (orderPaymentSummary orderPaymentSummary : orderPaymentSummaries) {
            paymentMethodIdsList.add(orderPaymentSummary.PaymentMethodId);
        }
    }
}