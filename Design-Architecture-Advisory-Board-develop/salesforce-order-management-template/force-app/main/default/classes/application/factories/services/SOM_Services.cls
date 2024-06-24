/**
* @description Service class to contain all service instances
*/
public with sharing class SOM_Services {
    private static SOM_IFulfillmentOrderService fulfillmentOrderService;
    private static SOM_IOmnichannelInventoryService omnichannelInventoryService;
    private static SOM_IOrderSummaryService orderSummaryService;
    private static SOM_IPaymentService paymentService;
    private static SOM_IReturnOrderService returnOrderService;
    private static SOM_IRoutingService routingService;
    
    /**
    * @description The service of FulfillmentOrder 
    */
    public static SOM_IFulfillmentOrderService fulfillmentOrder
    {
        get 
        {
            if (fulfillmentOrderService == null) {
                fulfillmentOrderService = (SOM_IFulfillmentOrderService)SOM_Application.Service.newInstance(SOM_IFulfillmentOrderService.class);
            }
            return fulfillmentOrderService;
        } 
        
        set;
    }

    /**
    * @description The service of OmnichannelInventoryService 
    */
    public static SOM_IOmnichannelInventoryService omnichannelInventory
    {
        get 
        {
            if (omnichannelInventoryService == null) {
                omnichannelInventoryService = (SOM_IOmnichannelInventoryService)SOM_Application.Service.newInstance(SOM_IOmnichannelInventoryService.class);
            }
            return omnichannelInventoryService;
        } 
        
        set;
    }

    /**
    * @description The service of OrderSummary 
    */
    public static SOM_IOrderSummaryService orderSummary
    {
        get 
        {
            if (orderSummaryService == null) {
                orderSummaryService = (SOM_IOrderSummaryService)SOM_Application.Service.newInstance(SOM_IOrderSummaryService.class);
            }
            return orderSummaryService;
        } 
        
        set;
    }

    /**
    * @description The service of Payment 
    */
    public static SOM_IPaymentService payment
    {
        get 
        {
            if (paymentService == null) {
                paymentService = (SOM_IPaymentService)SOM_Application.Service.newInstance(SOM_IPaymentService.class);
            }
            return paymentService;
        } 
        
        set;
    }

    /**
    * @description The service of ReturnOrder 
    */
    public static SOM_IReturnOrderService returnOrder
    {
        get 
        {
            if (returnOrderService == null) {
                returnOrderService = (SOM_IReturnOrderService)SOM_Application.Service.newInstance(SOM_IReturnOrderService.class);
            }
            return returnOrderService;
        } 
        
        set;
    }

    /**
    * @description The service of routing 
    */
    public static SOM_IRoutingService routing
    {
        get 
        {
            if (routingService == null) {
                routingService = (SOM_IRoutingService)SOM_Application.Service.newInstance(SOM_IRoutingService.class);
            }
            return routingService;
        } 
        
        set;
    }
}