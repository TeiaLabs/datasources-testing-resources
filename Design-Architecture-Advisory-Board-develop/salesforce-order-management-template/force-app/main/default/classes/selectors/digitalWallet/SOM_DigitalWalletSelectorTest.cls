/**
* @description DigitalWallet test class
*/
@isTest
private class SOM_DigitalWalletSelectorTest {

    /**
    * @description Test method of DigitalWalletSelector.selectByIds
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

        DigitalWallet digitalWallet = new DigitalWallet(NickName='Test DigitalWallet', ProcessingMode = 'External', Status = 'inActive');
        insert digitalWallet;
    
        Test.startTest();
        List<DigitalWallet> digitalWallets = new SOM_DigitalWalletSelector().selectByIds(new List<String>{String.valueOf(digitalWallet.Id) });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(digitalWallets)).keySet();
        System.assert(resultIds.contains(digitalWallet.Id), 'No digital wallet record(s) found');
    }
}