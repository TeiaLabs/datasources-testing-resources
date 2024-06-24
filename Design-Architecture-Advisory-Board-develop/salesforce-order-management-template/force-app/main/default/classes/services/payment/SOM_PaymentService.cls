/**
* @description Payment service class
*/
public with sharing class SOM_PaymentService implements SOM_IPaymentService {
    /**
    * @description Create an OrderPaymentSummary
    *   for an OrderSummary. Specify a payment
    *   authorization or payments that share the
    *   same payment method
    * @param input An OrderSummary for which to create an
    *   OrderPaymentSummary, with the payment authorization or payments
    *   to include in it
    * @return Id of the created Order Payment Summary
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_OrderPaymentSummary_static_methods.htm#apex_ConnectAPI_OrderPaymentSummary_createOrderPaymentSummary_1
    */
    public ConnectApi.CreateOrderPaymentSummaryOutputRepresentation createOrderPaymentSummary(ConnectApi.CreateOrderPaymentSummaryInputRepresentation input) {
        return ConnectAPI.OrderPaymentSummary.createOrderPaymentSummary(input);
    }
}