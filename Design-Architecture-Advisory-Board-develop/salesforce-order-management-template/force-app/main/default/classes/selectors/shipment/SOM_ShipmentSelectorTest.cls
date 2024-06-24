/**
* @description Shipment test class
*/
@isTest
private class SOM_ShipmentSelectorTest {
    
    /**
    * @description Test method of ShipmentSelector.selectByOrderSummaryIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldSelectByOrderSummaryIds() {
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        Shipment shipment = new Shipment(OrderSummaryId = orderSummaryId, ShipToName = 'Test Shipment');
        insert shipment;
    
        Test.startTest();
        List<Shipment> shipments = new SOM_ShipmentSelector().selectByOrderSummaryIds(new List<String>{String.valueOf(orderSummaryId)});
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(shipments)).keySet();
        System.assert(resultIds.contains(shipment.Id), 'No shipment record(s) found');
    }
}