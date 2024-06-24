/**
* @description RoutingService test class
*/
@isTest
private class SOM_RoutingServiceTest {
    /**
    * @description Test method of RoutingService.findRoutesWithFewestSplits
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldFindRoutesWithFewestSplits() {
        String stockKeepingUnit = '001';

        ConnectApi.LocationAvailabilityInputRepresentation locationAvailabilityInput = new ConnectApi.LocationAvailabilityInputRepresentation();
        locationAvailabilityInput.externalReferenceId = SOM_Constants.WAREHOUSE;
        locationAvailabilityInput.quantity = 2;
        locationAvailabilityInput.stockKeepingUnit = stockKeepingUnit;

        ConnectApi.QuantityWithSkuInputRepresentation skuInput = new ConnectApi.QuantityWithSkuInputRepresentation();
        skuInput.quantity = 2;
        skuInput.stockKeepingUnit = stockKeepingUnit;

        ConnectApi.FindRoutesWithFewestSplitsInputRepresentation input = new ConnectApi.FindRoutesWithFewestSplitsInputRepresentation();
        input.locationAvailableInventory = new List<ConnectApi.LocationAvailabilityInputRepresentation>{ locationAvailabilityInput };
        input.orderedQuantities = new List<ConnectApi.QuantityWithSkuInputRepresentation>{ skuInput };
        input.maximumNumberOfSplits = 0;

        Test.startTest();
        ConnectApi.FindRoutesWithFewestSplitsOutputRepresentation output = SOM_Services.routing.findRoutesWithFewestSplits(input);
        Test.stopTest();

        System.assert(output.success, 'Routing find routues with fewest splits action is failed');
    }

    /**
    * @description Test method of RoutingService.rankAverageDistance
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldRankAverageDistance() {
        String countryCode = 'USA';
        String postalCode = '10001';

        ConnectApi.LocationInputRepresentation locationInput = new ConnectApi.LocationInputRepresentation();
        locationInput.countryCode = countryCode;
        locationInput.locationIdentifier = SOM_Constants.WAREHOUSE;
        locationInput.postalCode = postalCode;

        ConnectApi.TargetLocationInputRepresentation targetLocationInput = new ConnectApi.TargetLocationInputRepresentation();
        targetLocationInput.locations = new List<ConnectApi.LocationInputRepresentation>{ locationInput };

        ConnectApi.RankAverageDistanceInputRepresentation input = new ConnectApi.RankAverageDistanceInputRepresentation();
        input.deliveryCountryCode = countryCode;
        input.deliveryPostalCode = postalCode;
        input.distanceUnit = 'km'; // km|mi
        input.sortResult = 'DESC';
        input.targetLocations = new List<ConnectApi.TargetLocationInputRepresentation>{ targetLocationInput };

        Test.startTest();
        ConnectApi.RankAverageDistanceOutputRepresentation output = SOM_Services.routing.rankAverageDistance(input);
        Test.stopTest();

        System.assert(output.success, 'Rank average distance action is failed');
    }
}