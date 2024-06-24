/**
* @description Selector class to contain all selector instances
*/
@suppressWarnings('PMD.ExcessivePublicCount')
public class SOM_Selectors {
    private static SOM_IAlternativePaymentMethodSelector alternativePaymentMethodSelector;
    private static SOM_ICardPaymentMethodSelector cardPaymentMethodSelector;
    private static SOM_IDigitalWalletSelector digitalWalletSelector;
    private static SOM_IFailedRequestSelector failedRequestSelector;
    private static SOM_IFulfillmentOrderSelector fulfillmentOrderSelector;
    private static SOM_IInvoiceSelector invoiceSelector;
    private static SOM_IOrderSelector orderSelector;
    private static SOM_IOrderSummarySelector orderSummarySelector;
    private static SOM_IPaymentAuthorizationSelector paymentAuthorizationSelector;
    private static SOM_IPaymentGatewayLogSelector paymentGatewayLogSelector;
    private static SOM_IPaymentGroupSelector paymentGroupSelector;
    private static SOM_IPaymentSelector paymentSelector;
    private static SOM_IProcessExceptionSelector processExceptionSelector;
    private static SOM_IReturnOrderSelector returnOrderSelector;
    private static SOM_IShipmentSelector shipmentSelector;

    /**
    * @description The selector of FulfillmentOrder 
    */
    public static SOM_IFulfillmentOrderSelector fulfillmentOrder
    {
        get 
        {
            if (fulfillmentOrderSelector == null) {
                fulfillmentOrderSelector = (SOM_IFulfillmentOrderSelector)SOM_Application.Selector.newInstance(SOM_IFulfillmentOrderSelector.class);
            }
            return fulfillmentOrderSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of FulfillmentOrder 
    */
    public static SOM_IFailedRequestSelector failedRequest
    {
        get 
        {
            if (failedRequestSelector == null) {
                failedRequestSelector = (SOM_IFailedRequestSelector)SOM_Application.Selector.newInstance(SOM_IFailedRequestSelector.class);
            }
            return failedRequestSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of OrderSummary 
    */
    public static SOM_IOrderSummarySelector orderSummary
    {
        get 
        {
            if (orderSummarySelector == null) {
                orderSummarySelector = (SOM_IOrderSummarySelector)SOM_Application.Selector.newInstance(SOM_IOrderSummarySelector.class);
            }
            return orderSummarySelector;
        } 
        
        set;
    }

    /**
    * @description The selector of Invoice 
    */
    public static SOM_IInvoiceSelector invoice
    {
        get 
        {
            if (invoiceSelector == null) {
                invoiceSelector = (SOM_IInvoiceSelector)SOM_Application.Selector.newInstance(SOM_IInvoiceSelector.class);
            }
            return invoiceSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of Payment 
    */
    public static SOM_IPaymentSelector payment
    {
        get 
        {
            if (paymentSelector == null) {
                paymentSelector = (SOM_IPaymentSelector)SOM_Application.Selector.newInstance(SOM_IPaymentSelector.class);
            }
            return paymentSelector;
        } 
        
        set;
    }
    
    /**
    * @description The selector of PaymentAuthorization 
    */
    public static SOM_IPaymentAuthorizationSelector paymentAuthorization
    {
        get 
        {
            if (paymentAuthorizationSelector == null) {
                paymentAuthorizationSelector = (SOM_IPaymentAuthorizationSelector)SOM_Application.Selector.newInstance(SOM_IPaymentAuthorizationSelector.class);
            }
            return paymentAuthorizationSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of ProcessException 
    */
    public static SOM_IProcessExceptionSelector processException
    {
        get 
        {
            if (processExceptionSelector == null) {
                processExceptionSelector = (SOM_IProcessExceptionSelector)SOM_Application.Selector.newInstance(SOM_IProcessExceptionSelector.class);
            }
            return processExceptionSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of ReturnOrder 
    */
    public static SOM_IReturnOrderSelector returnOrder
    {
        get 
        {
            if (returnOrderSelector == null) {
                returnOrderSelector = (SOM_IReturnOrderSelector)SOM_Application.Selector.newInstance(SOM_IReturnOrderSelector.class);
            }
            return returnOrderSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of PaymentGroup 
    */
    public static SOM_IPaymentGroupSelector paymentGroup
    {
        get 
        {
            if (paymentGroupSelector == null) {
                paymentGroupSelector = (SOM_IPaymentGroupSelector)SOM_Application.Selector.newInstance(SOM_IPaymentGroupSelector.class);
            }
            return paymentGroupSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of Shipment 
    */
    public static SOM_IShipmentSelector shipment
    {
        get 
        {
            if (shipmentSelector == null) {
                shipmentSelector = (SOM_IShipmentSelector)SOM_Application.Selector.newInstance(SOM_IShipmentSelector.class);
            }
            return shipmentSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of Order 
    */
    public static SOM_IOrderSelector order
    {
        get 
        {
            if (orderSelector == null) {
                orderSelector = (SOM_IOrderSelector)SOM_Application.Selector.newInstance(SOM_IOrderSelector.class);
            }
            return orderSelector;
        } 
        
        set;
    }
    
    /**
    * @description The selector of alternativePaymentMethod 
    */
    public static SOM_IAlternativePaymentMethodSelector alternativePaymentMethod
    {
        get 
        {
            if (alternativePaymentMethodSelector == null) {
                alternativePaymentMethodSelector = (SOM_IAlternativePaymentMethodSelector)SOM_Application.Selector.newInstance(SOM_IAlternativePaymentMethodSelector.class);
            }
            return alternativePaymentMethodSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of DigitalWallet 
    */
    public static SOM_IDigitalWalletSelector digitalWallet
    {
        get 
        {
            if (digitalWalletSelector == null) {
                digitalWalletSelector = (SOM_IDigitalWalletSelector)SOM_Application.Selector.newInstance(SOM_IDigitalWalletSelector.class);
            }
            return digitalWalletSelector;
        } 
        
        set;
    }

    /**
    * @description The selector of cardPaymentMethod 
    */
    public static SOM_ICardPaymentMethodSelector cardPaymentMethod
    {
        get 
        {
            if (cardPaymentMethodSelector == null) {
                cardPaymentMethodSelector = (SOM_ICardPaymentMethodSelector)SOM_Application.Selector.newInstance(SOM_ICardPaymentMethodSelector.class);
            }
            return cardPaymentMethodSelector;
        } 
        
        set;
    }
    
    /**
    * @description The selector of PaymentGatewayLog 
    */
    public static SOM_IPaymentGatewayLogSelector paymentGatewayLog
    {
        get 
        {
            if (paymentGatewayLogSelector == null) {
                paymentGatewayLogSelector = (SOM_IPaymentGatewayLogSelector)SOM_Application.Selector.newInstance(SOM_IPaymentGatewayLogSelector.class);
            }
            return paymentGatewayLogSelector;
        } 
        
        set;
    }
}