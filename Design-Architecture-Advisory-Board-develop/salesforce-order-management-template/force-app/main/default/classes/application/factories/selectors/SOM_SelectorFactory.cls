/**
* @description Factory class for selectors
*/
public virtual class SOM_SelectorFactory {
    protected Map<Type, Type> selectorInterfaceTypeToSelectorTypeMap;

    /**
    * @description Constructor
    * @param selectorInterfaceTypeToSelectorTypeMap Map of interface type to selector type
    */
    public SOM_SelectorFactory(Map<Type, Type> selectorInterfaceTypeToSelectorTypeMap) {
        this.selectorInterfaceTypeToSelectorTypeMap = selectorInterfaceTypeToSelectorTypeMap;
    }

    /**
    * @description Creates a new instance of selector by the type
    * @param selectorInterfaceType Type of the selector interface
    * @return Selector instance
    */
    public virtual Object newInstance(Type selectorInterfaceType) {
        // get the type of the selector from the map passed into constructor
        Type selectorType = selectorInterfaceTypeToSelectorTypeMap.get(selectorInterfaceType);

        if (selectorType == null) {
            throw new SOM_ApplicationException('No implementation registered for the selector interface ' + selectorInterfaceType.getName());
        }

        return selectorType.newInstance();
    }
}