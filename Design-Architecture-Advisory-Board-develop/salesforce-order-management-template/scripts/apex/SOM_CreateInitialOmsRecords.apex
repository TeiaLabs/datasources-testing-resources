/*
 The purpose of this script is to create test data in order to use in scratch orgs when placing test orders.
 *
 * ACTIONS LIST:
 * 1. Create & Insert PaymentGateway 
 * 2. Create & Insert SalesChannel
 * 3. Create & Insert Account
 * 4. Create & Insert Location Group & Locations
 * 5. Create & Insert Order and Shipping Products
 * 6. Create & Insert OrderDeliveryMethods

apexClassId=`sfdx data soql query -q "SELECT Id FROM ApexClass WHERE Name='SOM_SalesforceAdapter' LIMIT 1" -r csv |tail -n +2`
sfdx data record create -s PaymentGatewayProvider -v "DeveloperName=SOM_SalesforceMockPaymentGateway ApexAdapterId=$apexClassId MasterLabel=SOM_SalesforceMockPaymentGateway IdempotencySupported=Yes Comments=Comments"
*/

// constants
Id pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE].Id;
String mockPaymentGatewayExternalReference = 'NO_PAYMENT';
String salesChannelName = 'pgatss';
String personEmail = 'john.doe.001@test.com';
String locationGroupExternalReference= 'pgatss-inventory';
Map<String, String> mapLocationReferenceToType = new Map<String, String>{
    'TestWarehouse' => 'Warehouse',
    '0101' => 'Store',
    '1233' => 'Store',
    '100690' => 'Dropshipping',
    'Digital' => 'Digital'
};
List<String> orderProductCodes = new List<String>{ '111111111', '222222222', '333333333' }; // test products
List<String> shippingProductCodes = new List<String>{
  'FedEx_Standard_Ground',
  'FedEx_Guaranteed_Ground',
  'ISPU',
  'Borderfree',
  'Electronic'
};


// CREATE PAYMENT GATEWAY (creating only mock payment gateway)
List<PaymentGateway> mockPaymentGateway = [
  SELECT Id
  FROM PaymentGateway
  WHERE ExternalReference =: mockPaymentGatewayExternalReference
  LIMIT 1
];
if (mockPaymentGateway.isEmpty()) {
  // pre defined items are provided in the solution
  String namedCredentialId = [SELECT Id FROM NamedCredential WHERE DeveloperName = 'SOM_TestNamedCredential'].Id;
  String paymentGatewayProviderId = [
    SELECT Id
    FROM PaymentGatewayProvider
    WHERE DeveloperName = 'SOM_TestPaymentGatewayProvider'
  ]
  .Id;
  PaymentGateway newPaymentGateway = new PaymentGateway();
  newPaymentGateway.PaymentGatewayName = 'Mock Payment Gateway';
  newPaymentGateway.ExternalReference = mockPaymentGatewayExternalReference;
  newPaymentGateway.MerchantCredentialId = namedCredentialId;
  newPaymentGateway.PaymentGatewayProviderId = paymentGatewayProviderId;
  newPaymentGateway.Status = 'Active';
  insert newPaymentGateway;
}

// CREATE SALES CHANNEL
List<SalesChannel> salesChannels = [SELECT Id FROM SalesChannel LIMIT 1];
if (salesChannels.isEmpty()) {
  SalesChannel newSalesChannel = new SalesChannel();
  newSalesChannel.SalesChannelName = salesChannelName;
  newSalesChannel.ExternalChannelNumber = salesChannelName;
  newSalesChannel.Description = salesChannelName;
  newSalesChannel.Type = 'B2C';
  insert newSalesChannel;
}

