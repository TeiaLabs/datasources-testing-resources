/**
 * @description Test data factory class
 */
@isTest
@suppressWarnings('PMD.ExcessivePublicCount, PMD.CyclomaticComplexity, PMD.StdCyclomaticComplexity, PMD.CognitiveComplexity')
public class SOM_TestDataFactory {
    /**
     * @description Creates Contact object
     * @param input Contact input
     * @return Contact
     */
    public static Contact createContact(SOM_TestDataInput.ContactInput input) {
        Contact contact = new Contact();
        contact.LastName = input.lastName;
        return contact;
    }

    /**
     * @description Creates product
     * @param input Product input
     * @return Product2
     */
    public static Product2 createProduct(SOM_TestDataInput.ProductInput input) {
        Product2 product = new Product2();
        product.Name = input.name;
        product.ProductCode = input.productCode;
        return product;
    }

    /**
     * @description Creates pricebook entry
     * @param input PricebookEntry input
     * @return PricebookEntry
     */
    public static PricebookEntry createPricebookEntry(SOM_TestDataInput.PricebookEntryInput input) {
        PricebookEntry priceBookEntry = new PriceBookEntry();
        priceBookEntry.UnitPrice = input.unitPrice;
        priceBookEntry.Pricebook2Id = input.pricebook2Id;
        priceBookEntry.Product2Id = input.product2Id;
        return priceBookEntry;
    }

    /**
     * @description Creates account
     * @param input Account input
     * @return Account
     */
    public static Account createAccount(SOM_TestDataInput.AccountInput input) {
        Account account = new Account();
        account.FirstName = input.firstName;
        account.LastName = input.lastName;
        account.PersonEmail = input.email;
        account.RecordTypeId = input.recordTypeId;
        return account;
    }

    /**
     * @description Creates SalesChannel
     * @param input SalesChannel input
     * @return SalesChannel
     */
    public static SalesChannel createSalesChannel(SOM_TestDataInput.SalesChannelInput input) {
        SalesChannel salesChannel = new SalesChannel();
        salesChannel.SalesChannelName = input.name;
        return saleschannel;
    }

    /**
     * @description Creates order
     * @param input Order input
     * @return Order
     */
    public static Order createOrder(SOM_TestDataInput.OrderInput input) {
        Order order = new Order();
        order.AccountId = input.accountId;
        order.Pricebook2Id = input.pricebook2Id;
        order.EffectiveDate = input.effectiveDate;
        order.Status = input.status;
        order.SalesChannelId = input.salesChannelId;
        return order;
    }

    /**
     * @description Creates order delivery method
     * @param input OrderDeliveryMethod input
     * @return OrderDeliveryMethod
     */
    public static OrderDeliveryMethod createOrderDeliveryMethod(SOM_TestDataInput.OrderDeliveryMethodInput input) {
        OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod();
        orderDeliveryMethod.Name = input.name;
        orderDeliveryMethod.ReferenceNumber = input.referenceNumber;
        return orderDeliveryMethod;
    }

    /**
     * @description Creates order
     * @param input OrderDeliveryGroup input
     * @return OrderDeliveryGroup
     */
    public static OrderDeliveryGroup createOrderDeliveryGroup(SOM_TestDataInput.OrderDeliveryGroupInput input) {
        OrderDeliveryGroup orderDeliveryGroup = new OrderDeliveryGroup();
        orderDeliveryGroup.OrderId = input.orderId;
        orderDeliveryGroup.OrderDeliveryMethodId = input.orderDeliveryMethodId;
        orderDeliveryGroup.DeliverToName = input.deliverToName;
        orderDeliveryGroup.DeliverToCountry = input.deliverToCountry;
        orderDeliveryGroup.DeliverToCity = input.deliverToCity;
        orderDeliveryGroup.DeliverToPostalCode = input.deliverToPostalCode;
        orderDeliveryGroup.DeliverToStreet = input.deliverToStreet;
        return orderDeliveryGroup;
    }

    /**
     * @description Creates order
     * @param input OrderItem input
     * @return OrderDeliveryGroup
     */
    public static OrderItem createOrderItem(SOM_TestDataInput.OrderItemInput input) {
        OrderItem item = new OrderItem();
        item.OrderId = input.orderId;
        item.Product2Id = input.product2Id;
        item.PricebookentryId = input.pricebookEntryId;
        item.UnitPrice = input.unitPrice;
        item.Quantity = input.quantity;
        item.Type = input.type;
        item.OrderDeliveryGroupId = input.orderDeliveryGroupId;
        item.TotalLineAmount = input.totalLineAmount;
        return item;
    }

    /**
     * @description Creates location
     * @param input Location input
     * @return Location
     */
    public static Schema.Location createLocation(SOM_TestDataInput.LocationInput input) {
        Schema.Location location = new Schema.Location();
        location.Name = input.name;
        location.ExternalReference = input.externalReference;
        location.LocationType = input.locationType;
        return location;
    }

    /**
     * @description Creates order item tax
     * @param input OrderItemTaxLineItem input
     * @return OrderItemTaxLineItem
     */
    public static OrderItemTaxLineItem createOrderItemTaxLineItem(SOM_TestDataInput.OrderItemTaxLineItemInput input) {
        OrderItemTaxLineItem itemTax = new OrderItemTaxLineItem();
        itemTax.Name = input.name;
        itemTax.OrderItemId = input.orderItemId;
        itemTax.Type = input.type;
        itemTax.Amount = input.amount;
        itemTax.Rate = input.rate;
        itemTax.TaxEffectiveDate = input.taxEffectiveDate;
        return itemTax;
    }

