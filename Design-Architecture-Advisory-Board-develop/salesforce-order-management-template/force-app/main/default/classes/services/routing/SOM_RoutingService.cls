/**
* @description Routing service class
*/
public with sharing class SOM_RoutingService implements SOM_IRoutingService {
    /**
    * @description Returns combinations of
    *   inventory locations that can fulfill
    *   an order within a specified limit of 
    *   shipment splits
    * @param input Data used to calculate order
    *   fulfillment routes involving the fewest
    *   number of shipment splits
    * @return A list of inventory location
    *   combinations that can fulfill an order
    *   without exceeding the maximum number of shipments
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_Routing_static_methods.htm#apex_ConnectAPI_Routing_findRoutesWithFewestSplits_1
    */
    public ConnectApi.FindRoutesWithFewestSplitsOutputRepresentation findRoutesWithFewestSplits(ConnectApi.FindRoutesWithFewestSplitsInputRepresentation input) {
        return ConnectApi.Routing.findRoutesWithFewestSplits(input);
    }

    /**
    * @description For one or more order summaries,
    *   find inventory availability using Omnichannel
    *   Inventory and identify the fulfillment routes
    *   with fewest splits. This method combines the
    *   functionality of the getInventoryAvailability()
    *   and findRoutesWithFewestSplits() methods
    * @param input Data used to calculate order fulfillment
    *   routes involving the fewest number of shipment splits,
    *   taking into account inventory availability
    * @return A list of order fulfillment routes with inventory
    *   availability information
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_Routing_static_methods.htm#apex_ConnectAPI_Routing_findRoutesWithFewestSplitsUsingOCI_1 
    */
    public ConnectApi.FindRoutesWithFewestSplitsUsingOCIOutputRepresentation findRoutesWithFewestSplitsUsingOCI(ConnectApi.FindRoutesWithFewestSplitsUsingOCIInputRepresentation input) {
        return ConnectApi.Routing.findRoutesWithFewestSplitsUsingOCI(input);
    }

    /**
    * @description Calculates the average distance from sets of
    *   inventory locations to an order recipient, and ranks them.
    *   Use this method to compare the average shipping distances
    *   for different sets of locations that can fulfill an order
    * @param input An order recipient’s geographic location and
    *   information about sets of inventory locations that can fulfill
    *   the order
    * @return The results of calculating the average distances from
    *   sets of inventory locations to an order recipient
    * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ConnectAPI_Routing_static_methods.htm#apex_ConnectAPI_Routing_rankAverageDistance_1
    */
    public ConnectApi.RankAverageDistanceOutputRepresentation rankAverageDistance(ConnectApi.RankAverageDistanceInputRepresentation input) {
        return ConnectApi.Routing.rankAverageDistance(input);
    }
}