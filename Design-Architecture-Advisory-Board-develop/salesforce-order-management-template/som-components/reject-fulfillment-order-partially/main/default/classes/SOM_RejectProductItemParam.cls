/**
* @description class to be used in the 'Reject Fulfillment Order Partially' flow as input and output for the LWC somRejectFulfillmentOrderProductSelector
*/
public with sharing class SOM_RejectProductItemParam {
    @AuraEnabled
    public String fulfillmentNumber;

    @AuraEnabled
    public String productId;

    @AuraEnabled
    public String productName;
 
    @AuraEnabled
    public String orderItemSummaryId;
 
    @AuraEnabled
    public String fulfillmentItemId;
 
    @AuraEnabled
    public String description;
 
    @AuraEnabled
    public Integer quantity;
 
    @AuraEnabled
    public Integer originalQuantity;
 
    @AuraEnabled
    public String reason;
 
    @AuraEnabled
    public Decimal unitPrice;
 
    @AuraEnabled
    public Decimal totalWithTax;
 }