    /**
     * @description Creates order item adjustment
     * @param input OrderItemAdjustmentLineItem input
     * @return OrderItemAdjustmentLineItem
     */
    public static OrderItemAdjustmentLineItem createOrderItemAdjustmentLineItem(
        SOM_TestDataInput.OrderItemAdjustmentLineItemInput input
    ) {
        OrderItemAdjustmentLineItem itemAdjustment = new OrderItemAdjustmentLineItem();
        itemAdjustment.Name = input.name;
        itemAdjustment.OrderItemId = input.orderItemId;
        itemAdjustment.Amount = input.amount;
        return itemAdjustment;
    }

    /**
     * @description Creates payment group
     * @param input PaymentGroup input
     * @return PaymentGroup
     */
    public static PaymentGroup createPaymentGroup(SOM_TestDataInput.PaymentGroupInput input) {
        PaymentGroup paymentGroup = new PaymentGroup();
        paymentGroup.SourceObjectId = input.sourceObjectId;
        return paymentGroup;
    }

    /**
     * @description Creates PaymentGateway
     * @param input PaymentGateway input
     * @return PaymentGateway
     */
    public static PaymentGateway createPaymentGateway(SOM_TestDataInput.PaymentGatewayInput input) {
        PaymentGateway paymentGateway = new PaymentGateway();
        paymentGateway.PaymentGatewayName = input.paymentGatewayName;
        paymentGateway.ExternalReference = input.externalReference;
        paymentGateway.MerchantCredentialId = input.merchantCredentialId;
        paymentGateway.PaymentGatewayProviderId = input.paymentGatewayProviderId;
        paymentGateway.Status = input.status;
        return paymentGateway;
    }

    /**
     * @description Creates payment group
     * @param sourceObjectId Id of object
     * @return PaymentGroup
     */
    public static PaymentGroup createPaymentGroup(String sourceObjectId) {
        PaymentGroup paymentGroup = new PaymentGroup();
        paymentGroup.SourceObjectId = sourceObjectId;
        return paymentGroup;
    }

    /**
     * @description Creates payment authorization
     * @param input PaymentAuthorization input
     * @return PaymentAuthorization
     */
    public static PaymentAuthorization createPaymentAuthorization(SOM_TestDataInput.PaymentAuthorizationInput input) {
        PaymentAuthorization paymentAuthorization = new PaymentAuthorization();
        paymentAuthorization.Amount = input.amount;
        paymentAuthorization.Status = input.status;
        paymentAuthorization.ProcessingMode = input.processingMode;
        paymentAuthorization.PaymentMethodId = input.paymentMethodId;
        paymentAuthorization.PaymentGroupId = input.paymentGroupId;
        paymentAuthorization.paymentGatewayId = input.paymentGatewayId;

        return paymentAuthorization;
    }

    /**
     * @description Creates CardPaymentMethod
     * @param input CardPaymentMethod input
     * @return CardPaymentMethod
     */
    public static CardPaymentMethod createCardPaymentMethod(SOM_TestDataInput.CardPaymentMethodInput input) {
        CardPaymentMethod paymentMethod = new CardPaymentMethod();
        paymentMethod.CardType = input.cardType;
        paymentMethod.CardHolderName = input.cardHolderName;
        paymentMethod.ExpiryYear = input.expiryYear;
        paymentMethod.ExpiryMonth = input.expiryMonth;
        paymentMethod.CardCategory = input.cardCategory;
        paymentMethod.Status = input.status;
        paymentMethod.AccountId = input.accountId;
        paymentMethod.ProcessingMode = input.processingMode;
        paymentMethod.paymentGatewayId = input.paymentGatewayId;

        return paymentMethod;
    }

    /**
     * @description Creates AlternativePaymentMethod
     * @param input AlternativePaymentMethodInput
     * @return AlternativePaymentMethod
     */
    public static AlternativePaymentMethod createAlternativePaymentMethod(
        SOM_TestDataInput.AlternativePaymentMethodInput input
    ) {
        AlternativePaymentMethod paymentMethod = new AlternativePaymentMethod();
        paymentMethod.NickName = input.nickName;
        paymentMethod.PaymentMethodCity = input.paymentMethodCity;
        paymentMethod.PaymentMethodCountry = input.paymentMethodCountry;
        paymentMethod.PaymentMethodPostalCode = input.paymentMethodPostalCode;
        paymentMethod.PaymentMethodState = input.paymentMethodState;
        paymentMethod.PaymentMethodStreet = input.paymentMethodStreet;

        paymentMethod.Status = input.status;
        paymentMethod.AccountId = input.accountId;
        paymentMethod.ProcessingMode = input.processingMode;
        paymentMethod.PaymentGatewayId = input.paymentGatewayId;

        return paymentMethod;
    }

    /**
     * @description Creates DigitalWallet
     * @param input DigitalWalletInput
     * @return DigitalWallet
     */
    public static DigitalWallet createDigitalWalletPaymentMethod(
        SOM_TestDataInput.DigitalWalletInput input
    ) {
        DigitalWallet paymentMethod = new DigitalWallet();
        paymentMethod.Customer = input.customerName;
        paymentMethod.Comments = input.comments;
        paymentMethod.PaymentMethodCity = input.paymentMethodCity;
        paymentMethod.PaymentMethodCountry = input.paymentMethodCountry;
        paymentMethod.PaymentMethodPostalCode = input.paymentMethodPostalCode;
        paymentMethod.PaymentMethodState = input.paymentMethodState;
        paymentMethod.PaymentMethodStreet = input.paymentMethodStreet;

        paymentMethod.Type = input.type;
        paymentMethod.Status = input.status;
        paymentMethod.AccountId = input.accountId;
        paymentMethod.ProcessingMode = input.processingMode;
        paymentMethod.PaymentGatewayId = input.paymentGatewayId;

        return paymentMethod;
    }

