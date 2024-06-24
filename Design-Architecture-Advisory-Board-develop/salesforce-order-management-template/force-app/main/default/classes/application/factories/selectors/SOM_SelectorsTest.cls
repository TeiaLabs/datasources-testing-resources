/**
* @description Test class of Selector
*/
@isTest
private class SOM_SelectorsTest {
    /**
    * @description Test method of OrderSummarySelector
    */
    @isTest
    static void shouldGetOrderSummarySelector() {
        SOM_IOrderSummarySelector orderSummarySelector = SOM_Selectors.orderSummary;

        System.assert(orderSummarySelector != null, 'OrderSummarySelector is null');
    }

    /**
    * @description Test method of FulfillmentOrderSelector
    */
    @isTest
    static void shouldGetFulfillmentOrderSelector() {
        SOM_IFulfillmentOrderSelector fulfillmentOrderSelector = SOM_Selectors.fulfillmentOrder;

        System.assert(fulfillmentOrderSelector != null, 'FulfillmentOrderSelector is null');
    }

    /**
    * @description Test method of ReturnOrderSelector
    */
    @isTest
    static void shouldGetReturnOrderSelector() {
        SOM_IReturnOrderSelector returnOrderSelector = SOM_Selectors.returnOrder;

        System.assert(returnOrderSelector != null, 'ReturnOrderSelector is null');
    }
}