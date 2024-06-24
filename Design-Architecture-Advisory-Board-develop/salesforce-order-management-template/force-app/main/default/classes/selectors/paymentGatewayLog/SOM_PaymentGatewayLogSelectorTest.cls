/**
* @description PaymentGatewayLog test class
*/
@isTest
private class SOM_PaymentGatewayLogSelectorTest {

    /**
    * @description Test method of PaymentGatewayLogSelector.selectByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        OrderPaymentSummary orderPaymentSummary = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummaryId];
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        PaymentGatewayLog paymentGatewayLog = new PaymentGatewayLog(OrderPaymentSummaryId = orderPaymentSummary.Id);
        insert paymentGatewayLog;
    
        Test.startTest();
        List<PaymentGatewayLog> paymentGatewayLogs = new SOM_PaymentGatewayLogSelector().selectByOrderSummaryIds(new List<String>{String.valueOf(orderSummaryId) });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(paymentGatewayLogs)).keySet();
        System.assert(resultIds.contains(paymentGatewayLog.Id), 'No payment gateway log record(s) found');
    }
}