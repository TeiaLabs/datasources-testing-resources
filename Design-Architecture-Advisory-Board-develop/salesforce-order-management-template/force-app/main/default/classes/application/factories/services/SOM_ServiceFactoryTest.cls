/**
* @description Service factory test class
*/
@isTest
private class SOM_ServiceFactoryTest {
    /**
    * @description ServiceFactory.newInstance
    *   Since it's factory, one instance is enough
    */
    @isTest
    static void shouldCreateNewInstance() {
        // OrderSummary
        Map<Type, Type> types = new Map<Type, Type>{ SOM_IOrderSummaryService.class => SOM_OrderSummaryService.class };
        SOM_ServiceFactory factory = new SOM_ServiceFactory(types);

        SOM_IOrderSummaryService service = (SOM_IOrderSummaryService)factory.newInstance(SOM_IOrderSummaryService.class);

        System.assert(service != null, 'A new instance could not created');
    }
}