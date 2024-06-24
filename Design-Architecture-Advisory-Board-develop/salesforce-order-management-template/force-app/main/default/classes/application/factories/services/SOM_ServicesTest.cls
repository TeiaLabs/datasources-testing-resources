/**
* @description Test class of Service
*/
@isTest
private class SOM_ServicesTest {
    /**
    * @description Test method of FulfillmentOrderService
    */
    @isTest
    static void shouldCreateFulfillmentOrderService() {
        SOM_IFulfillmentOrderService fulfillmentOrderService = SOM_Services.fulfillmentOrder;

        System.assert(fulfillmentOrderService != null, 'FulfillmentOrderService is null');
    }

    /**
    * @description Test method of OmnichannelInventoryService
    */
    @isTest
    static void shouldCreateOmnichannelInventoryService() {
        SOM_IOmnichannelInventoryService omnichannelInventoryService = SOM_Services.omnichannelInventory;

        System.assert(omnichannelInventoryService != null, 'OmnichannelInventoryService is null');
    }

    /**
    * @description Test method of OrderSummaryService
    */
    @isTest
    static void shouldCreateOrderSummaryService() {
        SOM_IOrderSummaryService orderSummaryService = SOM_Services.orderSummary;

        System.assert(orderSummaryService != null, 'OrderSummaryService is null');
    }

    /**
    * @description Test method of PaymentService
    */
    @isTest
    static void shouldCreatePaymentService() {
        SOM_IPaymentService paymentService = SOM_Services.payment;

        System.assert(paymentService != null, 'PaymentService is null');
    }

    /**
    * @description Test method of ReturnOrderService
    */
    @isTest
    static void shouldCreateReturnOrderService() {
        SOM_IReturnOrderService returnOrderService = SOM_Services.returnOrder;

        System.assert(returnOrderService != null, 'ReturnOrderService is null');
    }

    /**
    * @description Test method of ReturnOrderService
    */
    @isTest
    static void shouldCreateRoutingService() {
        SOM_IRoutingService routingService = SOM_Services.routing;

        System.assert(routingService != null, 'RoutingService is null');
    }
}