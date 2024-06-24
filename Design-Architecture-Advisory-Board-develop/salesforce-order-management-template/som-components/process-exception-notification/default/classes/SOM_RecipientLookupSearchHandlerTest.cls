/** 
 * @description  : SOM_RecipientLookupSearchHandler Test class
*/
@isTest
public with sharing class SOM_RecipientLookupSearchHandlerTest {
    /**
    * @description Tests getIdAndNameOfItems method of SOM_RecipientLookupSearchHandler class
    */
    @isTest
    static void shouldGetIdAndNameOfItems() {
        SalesChannel testSalesChannel = new SalesChannel(SalesChannelName='testChannel');
        insert testSalesChannel;

        Test.startTest();
        List<SalesChannel> selectedSalesChannels = SOM_RecipientLookupSearchHandler.getIdAndNameOfItems('SalesChannel', 'SalesChannelName', '');
        Test.stopTest();
        
        System.assert(!selectedSalesChannels.isEmpty(), 'No Sales Channel record(s) found');
    }

    /**
    * @description Tests getIdAndNameOfItems method of SOM_RecipientLookupSearchHandler class with null whereClause
    */
    @isTest
    static void shouldGetIdAndNameOfItemsWithNullWhereClause() {
        SalesChannel testSalesChannel = new SalesChannel(SalesChannelName='testChannel');
        insert testSalesChannel;

        Test.startTest();
        List<SalesChannel> selectedSalesChannels = SOM_RecipientLookupSearchHandler.getIdAndNameOfItems('SalesChannel', 'SalesChannelName', null);
        Test.stopTest();
        
        System.assert(!selectedSalesChannels.isEmpty(), 'No Sales Channel record(s) found');
    }

    /**
    * @description Tests getSelectedObjectLabelsAndIcons method of SOM_RecipientLookupSearchHandler class
    */
    @isTest
    static void shouldGetSelectedObjectLabelsAndIcons() {
        SalesChannel testSalesChannel = new SalesChannel(SalesChannelName='testChannel');
        String salesChannelId = Database.insert(new List<SalesChannel>{testSalesChannel})[0].Id;
        SOM_RecipientLookupSearchHandler.ItemTypeWrapper salesChannelType = new SOM_RecipientLookupSearchHandler.ItemTypeWrapper();
        salesChannelType.label = 'SalesChannel';
        salesChannelType.value = 'SalesChannel';
        salesChannelType.labelApiName = 'SalesChannelName';
        String stringifiedItemTypes = JSON.serialize(new List<SOM_RecipientLookupSearchHandler.ItemTypeWrapper>{salesChannelType});
        Test.startTest();
        String stringifiedItemWrappers = SOM_RecipientLookupSearchHandler.getSelectedObjectLabelsAndIcons(new List<String>{salesChannelId}, stringifiedItemTypes);
        Test.stopTest();
        
        List<SOM_RecipientLookupSearchHandler.ItemWrapper> itemWrappers = (List<SOM_RecipientLookupSearchHandler.ItemWrapper>) JSON.deserialize(stringifiedItemWrappers, List<SOM_RecipientLookupSearchHandler.ItemWrapper>.class);
        System.assert(!itemWrappers.isEmpty(), 'No Sales Channel record(s) found');
    }
}