    /**
     * @description Creates Payment
     * @param input Payment input
     * @return Payment
     */
    public static Payment createPayment(SOM_TestDataInput.PaymentInput input) {
        Payment payment = new Payment();
        payment.Amount = input.amount;
        payment.Status = input.status;
        payment.ProcessingMode = input.processingMode;
        payment.Type = input.type;
        payment.paymentGatewayId = input.paymentGatewayId;
        return payment;
    }

    /**
     * @description Creates order and related objects
     *   suppress reason: TODO REFACTOR REFACTOR
     * @param createOrderActionInput CreateOrderAction input
     * @return Order
     */
    @suppressWarnings('PMD.NcssMethodCount, PMD.CognitiveComplexity, PMD.StdCyclomaticComplexity')
    public static Order createAndInsertOrder(SOM_TestDataInput.CreateOrderActionInput createOrderActionInput) {
        // Location creation
        Schema.Location location = createLocation(createOrderActionInput.location);
        insert location;

        // PaymentGateway creation
        PaymentGateway paymentGateway;
        if (createOrderActionInput.paymentGateway != null) {
            paymentGateway = createPaymentGateway(createOrderActionInput.paymentGateway);
            insert paymentGateway;
        }

        // Account creation
        Account account = createAccount(createOrderActionInput.account);
        insert account;

        // SalesChannel creation
        SalesChannel saleschannel = createSalesChannel(createOrderActionInput.salesChannel);
        insert saleschannel;

        // Order creation
        createOrderActionInput.order.accountId = account.Id;
        createOrderActionInput.order.salesChannelId = saleschannel.Id;
        Order order = createOrder(createOrderActionInput.order);
        insert order;

        // OrderDeliveryMethod
        OrderDeliveryMethod orderDeliveryMethod = createOrderDeliveryMethod(createOrderActionInput.orderDeliveryMethod);
        insert orderDeliveryMethod;

        // OrderDeliveryGroup
        createOrderActionInput.orderDeliveryGroup.orderId = order.Id;
        createOrderActionInput.orderDeliveryGroup.orderDeliveryMethodId = orderDeliveryMethod.Id;
        OrderDeliveryGroup orderDeliveryGroup = createOrderDeliveryGroup(createOrderActionInput.orderDeliveryGroup);
        insert orderDeliveryGroup;

        // Product creation
        // Map will be used in OrderItem and
        // PricebookEntry creation for getting the Id
        Map<String, Product2> mapProductCodeToProduct = new Map<String, Product2>();
        for (SOM_TestDataInput.OrderItemInput orderItemInput : createOrderActionInput.orderItems) {
            Product2 product = createProduct(orderItemInput.product);
            mapProductCodeToProduct.put(orderItemInput.product.productCode, product);
        }
        insert mapProductCodeToProduct.values();

        // PricebookEntry creation
        // Map will be used in OrderItem
        // for getting the Id
        Map<String, PricebookEntry> mapProductCodeToPricebookEntry = new Map<String, PricebookEntry>();
        for (SOM_TestDataInput.OrderItemInput orderItemInput : createOrderActionInput.orderItems) {
            String productCode = orderItemInput.product.productCode;
            // getting the required Ids
            // from previous steps
            Product2 product = mapProductCodeToProduct.get(orderItemInput.product.productCode);

            SOM_TestDataInput.PricebookEntryInput pricebookEntryInput = new SOM_TestDataInput.PricebookEntryInput();
            pricebookEntryInput.unitPrice = orderItemInput.unitPrice;
            pricebookEntryInput.product2Id = product.Id;
            PricebookEntry pricebookEntry = createPricebookEntry(pricebookEntryInput);
            mapProductCodeToPricebookEntry.put(orderItemInput.product.productCode, pricebookEntry);
        }
        insert mapProductCodeToPricebookEntry.values();

        // OrderItem creation
        Double paymentAuthorizationAmount = 0;
        Map<String, OrderItem> mapProductCodeToOrderItem = new Map<String, OrderItem>();
        List<OrderItem> orderItems = new List<OrderItem>();
        for (SOM_TestDataInput.OrderItemInput orderItemInput : createOrderActionInput.orderItems) {
            String productCode = orderItemInput.product.productCode;
            // getting the required Ids
            // from previous steps
            Product2 product = mapProductCodeToProduct.get(productCode);
            PricebookEntry pricebookEntry = mapProductCodeToPricebookEntry.get(productCode);

            orderItemInput.orderId = order.Id;
            orderItemInput.product2Id = product.Id;
            orderItemInput.pricebookEntryId = pricebookEntry.Id;
            orderItemInput.orderDeliveryGroupId = orderDeliveryGroup.Id;
            OrderItem orderItem = createOrderItem(orderItemInput);
            mapProductCodeToOrderItem.put(productCode, orderItem);

            paymentAuthorizationAmount += orderItemInput.totalLineAmount;
        }
        insert mapProductCodeToOrderItem.values();

        // OrderItemTax and OrderItemAdjustment creation
        List<OrderItemTaxLineItem> orderItemTaxList = new List<OrderItemTaxLineItem>();
        List<OrderItemAdjustmentLineItem> orderItemAdjustmentList = new List<OrderItemAdjustmentLineItem>();
        for (SOM_TestDataInput.OrderItemInput orderItemInput : createOrderActionInput.orderItems) {
            OrderItem orderItem = mapProductCodeToOrderItem.get(orderItemInput.product.productCode);

            if (orderItemInput.orderItemTaxLineItems != null) {
                for (
                    SOM_TestDataInput.OrderItemTaxLineItemInput orderItemTaxInput : orderItemInput.orderItemTaxLineItems
                ) {
                    orderItemTaxInput.orderItemId = orderItem.Id;
                    OrderItemTaxLineItem orderItemTax = createOrderItemTaxLineItem(orderItemTaxInput);
                    orderItemTaxList.add(orderItemTax);
                }
            }

            if (orderItemInput.orderItemAdjustmentLineItems != null) {
                for (
                    SOM_TestDataInput.OrderItemAdjustmentLineItemInput orderItemAdjustmentInput : orderItemInput.orderItemAdjustmentLineItems
                ) {
                    orderItemAdjustmentInput.orderItemId = orderItem.Id;
                    OrderItemAdjustmentLineItem orderItemAdjustment = createOrderItemAdjustmentLineItem(
                        orderItemAdjustmentInput
                    );
                    orderItemAdjustmentList.add(orderItemAdjustment);
                }
            }
        }
        insert orderItemTaxList;
        insert orderItemAdjustmentList;

        // PaymentMethod creation. By default it created a CardPaymentMethod. Supports AlternativePaymentMethod and DigitalWallet
        Id paymentMethodId;
        if (createOrderActionInput.cardPaymentMethod != null) {
            if (paymentGateway != null) {
                createOrderActionInput.cardPaymentMethod.paymentGatewayId = paymentGateway.Id;
            }
            createOrderActionInput.cardPaymentMethod.accountId = account.Id;
            CardPaymentMethod paymentMethod = createCardPaymentMethod(createOrderActionInput.cardPaymentMethod);
            insert paymentMethod;
            paymentMethodId = paymentMethod.Id;
        }
        if (createOrderActionInput.alternativePaymentMethod != null) {
            if (paymentGateway != null) {
                createOrderActionInput.alternativePaymentMethod.paymentGatewayId = paymentGateway.Id;
            }
            createOrderActionInput.alternativePaymentMethod.accountId = account.Id;
            AlternativePaymentMethod paymentMethod = createAlternativePaymentMethod(
                createOrderActionInput.alternativePaymentMethod
            );
            insert paymentMethod;
            paymentMethodId = paymentMethod.Id;
        }
        if (createOrderActionInput.digitalWallet != null) {
            if (paymentGateway != null) {
                createOrderActionInput.digitalWallet.paymentGatewayId = paymentGateway.Id;
            }
            createOrderActionInput.digitalWallet.accountId = account.Id;
            DigitalWallet paymentMethod = createDigitalWalletPaymentMethod(
                createOrderActionInput.digitalWallet
            );
            insert paymentMethod;
            paymentMethodId = paymentMethod.Id;
        }

        // PaymentGroup creation
        createOrderActionInput.paymentGroup.sourceObjectId = order.Id;
        PaymentGroup paymentGroup = createPaymentGroup(createOrderActionInput.paymentGroup);
        insert paymentGroup;

        // PaymentAuthorization creation
        createOrderActionInput.paymentAuthorization.amount = paymentAuthorizationAmount;
        createOrderActionInput.paymentAuthorization.paymentGroupId = paymentGroup.Id;
        createOrderActionInput.paymentAuthorization.paymentMethodId = paymentMethodId;
        if (paymentGateway != null) {
            createOrderActionInput.paymentAuthorization.paymentGatewayId = paymentGateway.Id;
        }
        PaymentAuthorization paymentAuthorization = createPaymentAuthorization(
            createOrderActionInput.paymentAuthorization
        );
        insert paymentAuthorization;

        order.Status = SOM_OrderStatus.ACTIVATED.enumValue;
        update order;

        return order;
    }

