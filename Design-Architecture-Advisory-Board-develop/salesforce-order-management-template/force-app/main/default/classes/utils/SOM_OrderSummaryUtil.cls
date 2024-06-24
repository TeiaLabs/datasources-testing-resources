/**
* @description OrderSummary util class 
*/
public with sharing class SOM_OrderSummaryUtil {
    /**
    * @description Checks whether the order item is discountable
    * @param orderItemSummary OrderItemSummary
    * @return Discountable result
    */
    public static Boolean isOrderItemDiscountable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.Quantity != 0
            && orderItemSummary.QuantityReturnInitiated == orderItemSummary.QuantityReturned
            && orderItemSummary.QuantityAllocated == orderItemSummary.QuantityFulfilled
            && orderItemSummary.TotalAmtWithTax != 0;
    }

    /**
    * @description Checks whether the order item is cancelable
    * @param orderItemSummary OrderItemSummary
    * @return Cancelable result
    */
    public static Boolean isOrderItemCancelable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.QuantityAvailableToCancel > 0;
    }

    /**
    * @description Checks whether the order item is returnable
    * @param orderItemSummary OrderItemSummary
    * @return Returnable result
    */
    public static Boolean isOrderItemReturnable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.QuantityAvailableToReturn > 0;
    }

    /**
    * @description Gets discountable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getDiscountableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> discountableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemDiscountable = isOrderItemDiscountable(orderItemSummary);
            
            if (isOrderItemDiscountable) {
                discountableOrderItems.add(orderItemSummary);
            }
        }

        return discountableOrderItems;
    }

    /**
    * @description Gets cancelable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getCancelableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> cancelableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemCancelable = isOrderItemCancelable(orderItemSummary);
            
            if (isOrderItemCancelable) {
                cancelableOrderItems.add(orderItemSummary);
            }
        }

        return cancelableOrderItems;
    }

    /**
    * @description Gets returnable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getReturnableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> returnableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemReturnable = isOrderItemReturnable(orderItemSummary);
            
            if (isOrderItemReturnable) {
                returnableOrderItems.add(orderItemSummary);
            }
        }

        return returnableOrderItems;
    }
}