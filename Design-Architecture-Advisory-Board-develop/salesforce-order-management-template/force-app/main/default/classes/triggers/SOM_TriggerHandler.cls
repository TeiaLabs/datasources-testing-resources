/**
* @description Trigger handler base class 
*   suppress reason: TODO REFACTOR REFACTOR
*/
@suppressWarnings('PMD.StdCyclomaticComplexity')
public with sharing virtual class SOM_TriggerHandler {
    Map<String, List<HandlerInterface>> eventHandlersMap = new Map<String, List<HandlerInterface>>();
    static Set<String> bypassedHandlers = new Set<String>();

    /**
    * @description Event types 
    */
    public enum Event {
        BEFORE_INSERT,
        BEFORE_UPDATE,
        BEFORE_DELETE,
        AFTER_INSERT,
        AFTER_UPDATE,
        AFTER_DELETE,
        AFTER_UNDELETE
    }

    /**
    * @description Interface for handler classes
    */
    public interface HandlerInterface {
        /**
        * @description Interface method for handler classes
        */
        void handle();
    }

    /**
    * @description Gets the executing handler name
    * @return Name of the handler
    */
    private String getTriggerHandlerName() {
        return String.valueOf(this).split(':')[0];
    }

    /**
    * @description Sets the trigger for bypass
    * @param handlerName Name of the handler to bypass
    */
    public static void bypassHandler(String handlerName) {
        bypassedHandlers.add(handlerName);
    }

    /**
    * @description Removes the trigger from bypass
    * @param handlerName Name of the handler to clear the bypass for
    */
    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }

    /**
    * @description Checks whether trigger is on bypass or not
    * @param handlerName Name of the handler to check whether it's bypassed
    * @return true if bypassed, false if not bypassed
    */
    public static Boolean isHandlerBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }

    /**
    * @description Binds handler interface for given event type
    * @param event Event type to match for
    * @param handler Handler interface to bind
    * @return TriggerHandler for the concrete class
    */
    public SOM_TriggerHandler bind(Event event, HandlerInterface handler) {
        List<HandlerInterface> handlers = eventHandlersMap.get(event.name());
        
        if (handlers == null) {
            handlers = new List<HandlerInterface>();
            eventHandlersMap.put(event.name(), handlers);
        }

        handlers.add(handler);
        return this;
    }

    /**
    * @description Manages to invoke the handle
    *   suppress reason: TODO REFACTOR REFACTOR
    */
    @suppressWarnings('PMD.CognitiveComplexity, PMD.CyclomaticComplexity')
    public void manage() {
        Event currentEvent = null;

        if (Trigger.isInsert && Trigger.isBefore) {
            currentEvent = Event.BEFORE_INSERT;
        } else if (Trigger.isInsert && Trigger.isAfter) {
            currentEvent = Event.AFTER_INSERT;
        } else if (Trigger.isUpdate && Trigger.isBefore) {
            currentEvent = Event.BEFORE_UPDATE;
        } else if (Trigger.isUpdate && Trigger.isAfter) {
            currentEvent = Event.AFTER_UPDATE;
        } else if (Trigger.isDelete && Trigger.isBefore) {
            currentEvent = Event.BEFORE_DELETE;
        } else if (Trigger.isDelete && Trigger.isAfter) {
            currentEvent = Event.AFTER_DELETE;
        } else if (Trigger.isUndelete) {
            currentEvent = Event.AFTER_UNDELETE;
        }

        List<HandlerInterface> handlers = eventHandlersMap.get(currentEvent.name());

        if (handlers != null && !handlers.isEmpty()) {
            for (HandlerInterface handler : handlers) {
                if (!SOM_TriggerHandler.isHandlerBypassed(this.getTriggerHandlerName())) {
                    handler.handle();
                }
            }
        }
    }
}