    /**
     * @description Creates Order for test methods
     *   Test class containing a test setup method cannot
     *   have any methods annotated with "SeeAllData=true"
     * @return Id of the Order
     */
    public static String createOrderAction() {
        Map<String, String> inputOptions = new Map<String, String>();
        return createOrderAction(inputOptions);
    }

    /**
     * @description Creates Order for test methods
     *   Test class containing a test setup method cannot
     *   have any methods annotated with "SeeAllData=true"
     * @param inputOptions - Map of input options
     *   - AlternativePaymentMethod - NickName field of the alternative payment method
     *   - DigitalWallet - Type field of the digital wallet to be created (amazon, apple, google, ...)
     *   - PaymentGateway - Creating PaymentGateway is optional. Set CreatePaymentGateway true
     *  If nothing is specified in the param it creates a CardPaymentMethod
     * @return Id of the Order
     */
    public static String createOrderAction(Map<String, String> inputOptions) {
        if (inputOptions == null) {
            inputOptions = new Map<String, String>();
        }
        Boolean hasAlternativePaymentMethod = inputOptions.containsKey(SOM_TestDataInputOptions.ALTERNATIVE_PAYMENT);
        Boolean hasDigitalWallet = inputOptions.containsKey(SOM_TestDataInputOptions.DIGITAL_WALLET);

        SOM_TestDataInput.CreateOrderActionInput createOrderActionInput = new SOM_TestDataInput.CreateOrderActionInput();
        createOrderActionInput.paymentGroup = new SOM_TestDataInput.PaymentGroupInput();

        createOrderActionInput.account = new SOM_TestDataInput.AccountInput();
        createOrderActionInput.account.firstName = SOM_Constants.TEST;
        createOrderActionInput.account.lastName = SOM_Constants.TEST;
        createOrderActionInput.account.recordTypeId = [
            SELECT Id
            FROM RecordType
            WHERE IsPersonType = TRUE AND IsActive = TRUE AND SObjectType = :String.valueOf(Account.SObjectType)
            LIMIT 1
        ]
        .Id;
        createOrderActionInput.account.email = String.format(
            '{0}@{1}.com',
            new List<String>{ SOM_StringUtil.generateUUID(), SOM_Constants.TEST }
        );

        createOrderActionInput.order = new SOM_TestDataInput.OrderInput();
        createOrderActionInput.order.status = SOM_OrderStatus.DRAFT.enumValue;
        createOrderActionInput.order.effectiveDate = Date.today();

        createOrderActionInput.salesChannel = new SOM_TestDataInput.SalesChannelInput();
        createOrderActionInput.salesChannel.name = SOM_Constants.TEST;

        createOrderActionInput.orderDeliveryGroup = new SOM_TestDataInput.OrderDeliveryGroupInput();
        createOrderActionInput.orderDeliveryGroup.deliverToCity = SOM_Constants.TEST;
        createOrderActionInput.orderDeliveryGroup.deliverToCountry = SOM_Constants.TEST;
        createOrderActionInput.orderDeliveryGroup.deliverToName = SOM_Constants.TEST;
        createOrderActionInput.orderDeliveryGroup.deliverToPostalCode = SOM_Constants.TEST;
        createOrderActionInput.orderDeliveryGroup.deliverToStreet = SOM_Constants.TEST;

        createOrderActionInput.orderDeliveryMethod = new SOM_TestDataInput.OrderDeliveryMethodInput();
        createOrderActionInput.orderDeliveryMethod.name = SOM_Constants.TEST;
        createOrderActionInput.orderDeliveryMethod.referenceNumber = SOM_Constants.TEST;

        createOrderActionInput.location = new SOM_TestDataInput.LocationInput();
        createOrderActionInput.location.name = SOM_Constants.WAREHOUSE;
        createOrderActionInput.location.externalReference = SOM_Constants.TEST;
        createOrderActionInput.location.locationType = SOM_LocationType.WAREHOUSE.enumValue;

        Boolean createPaymentGateway = inputOptions.get(SOM_TestDataInputOptions.CREATE_PAYMENT_GATEWAY) == null 
            ? false 
            : Boolean.valueOf(inputOptions.get(SOM_TestDataInputOptions.CREATE_PAYMENT_GATEWAY));

        if (createPaymentGateway) {
            // payment gateway creation depends on the items provided in the solution
            List<NamedCredential> namedCredentials = [
                SELECT Id
                FROM NamedCredential
                WHERE DeveloperName = 'SOM_TestNamedCredential'
            ];

            List<PaymentGatewayProvider> paymentGatewayProviders = [
                SELECT Id
                FROM PaymentGatewayProvider
                WHERE DeveloperName = 'SOM_TestPaymentGatewayProvider'
            ];

            List<PaymentGateway> paymentGateway = [
                SELECT Id
                FROM PaymentGateway
                WHERE ExternalReference = 'TestPaymentGateway'
            ];

            if (!namedCredentials.isEmpty() && !paymentGatewayProviders.isEmpty() && paymentGateway.isEmpty()) {
                createOrderActionInput.paymentGateway = new SOM_TestDataInput.PaymentGatewayInput();
                createOrderActionInput.paymentGateway.paymentGatewayName = SOM_StringUtil.generateUUID();
                createOrderActionInput.paymentGateway.externalReference = 'TestPaymentGateway';
                createOrderActionInput.paymentGateway.merchantCredentialId = namedCredentials[0].Id;
                createOrderActionInput.paymentGateway.paymentGatewayProviderId = paymentGatewayProviders[0].Id;
            }
        }

        createOrderActionInput.payment = new SOM_TestDataInput.PaymentInput();
        createOrderActionInput.payment.status = SOM_PaymentStatus.PROCESSED.enumValue;
        createOrderActionInput.payment.type = SOM_PaymentType.CAPTURE.enumValue;

        createOrderActionInput.paymentAuthorization = new SOM_TestDataInput.PaymentAuthorizationInput();
        createOrderActionInput.paymentAuthorization.status = SOM_PaymentAuthorizationStatus.PROCESSED.enumValue;

        // Find a way to differentiate between payment methods
        if (!hasAlternativePaymentMethod && !hasDigitalWallet) {
            createOrderActionInput.cardPaymentMethod = new SOM_TestDataInput.CardPaymentMethodInput();
            createOrderActionInput.cardPaymentMethod.cardType = SOM_CardPaymentMethodType.VISA.enumValue;
            createOrderActionInput.cardPaymentMethod.cardCategory = SOM_CardPaymentMethodCategory.CREDIT_CARD.enumValue;
            createOrderActionInput.cardPaymentMethod.cardHolderName = String.format(
                '{0} {0}',
                new List<String>{ SOM_Constants.TEST }
            );
            createOrderActionInput.cardPaymentMethod.expiryMonth = 1;
            createOrderActionInput.cardPaymentMethod.expiryYear = System.today().year() + 1;
            createOrderActionInput.cardPaymentMethod.status = SOM_CardPaymentMethodStatus.ACTIVE.enumValue;
        } else if (hasAlternativePaymentMethod) {
            createOrderActionInput.alternativePaymentMethod = new SOM_TestDataInput.AlternativePaymentMethodInput();
            createOrderActionInput.alternativePaymentMethod.nickName = inputOptions.get(
                SOM_TestDataInputOptions.ALTERNATIVE_PAYMENT
            );
            createOrderActionInput.alternativePaymentMethod.paymentMethodCity = SOM_Constants.TEST;
            createOrderActionInput.alternativePaymentMethod.paymentMethodCountry = SOM_Constants.TEST;
            createOrderActionInput.alternativePaymentMethod.paymentMethodPostalCode = SOM_Constants.TEST;
            createOrderActionInput.alternativePaymentMethod.paymentMethodState = SOM_Constants.TEST;
            createOrderActionInput.alternativePaymentMethod.paymentMethodStreet = SOM_Constants.TEST;
            createOrderActionInput.alternativePaymentMethod.status = SOM_AlternativePaymentMethodStatus.ACTIVE.enumValue;
        } else if (hasDigitalWallet) {
            createOrderActionInput.digitalWallet = new SOM_TestDataInput.DigitalWalletInput();
            createOrderActionInput.digitalWallet.type = inputOptions.get(
                SOM_TestDataInputOptions.DIGITAL_WALLET
            );
            createOrderActionInput.digitalWallet.customerName = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.paymentMethodCity = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.paymentMethodCountry = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.paymentMethodPostalCode = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.paymentMethodState = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.paymentMethodStreet = SOM_Constants.TEST;
            createOrderActionInput.digitalWallet.status = SOM_DigitalWalletStatus.ACTIVE.enumValue;
        }

        SOM_TestDataInput.OrderItemInput product1 = new SOM_TestDataInput.OrderItemInput();
        product1.product.name = SOM_Constants.TEST;
        product1.product.productCode = 'PRODUCT 1';
        product1.type = SOM_OrderItemType.ORDER_PRODUCT.enumValue;
        product1.quantity = 2;
        product1.unitPrice = 10;

        SOM_TestDataInput.OrderItemInput product2 = new SOM_TestDataInput.OrderItemInput();
        product2.product.name = SOM_Constants.TEST;
        product2.product.productCode = 'PRODUCT 2';
        product2.type = SOM_OrderItemType.ORDER_PRODUCT.enumValue;
        product2.quantity = 2;
        product2.unitPrice = 10;

        SOM_TestDataInput.OrderItemInput shipping = new SOM_TestDataInput.OrderItemInput();
        shipping.product.name = SOM_Constants.TEST;
        shipping.product.productCode = 'SHIPPING';
        shipping.type = SOM_OrderItemType.DELIVERY_CHARGE.enumValue;
        shipping.quantity = 1;
        shipping.unitPrice = 10;

        createOrderActionInput.orderItems = new List<SOM_TestDataInput.OrderItemInput>{ product1, product2, shipping };

        return createAndInsertOrder(createOrderActionInput)?.Id;
    }

