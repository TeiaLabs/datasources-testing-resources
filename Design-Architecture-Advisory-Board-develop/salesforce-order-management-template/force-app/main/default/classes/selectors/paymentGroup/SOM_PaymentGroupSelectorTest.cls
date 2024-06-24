/**
* @description PaymentGroup test class
*/
@isTest
private class SOM_PaymentGroupSelectorTest {

    /**
    * @description Test method of PaymentGroupSelector.selectBySourceObjectIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectBySourceObjectIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        OrderSummary orderSummary = [SELECT OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId];
       
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
        PaymentGroup paymentGroup = [SELECT SourceObjectId FROM PaymentGroup WHERE SourceObjectId = :orderSummary.OriginalOrderId LIMIT 1];

        Test.startTest();
        List<PaymentGroup> paymentGroups = new SOM_PaymentGroupSelector().selectBySourceObjectIds(new List<String>{String.valueOf(paymentGroup.SourceObjectId) });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(paymentGroups)).keySet();
        System.assert(resultIds.contains(paymentGroup.Id), 'No alternative payment method record(s) found');
    }
}