/**
 * CREATE ORDER ACTION
 *  - OptionalPricebookEntry is enabled therefore PricebookEntry object is not in use
 */

String accountId = [SELECT Id FROM Account LIMIT 1].Id;

Order newOrder = new Order();
newOrder.AccountId = accountId;
newOrder.SalesChannelId = [SELECT Id FROM SalesChannel LIMIT 1].Id;
newOrder.EffectiveDate = Date.today();
newOrder.Status = 'Draft';
newOrder.OrderedDate = Date.today();
insert newOrder;

OrderDeliveryGroup newOrderDeliveryGroup = new OrderDeliveryGroup();
newOrderDeliveryGroup.OrderId = newOrder.Id;
newOrderDeliveryGroup.OrderDeliveryMethodId = [SELECT Id FROM OrderDeliveryMethod LIMIT 1].Id;
newOrderDeliveryGroup.DeliverToName = 'OSF DIGITAL';
newOrderDeliveryGroup.DeliverToCountry = 'OSF DIGITAL LAND';
newOrderDeliveryGroup.DeliverToCity = 'OSF DIGITAL CITY';
newOrderDeliveryGroup.DeliverToPostalCode = 'OSF';
newOrderDeliveryGroup.DeliverToStreet = 'OSF DIGITAL STREET';
insert newOrderDeliveryGroup;

OrderItem newOrderItem1 = new OrderItem();
newOrderItem1.OrderId = newOrder.Id;
newOrderItem1.Product2Id = [SELECT Id FROM Product2 WHERE ProductCode = '111111111'].Id;
newOrderItem1.OrderDeliveryGroupId = newOrderDeliveryGroup.Id;
newOrderItem1.UnitPrice = 10;
newOrderItem1.ListPrice = 10;
newOrderItem1.Quantity = 1;
newOrderItem1.Type = 'Order Product';
newOrderItem1.TotalLineAmount = 10;

OrderItem newOrderItem2 = new OrderItem();
newOrderItem2.OrderId = newOrder.Id;
newOrderItem2.Product2Id = [SELECT Id FROM Product2 WHERE ProductCode = '222222222'].Id;
newOrderItem2.OrderDeliveryGroupId = newOrderDeliveryGroup.Id;
newOrderItem2.UnitPrice = 10;
newOrderItem2.ListPrice = 10;
newOrderItem2.Quantity = 1;
newOrderItem2.Type = 'Order Product';
newOrderItem2.TotalLineAmount = 10;

OrderItem newShippingItem = new OrderItem();
newShippingItem.OrderId = newOrder.Id;
newShippingItem.Product2Id = [SELECT Id FROM Product2 WHERE ProductCode = 'FedEx_Standard_Ground'].Id;
newShippingItem.OrderDeliveryGroupId = newOrderDeliveryGroup.Id;
newShippingItem.UnitPrice = 10;
newShippingItem.ListPrice = 10;
newShippingItem.Quantity = 1;
newShippingItem.Type = 'Delivery Charge';
newShippingItem.TotalLineAmount = 10;

insert new List<OrderItem>{ newOrderItem1, newOrderItem2, newShippingItem };

PaymentGroup newPaymentGroup = new PaymentGroup();
newPaymentGroup.SourceObjectId = newOrder.Id;
insert newPaymentGroup;

CardPaymentMethod newCardPaymentMethod = new CardPaymentMethod();
newCardPaymentMethod.CardType = 'Visa';
newCardPaymentMethod.CardHolderName = String.format('{0} {0}', new List<String>{ SOM_Constants.TEST });
newCardPaymentMethod.ExpiryYear = System.today().year() + 1;
newCardPaymentMethod.ExpiryMonth = 1;
newCardPaymentMethod.CardCategory = 'CreditCard';
newCardPaymentMethod.Status = 'Active';
newCardPaymentMethod.AccountId = accountId;
newCardPaymentMethod.ProcessingMode = 'External';
newCardPaymentMethod.paymentGatewayId = [SELECT Id FROM PaymentGateway Where PaymentGatewayName = 'Mock Payment Gateway' LIMIT 1].Id;
insert newCardPaymentMethod;

PaymentAuthorization newPaymentAuthorization = new PaymentAuthorization();
newPaymentAuthorization.Amount = 30;
newPaymentAuthorization.ProcessingMode = 'External';
newPaymentAuthorization.PaymentGroupId = newPaymentGroup.Id;
newPaymentAuthorization.PaymentMethodId = newCardPaymentMethod.Id;
newPaymentAuthorization.Status = 'Processed';
newPaymentAuthorization.paymentGatewayId = [SELECT Id FROM PaymentGateway Where PaymentGatewayName = 'Mock Payment Gateway' LIMIT 1].Id;
insert newPaymentAuthorization;

newOrder.Status = 'Activated';
update newOrder;