// CREATE ACCOUNT
List<Account> accounts = [SELECT Id FROM Account WHERE PersonEmail =: personEmail LIMIT 1];
if (accounts.isEmpty()) {
  Account newAccount = new Account();
  newAccount.FirstName = 'John';
  newAccount.LastName = 'Doe';
  newAccount.PersonEmail = personEmail;
  newAccount.RecordTypeId = [
    SELECT Id
    FROM RecordType
    WHERE IsPersonType = TRUE AND IsActive = TRUE AND SObjectType = :String.valueOf(Account.SObjectType)
    LIMIT 1
  ]
  .Id;
  insert newAccount;
}

// CREATE LOCATION GROUP & LOCATIONS & ASSIGNMENTS & LOCATION ADDRESSES
List<LocationGroup> locationGroups = [SELECT Id FROM LocationGroup LIMIT 1];
if (locationGroups.isEmpty()) {
  // insert location group
  LocationGroup locationGroup = new LocationGroup();
  locationGroup.LocationGroupName = locationGroupExternalReference;
  locationGroup.ExternalReference = locationGroupExternalReference;
  locationGroup.IsEnabled = true;
  locationGroup.ShouldSyncWithOci = true;
  insert locationGroup;

  // insert locations  
  List<Schema.Location> locations = new List<Schema.Location>();
  for (String locationReference : mapLocationReferenceToType.keySet()) {
    Schema.Location newLocation = new Schema.Location();
    newLocation.Name = locationReference;
    newLocation.ExternalReference = locationReference;
    newLocation.LocationType = mapLocationReferenceToType.get(locationReference);
    newLocation.ShouldSyncWithOci = true;
    newLocation.IsInventoryLocation = true;
    newLocation.TimeZone = 'America/Anguilla';
    locations.add(newLocation);
  }
  insert locations;

  // insert LocationGroupAssignments
  List<LocationGroupAssignment> listGroupAssignmentsToAdd = new List<LocationGroupAssignment>();
  for (Schema.Location location : locations) {
    LocationGroupAssignment assignment = new LocationGroupAssignment();
    assignment.LocationId = location.Id;
    assignment.LocationGroupId = locationGroup.Id;
    listGroupAssignmentsToAdd.add(assignment);
  }
  insert listGroupAssignmentsToAdd;

  //NOTE: commit changes in OCI after running the script

  // insert Addresses
  List<Schema.Address> listAddressesToAdd = new List<Schema.Address>();
  for (Schema.Location location : locations) {
    Schema.Address address = new Schema.Address();
    address.ParentId = location.Id;
    address.LocationType = location.LocationType;
    address.TimeZone = 'America/Anguilla';
    address.Street = '1005 Holcomb Woods Parkway';
    address.City = 'Roswell';
    address.State = 'GA';
    address.PostalCode = '30076-2738'; // change the postal code for each store to test DOM fewest split
    address.Country = 'US';
    listAddressesToAdd.add(address);
  }
  insert listAddressesToAdd;
  // update location.visitoraddress id
  List<Schema.Location> locations2 = [
    SELECT Id, VisitorAddressId, (SELECT Id FROM Addresses)
    FROM Location
    WHERE VisitorAddressId = NULL
  ];
  List<Schema.Location> listLocationsToUpdate = new List<Schema.Location>();
  for (Schema.Location location : locations2) {
    if (location.Addresses.size() > 0) {
      location.VisitorAddressId = location.Addresses[0].Id;
      listLocationsToUpdate.add(location);
    }
  }
  update listLocationsToUpdate;
}

