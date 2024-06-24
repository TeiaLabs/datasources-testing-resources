/**
* @description OrderSummaryService test class
*/
@isTest
private class SOM_OrderSummaryServiceTest {
    /**
    * @description Test method of OrderSummaryService.createOrderSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateOrderSummary() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId;
        Boolean isSuccess;
        
        // most of the orgs have flow creating order summary
        // automatically. therefore, checking if existing
        // otherwise we will face duplicate order summary issue
        List<OrderSummary> existingOrderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId = :orderId];
        if(existingOrderSummaries.isEmpty()) {
            ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
            input.orderId = orderId;
            
            Test.startTest();
            ConnectApi.OrderSummaryOutputRepresentation output = SOM_Services.orderSummary.createOrderSummary(input);
            Test.stopTest();
            
            isSuccess = output.success;
            orderSummaryId = output.orderSummaryId;
        }
        else {
            orderSummaryId = existingOrderSummaries[0].Id;
            isSuccess = true;
        }

        System.assert(isSuccess, 'Create OrderSummary failed');

        List<OrderSummary> orderSummaryList = [SELECT Id FROM OrderSummary WHERE Id = :orderSummaryId];
        System.assert(!orderSummaryList.isEmpty(), 'No record found');
    }

 /**
    * @description Test method of OrderSummaryService.adjustPreview
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldAdjustPreview() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Double adjustment = -2;

        List<OrderItemSummary> orderItemSummaries = [
            SELECT 
                Quantity, QuantityReturnInitiated, QuantityReturned, 
                QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.AdjustOrderItemSummaryInputRepresentation input = 
            SOM_TestDataFactory.buildAdjustOrderItemSummaryInput(orderItemSummaries, SOM_Constants.GROSS , SOM_OrderItemSummaryChangeReason.UNKNOWN, adjustment);

        Test.startTest();
        ConnectApi.AdjustOrderSummaryOutputRepresentation adjustPreviewOutput = SOM_Services.orderSummary.adjustPreview(orderSummaryId, input);
        Test.stopTest();

        System.assert(adjustPreviewOutput.success, 'Adjust preview failed');

        // total adjustment product amount = total product quantity * adjustment amount
        Double totalAdjustedProductAmount = Math.abs(orderItemSummaries.size() * adjustment);
        System.assert(adjustPreviewOutput.changeBalances.totalAdjustedProductAmount == totalAdjustedProductAmount, 'Adjust amounts are not matching');
    }

    /**
    * @description Test method of OrderSummaryService.adjustSubmitm
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldAdjustSubmit() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Double adjustment = -2;

        List<OrderItemSummary> orderItemSummaries = [
            SELECT 
                Quantity, QuantityReturnInitiated, QuantityReturned, 
                QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.AdjustOrderItemSummaryInputRepresentation input = 
            SOM_TestDataFactory.buildAdjustOrderItemSummaryInput(orderItemSummaries, SOM_Constants.GROSS , SOM_OrderItemSummaryChangeReason.UNKNOWN, adjustment);

        Test.startTest();
        ConnectApi.AdjustOrderSummaryOutputRepresentation adjustSubmitOutput = SOM_Services.orderSummary.adjustSubmit(orderSummaryId, input);
        Test.stopTest();

        System.assert(adjustSubmitOutput.success, 'Adjust submit failed');

        orderItemSummaries = [
            SELECT TotalLineAdjustmentAmount 
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            System.assert(orderItemSummary.TotalLineAdjustmentAmount == adjustment, String.format('Adjustment amount should be {0}', new List<String>{ String.valueOf(adjustment) }));            
        }
    }

    /**
    * @description Test method of OrderSummaryService.createCreditMemo
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateCreditMemo() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
            AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);

        ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);

        ConnectApi.CreateCreditMemoInputRepresentation input = new ConnectApi.CreateCreditMemoInputRepresentation();
        input.changeOrderIds = new List<String>{ submitReturnOutput.changeOrderId };
        
        Test.startTest();
        ConnectApi.CreateCreditMemoOutputRepresentation output = SOM_Services.orderSummary.createCreditMemo(orderSummaryId, input);
        Test.stopTest();

        System.assert(output.success, 'Create CreditMemo action is failed');

        List<CreditMemo> creditMemos = [SELECT Id FROM CreditMemo WHERE Id =: output.creditMemoId];
        System.assert(!creditMemos.isEmpty(), 'No CreditMemo record found');
    }

    /**
    * @description Test method of OrderSummaryService.ensureFundsAsync
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldEnsureFunds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0].Id;

        String invoiceId = SOM_TestDataFactory.createInvoice(fulfillmentOrderId);

        ConnectApi.EnsureFundsAsyncInputRepresentation input = new ConnectApi.EnsureFundsAsyncInputRepresentation();
        input.invoiceId = invoiceId;

        Test.startTest();
        ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsOutput = SOM_Services.orderSummary.ensureFundsAsync(orderSummaryId, input);
        Test.stopTest();

        System.assert(ensureFundsOutput.success, 'Ensure funds action is failed');
    }

    /**
    * @description Test method of OrderSummaryService.ensureRefundsAsync
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldEnsureRefunds() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        // submit return
        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);

        // create CreditMemo
        ConnectApi.CreateCreditMemoInputRepresentation creditMemoInput = new ConnectApi.CreateCreditMemoInputRepresentation();
        creditMemoInput.changeOrderIds = new List<String>{ submitReturnOutput.changeOrderId };
        ConnectApi.CreateCreditMemoOutputRepresentation creditMemoOutput = SOM_Services.orderSummary.createCreditMemo(orderSummaryId, creditMemoInput);

        ConnectApi.EnsureRefundsAsyncInputRepresentation input = new ConnectApi.EnsureRefundsAsyncInputRepresentation();
        input.creditMemoId = creditMemoOutput.creditMemoId;

        Test.startTest();
        ConnectApi.EnsureRefundsAsyncOutputRepresentation output = SOM_Services.orderSummary.ensureRefundsAsync(orderSummaryId, input);
        Test.stopTest();

        System.assert(output.success, 'Ensure refunds action is failed');
    }

    /**
    * @description Test method of OrderSummaryService.previewCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldPreviewCancel() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        
        Test.startTest();
        ConnectApi.PreviewCancelOutputRepresentation output = SOM_Services.orderSummary.previewCancel(orderSummaryId, changeInput);
        Test.stopTest();

        System.assert(output.success, 'Preview cancel action is failed');
    }

    /**
    * @description Test method of OrderSummaryApi.previewReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldPreviewReturn() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        
        Test.startTest();
        ConnectApi.PreviewReturnOutputRepresentation output = SOM_Services.orderSummary.previewReturn(orderSummaryId, changeInput);
        Test.stopTest();

        System.assert(output.success, 'Preview return action is failed');
    }

    /**
    * @description Test method of OrderSummaryService.submitCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSubmitCancel() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        
        Test.startTest();
        ConnectApi.SubmitCancelOutputRepresentation output = SOM_Services.orderSummary.submitCancel(orderSummaryId, changeInput);
        Test.stopTest();

        System.assert(output.success, 'Submit cancel action is failed');

        orderItemSummaries = [
            SELECT Status, QuantityCanceled
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            System.assert(orderItemSummary.Status.equalsIgnoreCase(SOM_OrderItemSummaryStatus.CANCELED.enumValue), 'Status of the Order item is not CANCELED');
            System.assert(orderItemSummary.QuantityCanceled > 0, 'The quantity canceled should greater than zero');
        }
    }

    /**
    * @description Test method of OrderSummaryService.submitReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSubmitReturn() {
        String orderId = SOM_TestDataFactory.createOrderAction();
        String orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;

        Schema.Location location = [SELECT Id FROM Location WHERE Name = :SOM_Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        ConnectApi.ChangeInputRepresentation changeInput = SOM_TestDataFactory.buildChangeInput(orderItemSummaries, SOM_OrderItemSummaryChangeReason.UNKNOWN, true);
        
        Test.startTest();
        ConnectApi.SubmitReturnOutputRepresentation output = SOM_Services.orderSummary.submitReturn(orderSummaryId, changeInput);
        Test.stopTest();

        System.assert(output.success, 'Submit return action is failed');

        orderItemSummaries = [
            SELECT Status, QuantityReturned
            FROM OrderItemSummary 
            WHERE OrderSummaryId = :orderSummaryId
                AND Type = :SOM_OrderItemType.ORDER_PRODUCT.enumValue];

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            System.assert(orderItemSummary.Status.equalsIgnoreCase(SOM_OrderItemSummaryStatus.RETURNED.enumValue), 'Status of the Order item is not RETURNED');
            System.assert(orderItemSummary.QuantityReturned > 0, 'The quantity returned should greater than zero');
        }
    }
}