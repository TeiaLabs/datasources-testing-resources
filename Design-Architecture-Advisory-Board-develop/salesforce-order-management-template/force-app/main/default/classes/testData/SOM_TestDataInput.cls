/**
* @description Input class for Test Data Factory operations 
*   suppress reasons : REFACTOR, IGNORE
*/
@suppressWarnings('PMD.ClassNamingConventionTest, PMD.ExcessivePublicCount')
@isTest
public class SOM_TestDataInput {
    /**
    * @description Create Order input  
    */
    public class CreateOrderActionInput {
        public AccountInput account;
        public ContactInput contact;
        public OrderInput order;
        public SalesChannelInput salesChannel;
        public OrderDeliveryGroupInput orderDeliveryGroup;
        public OrderDeliveryMethodInput orderDeliveryMethod;
        public LocationInput location;
        public PaymentInput payment;
        public PaymentGatewayInput paymentGateway;
        public PaymentGroupInput paymentGroup;
        public PaymentAuthorizationInput paymentAuthorization;
        public CardPaymentMethodInput cardPaymentMethod;
        public DigitalWalletInput digitalWallet;
        public AlternativePaymentMethodInput alternativePaymentMethod;
        public List<OrderItemInput> orderItems;
    }

    /**
    * @description Contact input 
    */
    public class ContactInput {
        public String lastName;
    }

    /**
    * @description Product input 
    */
    public class ProductInput {
        public String name;
        public String productCode;
    }

    /**
    * @description PricebookEntry input 
    */
    public class PricebookEntryInput {
        public Id pricebook2Id;
        public Id product2Id;
        public Decimal unitPrice;

        /**
        * @description Constructor to set default values 
        */
        public PricebookEntryInput() {
            this.pricebook2Id = Test.getStandardPricebookId();
        }
    }

    /**
    * @description Account input 
    */
    public class AccountInput {
        public Id recordTypeId;
        public String firstName;
        public String lastName;
        public String email;
    }

    /**
    * @description Saleschannel input 
    */
    public class SalesChannelInput {
        public String name;
    }

    /**
    * @description Order input 
    */
    public class OrderInput {
        public Id accountId;
        public Id pricebook2Id;
        public Id salesChannelId;
        public String status;
        public Date effectiveDate;
        public String orderReferenceNumber;

        /**
        * @description Constructor to set default values 
        */
        public OrderInput() {
            this.pricebook2Id = Test.getStandardPricebookId();
        }
    }

    /**
    * @description OrderDeliveryMethod input 
    */
    public class OrderDeliveryMethodInput {
        public String name;
        public String referenceNumber;
    }

    /**
    * @description OrderDeliveryGroup input 
    */
    public class OrderDeliveryGroupInput {
        public Id orderId;
        public Id orderDeliveryMethodId;
        public String deliverToName;
        public String deliverToCountry;
        public String deliverToCity;
        public String deliverToPostalCode;
        public String deliverToStreet;
    }

    /**
    * @description OrderItem input 
    */
    public class OrderItemInput {
        public Id orderId;
        public Id orderDeliveryGroupId;
        public Id product2Id;
        public Id pricebookEntryId;
        public String type;
        public Integer quantity;
        public Decimal unitPrice;
        public ProductInput product;
        public PricebookEntryInput pricebookEntry;
        public List<OrderItemTaxLineItemInput> orderItemTaxLineItems;
        public List<OrderItemAdjustmentLineItemInput> orderItemAdjustmentLineItems;

        /**
        * @description Gets line amount 
        */
        public Decimal totalLineAmount 
        { 
            get { return quantity * unitprice; } 
            set;
        }

        /**
        * @description Constructor to set default values 
        */
        public OrderItemInput() {
            this.product = new ProductInput();
            this.pricebookEntry = new PricebookEntryInput();
        }
    }

    /**
    * @description Location input 
    */
    public class LocationInput {
        public String name;
        public String externalReference;
        public String locationType;
    }

    /**
    * @description OrderItemAdjustmentLineItem input 
    */
    public class OrderItemAdjustmentLineItemInput {
        public Id orderItemId;
        public String name;
        public Double amount;
    }

    /**
    * @description OrderItemTaxLineItem input 
    */
    public class OrderItemTaxLineItemInput {
        public Id orderItemId;
        public String name;
        public String type;
        public Double amount;
        public Double rate;
        public Date taxEffectiveDate;
    }

    /**
    * @description PaymentGroup input 
    */
    public class PaymentGroupInput {
        public String sourceObjectId;
    }

    /**
    * @description PaymentAuthorization input 
    */
    public class PaymentAuthorizationInput {
        public Id paymentGatewayId;
        public Id paymentMethodId;
        public Id paymentGroupId;
        public String status;
        public String processingMode;
        public Double amount;

        /**
        * @description Constructor to set default values 
        */
        public PaymentAuthorizationInput() {
            this.processingMode = SOM_ProcessingMode.EXTERNAL.enumValue;
        }
    }

    /**
    * @description CardPaymentMethod input 
    */
    public class CardPaymentMethodInput {
        public Id accountId;
        public Id paymentGatewayId;
        public String cardHolderName;
        public String cardType;
        public String cardCategory;
        public String status;
        public String processingMode;
        public Integer expiryMonth;
        public Integer expiryYear;

        /**
        * @description Constructor to set default values 
        */
        public CardPaymentMethodInput() {
            this.processingMode = SOM_ProcessingMode.EXTERNAL.enumValue;
        }
    }

    /**
    * @description DigitalWallet input 
    */
    public class DigitalWalletInput {
        public Id accountId;
        public Id paymentGatewayId;
        public String type;
        public String customerName;
        public String comments;

        public Address paymentMethodAddress;
        public String paymentMethodCity;
        public String paymentMethodCountry;
        public String paymentMethodPostalCode;
        public String paymentMethodState;
        public String paymentMethodStreet;
        public String status;
        public String processingMode;


        /**
        * @description Constructor to set default values 
        */
        public DigitalWalletInput() {
            this.processingMode = SOM_ProcessingMode.EXTERNAL.enumValue;
        }
    }

    /**
    * @description AlternativePaymentMethod input 
    */
    public class AlternativePaymentMethodInput {
        public Id accountId;
        public Id paymentGatewayId;

        public String nickName;
        public Address paymentMethodAddress;
        public String paymentMethodCity;
        public String paymentMethodCountry;
        public String paymentMethodPostalCode;
        public String paymentMethodState;
        public String paymentMethodStreet;
        public String status;
        public String processingMode;

        /**
        * @description Constructor to set default values 
        */
        public AlternativePaymentMethodInput() {
            this.processingMode = SOM_ProcessingMode.EXTERNAL.enumValue;
        }
    }

    /**
    * @description Payment input 
    */
    public class PaymentInput {
        public Id paymentGatewayId;
        public String status;
        public String processingMode;
        public String type;
        public Double amount;

        /**
        * @description Constructor to set default values 
        */
        public PaymentInput() {
            this.processingMode = SOM_ProcessingMode.EXTERNAL.enumValue;
        }
    }

    /**
    * @description PaymentGateway input 
    */
    public class PaymentGatewayInput {
        public String paymentGatewayName;
        public String externalReference;
        public String merchantCredentialId;
        public String paymentGatewayProviderId;
        public String status;

        /**
        * @description Constructor to set default values 
        */
        public PaymentGatewayInput() {
            this.status = SOM_Constants.ACTIVE;
        }
    }
}