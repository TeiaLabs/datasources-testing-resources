/**
* @description AlternativePaymentMethod test class
*/
@isTest
private class SOM_AlternativePaymentMethodSelectorTest {

    /**
    * @description Test method of AlternativePaymentMethodSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectById() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        AlternativePaymentMethod alternativePaymentMethod = new AlternativePaymentMethod(NickName='Test AlternativePaymentMethod', ProcessingMode = 'External', Status = 'inActive');
        insert alternativePaymentMethod;
    
        Test.startTest();
        List<AlternativePaymentMethod> alternativePaymentMethods = new SOM_AlternativePaymentMethodSelector().selectByIds(new List<String>{String.valueOf(alternativePaymentMethod.Id) });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(alternativePaymentMethods)).keySet();
        System.assert(resultIds.contains(alternativePaymentMethod.Id), 'No alternative payment method record(s) found');
    }
}