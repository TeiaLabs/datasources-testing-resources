/**
* @description Enum test class
*/
@isTest
private class SOM_BaseEnumTest {
    /**
    * @description Test method of BaseEnum 
    *   and classes those extend
    *   suppress reason: ignore
    */
    @isTest
    @suppressWarnings('PMD.NcssMethodCount')
    static void shouldInitiateEnums() {
        List<SOM_CardPaymentMethodCategory> cardPaymentMethodCategoryList = SOM_CardPaymentMethodCategory.values();
        List<SOM_CardPaymentMethodStatus> cardPaymentMethodStatusList = SOM_CardPaymentMethodStatus.values();
        List<SOM_CardPaymentMethodType> cardPaymentMethodTypeList = SOM_CardPaymentMethodType.values();
        List<SOM_FulfillmentOrderStatus> fulfillmentOrderStatusList = SOM_FulfillmentOrderStatus.values();
        List<SOM_FulfillmentOrderType> fulfillmentOrderTypeList = SOM_FulfillmentOrderType.values();
        List<SOM_InvoiceStatus> invoiceStatusList = SOM_InvoiceStatus.values();
        List<SOM_LifeCycleType> lifeCycleTypeList = SOM_LifeCycleType.values();
        List<SOM_LocationType> locationTypeList = SOM_LocationType.values();
        List<SOM_OrderItemSummaryChangeReason> orderItemSummaryChangeList = SOM_OrderItemSummaryChangeReason.values();
        List<SOM_OrderItemSummaryStatus> orderItemSummaryStatusList = SOM_OrderItemSummaryStatus.values();
        List<SOM_OrderItemType> orderItemTypeList = SOM_OrderItemType.values();
        List<SOM_OrderStatus> orderStatusList = SOM_OrderStatus.values();
        List<SOM_OrderSummaryStatus> orderSummaryStatusList = SOM_OrderSummaryStatus.values();
        List<SOM_PaymentAuthorizationStatus> paymentAuthorizationStatusList = SOM_PaymentAuthorizationStatus.values();
        List<SOM_PaymentStatus> paymentStatusList = SOM_PaymentStatus.values();
        List<SOM_PaymentType> paymentTypeList = SOM_PaymentType.values();
        List<SOM_ProcessExceptionStatus> processExceptionStatusList = SOM_ProcessExceptionStatus.values();
        List<SOM_ProcessExceptionType> processExceptionTypeList = SOM_ProcessExceptionType.values();
        List<SOM_ProcessingMode> processingModeList = SOM_ProcessingMode.values();
        List<SOM_ReturnOrderLineItemRejectionReason> returnOrderLineItemRejectionReasonList = SOM_ReturnOrderLineItemRejectionReason.values();
        List<SOM_ReturnOrderLineItemReturnReason> returnOrderLineItemReturnReasonList = SOM_ReturnOrderLineItemReturnReason.values();
        List<SOM_ReturnOrderStatus> returnOrderStatusList = SOM_ReturnOrderStatus.values();
        List<SOM_ShipmentStatus> shipmentStatusList = SOM_ShipmentStatus.values();
        List<SOM_DigitalWalletStatus> digitalWalletStatusList = SOM_DigitalWalletStatus.values();
        List<SOM_AlternativePaymentMethodStatus> alternativePaymentMethodStatusList = SOM_AlternativePaymentMethodStatus.values();

        System.assert(!cardPaymentMethodCategoryList.isEmpty(), 'CardPaymentMethodCategory list is empty');
        System.assert(!cardPaymentMethodStatusList.isEmpty(), 'CardPaymentMethodStatus list is empty');
        System.assert(!cardPaymentMethodTypeList.isEmpty(), 'CardPaymentMethodType list is empty');
        System.assert(!fulfillmentOrderStatusList.isEmpty(), 'FulfillmentOrderStatus list is empty');
        System.assert(!fulfillmentOrderTypeList.isEmpty(), 'FulfillmentOrderType list is empty');
        System.assert(!invoiceStatusList.isEmpty(), 'InvoiceStatus list is empty');
        System.assert(!orderItemSummaryChangeList.isEmpty(), 'OrderItemSummaryChangeReason list is empty');
        System.assert(!orderItemSummaryStatusList.isEmpty(), 'OrderItemSummaryStatus list is empty');
        System.assert(!orderItemTypeList.isEmpty(), 'OrderItemType list is empty');
        System.assert(!orderStatusList.isEmpty(), 'OrderStatus list is empty');
        System.assert(!orderSummaryStatusList.isEmpty(), 'OrderSummaryStatus list is empty');
        System.assert(!paymentAuthorizationStatusList.isEmpty(), 'PaymentAuthorizationStatus list is empty');
        System.assert(!paymentStatusList.isEmpty(), 'PaymentStatus list is empty');
        System.assert(!paymentTypeList.isEmpty(), 'PaymentType list is empty');
        System.assert(!processExceptionStatusList.isEmpty(), 'ProcessExceptionStatus list is empty');
        System.assert(!processExceptionTypeList.isEmpty(), 'ProcessExceptionType list is empty');
        System.assert(!processingModeList.isEmpty(), 'ProcessingMode list is empty');
        System.assert(!returnOrderLineItemRejectionReasonList.isEmpty(), 'ReturnOrderLineItemRejectionReason list is empty');
        System.assert(!returnOrderLineItemReturnReasonList.isEmpty(), 'ReturnOrderLineItemReturnReason list is empty');
        System.assert(!returnOrderStatusList.isEmpty(), 'ReturnOrderStatus list is empty');
        System.assert(!shipmentStatusList.isEmpty(), 'ShipmentStatus list is empty');
        System.assert(!lifeCycleTypeList.isEmpty(), 'LifeCycleType list is empty');
        System.assert(!locationTypeList.isEmpty(), 'LocationType list is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].enumKey), 'Enum key is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].enumValue), 'Enum value is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].toString()), 'Enum ToString method output is empty');

        System.assert(!digitalWalletStatusList.isEmpty(), 'DigitalWalletStatus list is empty');
        System.assert(!alternativePaymentMethodStatusList.isEmpty(), 'AlternativePaymentMethodStatus list is empty');

    }
}