    /**
     * @description Creates OrderSummary for test methods
     * @param orderId The Id of the order
     * @return Created OrderSummary record
     */
    public static OrderSummary createOrderSummary(String orderId) {
        // most of the orgs have flow creating order summary
        // automatically. therefore, checking if existing
        // otherwise we will face duplicate order summary issue
        List<OrderSummary> existingOrderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId = :orderId];
        if (existingOrderSummaries.isEmpty()) {
            ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
            input.orderId = orderId;

            ConnectApi.OrderSummaryOutputRepresentation output = SOM_Services.orderSummary.createOrderSummary(input);

            return new OrderSummary(Id = output.orderSummaryId);
        } else {
            return existingOrderSummaries[0];
        }
    }

    /**
     * @description Create one or more FulfillmentOrders
     * @param orderSummaryId Id of the OrderSummary
     * @param locationId Id of the Location
     * @param fulfillmentOrderType Type of the FulfillmentOrder (enum)
     * @return List of created FulfillmentOrder records
     */
    public static List<FulfillmentOrder> createFulfillmentOrders(
        String orderSummaryId,
        String locationId,
        SOM_FulfillmentOrderType fulfillmentOrderType
    ) {
        ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
        fulfillmentOrderInput.orderSummaryId = orderSummaryId;

        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [
            SELECT Id
            FROM OrderDeliveryGroupSummary
            WHERE OrderSummaryId = :orderSummaryId
            WITH SECURITY_ENFORCED
        ];
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = SOM_TestDataFactoryHelper.getOrderItemSummaryMap(
            orderDeliveryGroupSummaryList
        );

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary : orderDeliveryGroupSummaryList) {
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = locationId;
            fulfillmentGroup.fulfillmentType = fulfillmentOrderType.enumValue;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(
                orderDeliveryGroupSummary.Id
            );

            for (OrderItemSummary orderItemSummary : orderItemSummaryList) {
                ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                orderItemSummaryInputList.add(orderItemSummaryInput);
            }

            fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
            fulfillmentGroups.add(fulfillmentGroup);
            fulfillmentOrderInput.fulfillmentGroups = fulfillmentGroups;
        }

        ConnectApi.FulfillmentOrderOutputRepresentation output = ConnectApi.FulfillmentOrder.createFulfillmentOrders(
            fulfillmentOrderInput
        );

        List<FulfillmentOrder> createdFulfillmentOrders = new List<FulfillmentOrder>();

        for (String fulfillmentOrderId : output.fulfillmentOrderIds) {
            createdFulfillmentOrders.add(new FulfillmentOrder(Id = fulfillmentOrderId));
        }

        return createdFulfillmentOrders;
    }

    /**
     * @description Creates Batch Configuration metadata record
     * @return Batch Configuration metadata record
     */
    public static SOM_BatchConfiguration__mdt createSOMBatchConfigurationRecord() {
        SOM_BatchConfiguration__mdt configuration = new SOM_BatchConfiguration__mdt();
        configuration.BatchSize__c = 100;
        configuration.ErrorEmailRecipients__c = (String) UserInfo.getUserId();
        configuration.IsActive__c = true;
        configuration.QuerySize__c = 500;
        configuration.RetryCount__c = 5;
        configuration.SendErrorEmail__c = true;
        configuration.SendSuccessEmail__c = true;
        configuration.SuccessEmailRecipients__c = (String) UserInfo.getUserId();
        return configuration;
    }

    /**
     * @description Creates Unified Setting Configuration metadata record
     * @return Unified Setting metadata record
     */
    public static SOM_UnifiedSettings__mdt createUnifiedSettingRecord() {
        SOM_UnifiedSettings__mdt configuration = new SOM_UnifiedSettings__mdt();
        configuration.Key__c = 'TestKey';
        configuration.Value__c = 'True';
        return configuration;
    }

    /**
     * @description Creates ConnectApi error
     * @return ConnectApi error
     */
    public static ConnectApi.OrderSummaryOutputRepresentation createConnectApiError() {
        ConnectApi.OrderSummaryOutputRepresentation output = new ConnectApi.OrderSummaryOutputRepresentation();
        output.success = false;
        output.errors = SOM_TestDataFactoryHelper.createErrorResponseList();
        return output;
    }

    /**
     * @description Creates OCI Release Reservation ConnectApi error
     * @return OCIReleaseReservationOutputRepresentation
     */
    public static ConnectApi.OCIReleaseReservationOutputRepresentation createOCIReleaseReservationConnectApiError() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = new ConnectApi.OCIReleaseReservationOutputRepresentation();
        output.success = false;
        output.errors = SOM_TestDataFactoryHelper.createOCIReleaseReservationErrorResponseList();
        return output;
    }

    /**
     * @description Creates OCI Transfer Reservation ConnectApi error
     * @return OCITransferReservationOutputRepresentation
     */
    public static ConnectApi.OCITransferReservationOutputRepresentation createOCITransferReservationConnectApiError() {
        ConnectApi.OCITransferReservationOutputRepresentation output = new ConnectApi.OCITransferReservationOutputRepresentation();
        output.success = false;
        output.errors = SOM_TestDataFactoryHelper.createOCITransferReservationErrorResponseList();
        return output;
    }

    /**
     * @description Create a ReturnOrder and
     *   ReturnOrderLineItems for items belonging
     *   to an OrderSummary
     * @param orderSummaryId Id of the OrderSummary
     * @param returnOrderStatus ReturnOrder status (enum)
     * @param returnOrderLineItemInputList ReturnOrderLineItemInput list
     * @return Id of the created ReturnOrder
     */
    public static ConnectApi.ReturnOrderOutputRepresentation createReturnOrder(
        String orderSummaryId,
        SOM_ReturnOrderStatus returnOrderStatus,
        List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList
    ) {
        ConnectApi.ReturnOrderInputRepresentation input = new ConnectApi.ReturnOrderInputRepresentation();
        input.orderSummaryId = orderSummaryId;
        input.returnOrderLifeCycleType = SOM_LifeCycleType.MANAGED.enumValue;
        input.returnOrderLineItems = returnOrderLineItemInputList;
        input.status = returnOrderStatus.enumValue;

        return ConnectApi.ReturnOrder.createReturnOrder(input);
    }

    /**
     * @description Builds input list for adjustPreview & adjustSubmit
     * @param orderItemSummaries List of OrderItemSummary
     * @param taxLocaleType Type of the tax
     * @param reason Reason for change
     * @param adjustment Adjustment amout of the items
     * @return ConnectApi.AdjustOrderItemSummaryInputRepresentation
     */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public static ConnectApi.AdjustOrderItemSummaryInputRepresentation buildAdjustOrderItemSummaryInput(
        List<OrderItemSummary> orderItemSummaries,
        String taxLocaleType,
        SOM_OrderItemSummaryChangeReason reason,
        Double adjustment
    ) {
        String adjustmentType = taxLocaleType.equalsIgnoreCase(SOM_Constants.GROSS)
            ? SOM_Constants.AMOUNT_WITH_TAX
            : SOM_Constants.AMOUNT_WITHOUT_TAX;

        List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = new List<ConnectApi.AdjustItemInputRepresentation>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.AdjustItemInputRepresentation adjustItemInput = new ConnectApi.AdjustItemInputRepresentation();
            adjustItemInput.adjustmentType = adjustmentType;
            adjustItemInput.amount = adjustment;
            adjustItemInput.orderItemSummaryId = orderItemSummary.Id;
            adjustItemInput.reason = reason.enumValue;
            adjustItemInputList.add(adjustItemInput);
        }

        ConnectApi.AdjustOrderItemSummaryInputRepresentation input = new ConnectApi.AdjustOrderItemSummaryInputRepresentation();
        input.adjustItems = adjustItemInputList;

        return input;
    }

    /**
     * @description Builds input for previewCancel|submitCancel|previewReturn|submitReturn
     * @param orderItemSummaries List of OrderItemSummary
     * @param reason Change reason
     * @param shippingReductionFlag Reduction shipping
     * @return ConnectApi.ChangeInputRepresentation
     */
    public static ConnectApi.ChangeInputRepresentation buildChangeInput(
        List<OrderItemSummary> orderItemSummaries,
        SOM_OrderItemSummaryChangeReason reason,
        Boolean shippingReductionFlag
    ) {
        ConnectApi.ChangeInputRepresentation changeInput = new ConnectApi.ChangeInputRepresentation();
        List<ConnectApi.ChangeItemInputRepresentation> changeItemInputList = new List<ConnectApi.ChangeItemInputRepresentation>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.ChangeItemInputRepresentation changeItemInput = new ConnectApi.ChangeItemInputRepresentation();
            changeItemInput.orderItemSummaryId = orderItemSummary.Id;
            changeItemInput.quantity = orderItemSummary.Quantity;
            changeItemInput.reason = reason.enumValue;
            changeItemInput.shippingReductionFlag = shippingReductionFlag;
            changeItemInputList.add(changeItemInput);
        }

        changeInput.changeItems = changeItemInputList;
        return changeInput;
    }

    /**
     * @description Creates Invoice
     * @param fulfillmentOrderId Id of the FulfillmentOrder
     * @return Id of created Invoice
     */
    public static String createInvoice(String fulfillmentOrderId) {
        ConnectApi.FulfillmentOrderInvoiceInputRepresentation invoiceInput = new ConnectApi.FulfillmentOrderInvoiceInputRepresentation();
        return ConnectApi.FulfillmentOrder.createInvoice(fulfillmentOrderId, invoiceInput).invoiceId;
    }

    /**
     * @description Creates a payment authorization and payment
     * @param orderId Order Id
     * @param orderSummaryId Order summary Id
     * @param amount Payment amount
     * @param paymentGatewayId Payment gateway Id
     * @param isCaptured Is payment captured
     * @return ConnectApi.CreateOrderPaymentSummaryOutputRepresentation
     */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public static ConnectApi.CreateOrderPaymentSummaryOutputRepresentation createPaymentAuthHistory(
        String orderId,
        String orderSummaryId,
        Double amount,
        Id paymentGatewayId,
        Boolean isCaptured
    ) {
        PaymentGroup paymentGroup = createPaymentGroup(orderId);
        insert paymentGroup;

        PaymentAuthorization paymentAuthorization = createPaymentAuthorization(amount, paymentGroup.Id);
        paymentAuthorization.Status = 'Draft';
        paymentAuthorization.PaymentGatewayId = paymentGatewayId;
        paymentAuthorization.GatewayRefNumber = SOM_Constants.TEST + '12345' + orderSummaryId;
        insert paymentAuthorization;

        paymentAuthorization.Status = SOM_Constants.PROCESSED;
        update paymentAuthorization;

        if (!isCaptured) {
            amount = 0;
        }

        Payment payment = createPayment(amount, String.valueOf(paymentAuthorization.Id));
        insert payment;

        ConnectApi.CreateOrderPaymentSummaryInputRepresentation orderPaymentSummaryInput = new ConnectApi.CreateOrderPaymentSummaryInputRepresentation();
        orderPaymentSummaryInput.orderSummaryId = orderSummaryId;

        List<String> paymentList = new List<String>();
        paymentList.add(payment.Id);

        orderPaymentSummaryInput.paymentIds = paymentList;
        orderPaymentSummaryInput.paymentAuthorizationId = paymentAuthorization.Id;
        ConnectApi.CreateOrderPaymentSummaryOutputRepresentation output = ConnectAPI.OrderPaymentSummary.createOrderPaymentSummary(
            orderPaymentSummaryInput
        );

        return output;
    }

    /**
     * @description Creates payment authorization
     * @param amount Payment amount
     * @param paymentGroupId Payment group Id (createPaymentGroup)
     * @return PaymentAuthorization
     */
    public static PaymentAuthorization createPaymentAuthorization(Double amount, String paymentGroupId) {
        PaymentAuthorization paymentAuthorization = new PaymentAuthorization();
        paymentAuthorization.Amount = amount;
        paymentAuthorization.ProcessingMode = SOM_Constants.EXTERNAL;
        paymentAuthorization.PaymentGroupId = paymentGroupId;
        paymentAuthorization.Status = SOM_Constants.PROCESSED;
        return paymentAuthorization;
    }

    /**
     * @description Creates payment
     * @param amount Payment amount
     * @param paymentAuthorizationId Payment authorization Id (createPaymentAuthorization)
     * @return Payment
     */
    public static Payment createPayment(Double amount, String paymentAuthorizationId) {
        Payment payment = new Payment();
        payment.PaymentAuthorizationId = paymentAuthorizationId;
        payment.EffectiveDate = Datetime.now();
        payment.Type = SOM_Constants.CAPTURE;
        payment.Amount = amount;
        payment.Status = SOM_Constants.PROCESSED;
        payment.ProcessingMode = SOM_Constants.EXTERNAL;
        return payment;
    }

    /**
     * @description Creates order summary
     * @param orderId Order Id
     * @return OrderSummary Id
     */
    public static Id createOrderSummary(Id orderId) {
        String orderSummaryId;

        // most of the orgs have flow creating order summary
        // automatically. therefore, checking if existing
        // otherwise we will face duplicate order summary issue
        List<OrderSummary> existingOrderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId = :orderId];
        if (existingOrderSummaries.isEmpty()) {
            ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
            input.orderId = orderId;
            input.orderLifeCycleType = SOM_Constants.MANAGED;

            Test.startTest();
            ConnectApi.OrderSummaryOutputRepresentation output = SOM_Services.orderSummary.createOrderSummary(input);
            Test.stopTest();

            orderSummaryId = output.orderSummaryId;
        } else {
            orderSummaryId = existingOrderSummaries[0].Id;
        }

        return orderSummaryId;
    }
    /**
     * @description  Creates metadata for test
     * @return mock metadata
     */
    public static SOM_PurgeSetting__mdt createSOMPurgeSettingRecord() {
        SOM_PurgeSetting__mdt configuration = new SOM_PurgeSetting__mdt();
        configuration.CustomApprovedStatus__c = 'Approved';
        configuration.CustomFulfilledStatus__c = 'Fulfilled';
        configuration.DaysOldAllStatus__c = 0;
        configuration.DaysOldApprovedStatus__c = 0;
        configuration.DaysOldFulfilledStatus__c = 0;
        configuration.PurgePaymentGatewayLogs__c = true;
        return configuration;
    }
}