// CREATE PRODUCTS
List<Product2> products = [SELECT Id FROM Product2 LIMIT 1];
if (products.isEmpty()) {
  // insert order products
  List<Product2> productsToInsert = new List<Product2>();
  for (String productCode : orderProductCodes) {
    Product2 orderProduct = new Product2(
      Name = 'Test Product ' + productCode,
      StockKeepingUnit = productCode,
      ProductCode = productCode,
      Description = 'Test Product ' + productCode,
      Family = 'Order Product',
      IsActive = true
    );
    productsToInsert.add(orderProduct);
  }
  // insert shipping products
  for (String productCode : shippingProductCodes) {
    Product2 shippingProduct = new Product2(
      Name = productCode,
      StockKeepingUnit = productCode,
      ProductCode = productCode,
      Description = 'Shipping Product ' + productCode,
      Family = 'Delivery Charge',
      IsActive = true
    );
    productsToInsert.add(shippingProduct);
  }
  insert productsToInsert;

  // insert pricebook entries
  List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
  for (Product2 productRecord : productsToInsert) {
    PricebookEntry newPricebookEntry = new PricebookEntry();
    newPricebookEntry.Pricebook2Id = pricebookId;
    newPricebookEntry.Product2Id = productRecord.Id;
    newPricebookEntry.UnitPrice = 10.0; // dummy

    priceBookEntries.add(newPricebookEntry);
  }
  insert priceBookEntries;
}

// CREATE ORDER DELIVERY METHODS
List<OrderDeliveryMethod> orderDeliveryMethods = [SELECT Id FROM OrderDeliveryMethod LIMIT 1];
if (orderDeliveryMethods.isEmpty()) {
  List<Product2> shippingProducts = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN :shippingProductCodes];
  // create delivery methods for each shippipng products
  List<OrderDeliveryMethod> orderDeliveryMethodsToInsert = new List<OrderDeliveryMethod>();
  for (Product2 shippingProduct : shippingProducts) {
    OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod();
    orderDeliveryMethod.Name = shippingProduct.ProductCode;
    orderDeliveryMethod.ReferenceNumber = shippingProduct.ProductCode;
    orderDeliveryMethod.ProductId = shippingProduct.Id;
    orderDeliveryMethod.IsActive = true;
    orderDeliveryMethodsToInsert.add(orderDeliveryMethod);
  }
  insert orderDeliveryMethodsToInsert;
}

// LIST IDs
/*
Use below script to print ID values in debug to use them in Postman collection
*/
Id mockPaymentGatewayId = [SELECT Id FROM PaymentGateway WHERE ExternalReference = 'NO_PAYMENT'].Id;
System.debug('mockPaymentGatewayId: ' + mockPaymentGatewayId);

Id salesChannelId = [SELECT Id FROM SalesChannel WHERE ExternalChannelNumber = 'pgatss'].Id;
System.debug('salesChannelId: ' + salesChannelId);

Id accountId = [SELECT Id FROM Account WHERE PersonEmail = 'john.doe.001@test.com'].Id;
System.debug('accountId: ' + accountId);

Id locationGroupId = [SELECT Id FROM LocationGroup WHERE ExternalReference = 'pgatss-inventory'].Id;
System.debug('locationGroupId: ' + locationGroupId);

Id deliveryMethodStandardGroundId = [SELECT Id FROM OrderDeliveryMethod WHERE ReferenceNumber = 'FedEx_Standard_Ground']
.Id;
System.debug('deliveryMethodStandardGroundId: ' + deliveryMethodStandardGroundId);
Id productIdStandardGround = [SELECT Id FROM Product2 WHERE ProductCode = 'FedEx_Standard_Ground'].Id;
System.debug('productIdStandardGround: ' + productIdStandardGround);

Id deliveryMethodElectronicId = [SELECT Id FROM OrderDeliveryMethod WHERE ReferenceNumber = 'Electronic'].Id;
System.debug('deliveryMethodElectronicId: ' + deliveryMethodElectronicId);
Id productIdElectronic = [SELECT Id FROM Product2 WHERE ProductCode = 'Electronic'].Id;
System.debug('productIdElectronic: ' + productIdElectronic);

Id productIdTest1 = [SELECT Id FROM Product2 WHERE ProductCode = '111111111'].Id;
System.debug('productIdTest1: ' + productIdTest1);
Id productIdTest2 = [SELECT Id FROM Product2 WHERE ProductCode = '222222222'].Id;
System.debug('productIdTest2: ' + productIdTest2);
/**/
