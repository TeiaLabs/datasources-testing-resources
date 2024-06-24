/** 
* @description : Purge jobs for old oms data | Batch test class
*/
@isTest
public with sharing class SOM_PurgeOldOmsDataBatchTest {
    private static String orderSummaryId;
    private static String orderId;
    private static String invoiceId;
    private static String returnOrderId;
    private static OrderSummary orderSummary;
    
    /** 
    * @description checks the deletion of fulfillment order
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteFulfillmentOrder() {       
        createObjectsForTest();
        
        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1 ];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrderAfterDeletion = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryId = :orderSummary.Id];
        system.assertEquals(0, fulfillmentOrderAfterDeletion.size(), 'There should be no Fulfillment Orders after deletion');
    }

    /** 
    * @description checks the deletion of order summary
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */ 
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteOrderSummary() {    
        createObjectsForTest();

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<OrderSummary> orderSummaryAfterDeletion = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId];
        system.assertEquals(0, orderSummaryAfterDeletion.size(), 'There should be no Order Summaries after deletion');
    }

    /** 
    * @description checks the deletion of order
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteOrder() {   
        createObjectsForTest();
 
        OrderSummary testOrderSummary = [SELECT OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1 ];
    
        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<Order> orderAfterDeletion = [SELECT OriginalOrderId FROM Order WHERE Id = :testOrderSummary.OriginalOrderId];
        system.assertEquals(0, orderAfterDeletion.size(), 'There should be no Orders after deletion');
    }

    /** 
    * @description checks the deletion of payment gateway log
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeletePaymentGatewayLog() {  
        createObjectsForTest();

        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];
        OrderPaymentSummary orderPaymentSummary = [SELECT Id FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummary.Id LIMIT 1];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<PaymentGatewayLog> paymentGatewayLogAfterDeletion = [SELECT Id FROM PaymentGatewayLog WHERE OrderPaymentSummaryId = :orderPaymentSummary.Id];
        system.assertEquals(0, paymentGatewayLogAfterDeletion.size(), 'There should be no Payment Gateway Log');
    }

    /** 
    * @description checks the deletion of card payment method
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteCardPaymentMethod() {   
        createObjectsForTest();
    
        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];
        OrderPaymentSummary orderPaymentSummary = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummary.Id LIMIT 1];
   
        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<CardPaymentMethod> cardPaymentMethodAfterDeletion = [SELECT Id FROM CardPaymentMethod WHERE Id = :orderPaymentSummary.PaymentMethodId ];
        system.assertEquals(0, cardPaymentMethodAfterDeletion.size(), 'There should be no Card Payment Methods after deletion');
    }

    /** 
    * @description checks the deletion of digital wallet deletion
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteDigitalWallet() {  
        createObjectsForDigitalWallet();

        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];
        OrderPaymentSummary orderPaymentSummary = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummary.Id LIMIT 1];

        List<DigitalWallet> digitalWalletBeforeDeletion = [SELECT Id FROM DigitalWallet WHERE Id = :orderPaymentSummary.PaymentMethodId];
        system.assert(digitalWalletBeforeDeletion.size() > 0, 'There should be at least one Digital Wallet before deletion');

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<DigitalWallet> digitalWalletAfterDeletion = [SELECT Id FROM DigitalWallet WHERE Id = :orderPaymentSummary.PaymentMethodId];
        system.assertEquals(0, digitalWalletAfterDeletion.size(), 'There should be no Digital Wallets after deletion');
    }

    /** 
    * @description checks the deletion of alternative payment method
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteAlternativePaymentMethod() { 
        createObjectsForAlternativePaymentMethod();

        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];
        OrderPaymentSummary orderPaymentSummary = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummary.Id LIMIT 1];

        List<AlternativePaymentMethod> alternativePayment = [SELECT Id FROM AlternativePaymentMethod WHERE Id = :orderPaymentSummary.PaymentMethodId];
        system.assert(alternativePayment.size() > 0, 'There should be at least one AlternativePaymentMethods before deletion');

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<AlternativePaymentMethod> alternativePaymentAfterDeletion = [SELECT Id FROM AlternativePaymentMethod WHERE Id = :orderPaymentSummary.PaymentMethodId];
        system.assertEquals(0, alternativePaymentAfterDeletion.size(), 'There should be no AlternativePaymentMethods after deletion');
    }

    /** 
    * @description checks the deletion of process exception
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteProcessException() {
        createObjectsForTest();
       
        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<ProcessException> processExceptionAfterDeletion = [SELECT AttachedToId FROM ProcessException WHERE AttachedToId = :orderSummary.Id];
        system.assertEquals(0, processExceptionAfterDeletion.size(), 'There should be no Process Exception after deletion');
    }

    /** 
    * @description checks the deletion of shipment
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteShipment() {
        createObjectsForTest();
    
        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<Shipment> shipmentAfterDeletion = [SELECT Id FROM Shipment WHERE OrderSummaryId = :orderSummary.Id];
        system.assertEquals(0, shipmentAfterDeletion.size(), 'There should be no Shipment after deletion');
    }

    /** 
    * @description checks the deletion of payment group
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeletePaymentGroup() {
        createObjectsForTest();

        OrderSummary testOrderSummary = [SELECT OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<PaymentGroup> paymentGroupAfterDeletion = [SELECT Id FROM PaymentGroup WHERE SourceObjectId = :testOrderSummary.OriginalOrderId];
        system.assertEquals(0, paymentGroupAfterDeletion.size(), 'There should be no Payment Group after deletion');
    }

    /** 
    * @description checks the deletion of return order
    *     suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    private static void shouldDeleteReturnOrder() { 
        createObjectsForReturnOrder();

        OrderSummary orderSummary = [SELECT OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId LIMIT 1];

        Test.startTest(); 
        SOM_PurgeOldOmsDataBatch batch = new SOM_PurgeOldOmsDataBatch('TestPurgeBatchConfigId');
        Database.executeBatch(batch, 200);        
        Test.stopTest();

        List<ReturnOrder> returnOrderAfterDeletion = [SELECT Id FROM ReturnOrder WHERE OrderSummaryId = :orderSummary.Id];
        system.assertEquals(0, returnOrderAfterDeletion.size(), 'There should be no Return Order after deletion');
   }

    /**
    * @description  Creates Order, Order Summary, FulfillmentOrder, Invoice, CreditMemo, PaymentGroup, CardPaymentMethod, ProcessException, Shipment, ReturnOrder, Payment Gateway Log
    */
    public static void createObjectsForTest() {       
        orderId = SOM_TestDataFactory.createOrderAction();   
        orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        orderSummary = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId];
        OrderPaymentSummary orderPaymentSummary = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummaryId];
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
        
        invoiceId = SOM_TestDataFactory.createInvoice(fulfillmentOrder.Id);
        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue]; 
       
        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);
        ConnectApi.CreateCreditMemoInputRepresentation input = new ConnectApi.CreateCreditMemoInputRepresentation();
        input.changeOrderIds = new List<String>{ submitReturnOutput.changeOrderId };
        SOM_Services.orderSummary.createCreditMemo(orderSummaryId, input);

        ProcessException processException = new ProcessException(AttachedToId = orderSummaryId, Category = 'Payment', Status = 'New', Message = 'Unable to Apply Payment', Description= 'Unable to capture payment  of $251.61.');    
        insert processException;

        Shipment shipment = new Shipment(OrderSummaryId = orderSummaryId, ShipToName = 'Test Shipment');
        insert shipment;

        PaymentGatewayLog paymentGatewayLog = new PaymentGatewayLog(OrderPaymentSummaryId = orderPaymentSummary.Id);
        insert paymentGatewayLog;
    }
    
    /**
    * @description  Creates ReturnOrder
    */
    public static void createObjectsForReturnOrder() {
        orderId = SOM_TestDataFactory.createOrderAction();
        orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Id
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.ReturnOrderLineItemInputRepresentation returnOrderLineItemInput = new ConnectApi.ReturnOrderLineItemInputRepresentation();
            returnOrderLineItemInput.canReduceShipping = true;
            returnOrderLineItemInput.orderItemSummaryId = orderItemSummary.Id;
            returnOrderLineItemInput.quantityExpected = 1;
            returnOrderLineItemInput.quantityReceived = 0;
            returnOrderLineItemInput.reasonForReturn = SOM_OrderItemSummaryChangeReason.UNKNOWN.enumValue;
            returnOrderLineItemInputList.add(returnOrderLineItemInput);
        }

        ConnectApi.ReturnOrderInputRepresentation returnOrderInput = new ConnectApi.ReturnOrderInputRepresentation();
        returnOrderInput.orderSummaryId = orderSummaryId;
        returnOrderInput.returnOrderLifeCycleType = SOM_LifeCycleType.MANAGED.enumValue;
        returnOrderInput.returnOrderLineItems = returnOrderLineItemInputList;
        returnOrderInput.status = SOM_ReturnOrderStatus.APPROVED.enumValue;
        returnOrderId = SOM_Services.returnOrder.createReturnOrder(returnOrderInput).returnOrderId;
    }

    /**
    * @description  Creates objects with an alternative payment method
    */
    public static void createObjectsForAlternativePaymentMethod() {
        Map<String,String> inputOptions = new Map<String,String>();
        inputOptions.put(SOM_TestDataInputOptions.ALTERNATIVE_PAYMENT, 'Test name');
        orderId = SOM_TestDataFactory.createOrderAction(inputOptions);
        orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
        
        invoiceId = SOM_TestDataFactory.createInvoice(fulfillmentOrder.Id);
        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue]; 
       
        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);
        ConnectApi.CreateCreditMemoInputRepresentation input = new ConnectApi.CreateCreditMemoInputRepresentation();
        input.changeOrderIds = new List<String>{ submitReturnOutput.changeOrderId };
        SOM_Services.orderSummary.createCreditMemo(orderSummaryId, input);
    }

    /**
    * @description  Creates objects with a Digital Wallet
    */
    public static void createObjectsForDigitalWallet() {
        Map<String,String> inputOptions = new Map<String,String>();
        inputOptions.put(SOM_TestDataInputOptions.DIGITAL_WALLET, 'Test name');
        orderId = SOM_TestDataFactory.createOrderAction(inputOptions);
        orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
        
        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        invoiceId = SOM_TestDataFactory.createInvoice(fulfillmentOrder.Id);
        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue]; 
       
        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);
        ConnectApi.CreateCreditMemoInputRepresentation input = new ConnectApi.CreateCreditMemoInputRepresentation();
        input.changeOrderIds = new List<String>{ submitReturnOutput.changeOrderId };
        SOM_Services.orderSummary.createCreditMemo(orderSummaryId, input);    }
}
