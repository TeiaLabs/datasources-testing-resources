/**
* @description CardPaymentMethod test class
*/
@isTest
private class SOM_CardPaymentMethodSelectorTest {
    
    /**
    * @description Test method of CardPaymentMethodSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectByIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        CardPaymentMethod cardPaymentMethod = new CardPaymentMethod(NickName='Test CardPaymentMethod', ProcessingMode = 'External', Status = 'inActive');
        insert cardPaymentMethod;
    
        Test.startTest();
        List<CardPaymentMethod> cardPaymentMethods = new SOM_CardPaymentMethodSelector().selectByIds(new List<String>{String.valueOf(cardPaymentMethod.Id) });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(cardPaymentMethods)).keySet();
        System.assert(resultIds.contains(cardPaymentMethod.Id), 'No card payment method record(s) found');
    }
}