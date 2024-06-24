/**
* @description Handles application-specific functionality
*/
public with sharing class SOM_Application {
    /**
    * @descripton Service register
    */
    public static final SOM_ServiceFactory Service = new SOM_ServiceFactory(//NOPMD
        new Map<Type, Type>
        {
            SOM_IFulfillmentOrderService.class => SOM_FulfillmentOrderService.class,
            SOM_IOmnichannelInventoryService.class => SOM_OmnichannelInventoryService.class,
            SOM_IOrderSummaryService.class => SOM_OrderSummaryService.class,
            SOM_IPaymentService.class => SOM_PaymentService.class,
            SOM_IReturnOrderService.class => SOM_ReturnOrderService.class,
            SOM_IRoutingService.class => SOM_RoutingService.class
        }
    );

    /**
    * @descripton Selector register
    */
    public static final SOM_SelectorFactory Selector = new SOM_SelectorFactory(//NOPMD
        new Map<Type, Type>
        {
            SOM_IAlternativePaymentMethodSelector.class => SOM_AlternativePaymentMethodSelector.class,
            SOM_ICardPaymentMethodSelector.class => SOM_CardPaymentMethodSelector.class,
            SOM_IDigitalWalletSelector.class => SOM_DigitalWalletSelector.class,
            SOM_IFailedRequestSelector.class => SOM_FailedRequestSelector.class,
            SOM_IFulfillmentOrderSelector.class => SOM_FulfillmentOrderSelector.class,
            SOM_IInvoiceSelector.class => SOM_InvoiceSelector.class,
            SOM_IOrderSelector.class => SOM_OrderSelector.class,
            SOM_IOrderSummarySelector.class => SOM_OrderSummarySelector.class,
            SOM_IPaymentAuthorizationSelector.class => SOM_PaymentAuthorizationSelector.class,
            SOM_IPaymentGatewayLogSelector.class => SOM_PaymentGatewayLogSelector.class,
            SOM_IPaymentGroupSelector.class => SOM_PaymentGroupSelector.class,
            SOM_IPaymentSelector.class => SOM_PaymentSelector.class,
            SOM_IProcessExceptionSelector.class => SOM_ProcessExceptionSelector.class,
            SOM_IReturnOrderSelector.class => SOM_ReturnOrderSelector.class,
            SOM_IShipmentSelector.class => SOM_ShipmentSelector.class   
        }
    );
    
    /**
     * @description Commits changes at once (usually
     *      executed before end of Apex transaction)
     */
    public static void commitChanges() {
        // if Http log insert fails, creates OMS log
        // therefore, should be called before insertLogs
        SOM_CalloutUtil.insertHttpLogs();
        SOM_LogUtil.insertLogs();
    }
}