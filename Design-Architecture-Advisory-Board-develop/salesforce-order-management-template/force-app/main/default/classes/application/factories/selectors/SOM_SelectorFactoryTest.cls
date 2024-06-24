/**
* @description Selector factory test class
*/
@isTest
private class SOM_SelectorFactoryTest {
    /**
    * @description SelectorFactory.newInstance 
    */
    @isTest
    static void shouldCreateNewInstance() {
        // OrderSummary
        Map<Type, Type> types = new Map<Type, Type>{ SOM_IOrderSummarySelector.class => SOM_OrderSummarySelector.class };
        SOM_SelectorFactory factory = new SOM_SelectorFactory(types);

        SOM_IOrderSummarySelector selector = (SOM_IOrderSummarySelector)factory.newInstance(SOM_IOrderSummarySelector.class);

        System.assert(selector != null, 'A new instance could not created');
    }
}