/**
 * @description Cancel payment authorization - Model class to represent a notification
 */
@SuppressWarnings('PMD.ExcessivePublicCount')
public class SOM_CancelPaymentAuthNotification {
    public String live;
    public List<NotificationItems> notificationItems;

    /**
     * @description Additional data node of JSON
     */
    public class AdditionalData {
        public String hmacSignature;
        public String paymentMethodVariant;
        public String paymentLinkId;
        public String paypalPayerId;
        public String paypalEmail;
        public String paypalPayerStatus;
        public String paypalAddressStatus;
        public String paypalPayerResidenceCountry;
        public String paypalProtectionEligibility;
    }

    /**
     * @description Notification request item node of JSON
     */
    public class NotificationRequestItem {
        public AdditionalData additionalData;
        public String eventCode;
        public String success;
        public String merchantAccountCode;
        public String pspReference;
        public String merchantReference;
        public String originalReference;
        public String paymentMethod;
        public Amount amount;
    }

    /**
     * @description Amount node of JSON
     */
    public class Amount {
        public Integer value;
        /*
        reserved keywork cannot be used as key. If implementation needs the field, it will have to replace the key in the JSON string before deserilization and create the field here.
        */
        //public String currency;

        /**
         * @description Amount node constructor
         * @param value amount without decimal places (if currency accepts 2 decimal places, multiplied by 100)
         */
        public Amount(Integer value)
        {
            this.value = value;
        }
    }

    /**
     * @description Notification items node of JSON
     */
    public class NotificationItems {
        public NotificationRequestItem notificationRequestItem;

        /**
         * @description Notification Items Constructor
         * @param notificationRequestItem Notification Request Item
         */

        public NotificationItems(SOM_CancelPaymentAuthNotification.NotificationRequestItem notificationRequestItem)
        {
            this.notificationRequestItem = notificationRequestItem;
        }

    }

    /**
     * @description Create test data
     * @return SOM_CancelPaymentAuthNotification object
     */
    public static SOM_CancelPaymentAuthNotification createTestData() {
        return (SOM_CancelPaymentAuthNotification) JSON.deserialize(
           '{ "live": "false", '
         + ' "notificationItems": ['
         + '     {'
         + '         "NotificationRequestItem": {'
         + '             "additionalData": {'
         + '                 "hmacSignature": "13F2685E8EF860641457FF30BD0152AF5CEDD4ECF2CEC4F0AC77F6B1E5DF9F4F"'
         + '             },'
         + '             "eventCode": "CAPTURE",'
         + '             "success": "true",'
         + '             "merchantAccountCode": "OSFGlobalServices966ECOM",'
         + '             "pspReference": "C8J67TK44VTFWR82",'
         + '             "merchantReference": "OSF-25",'
         + '             "originalReference": "881615212840507A",'
         + '             "amount": {'
         + '                 "value": 29139,'
         + '                 "currency": "EUR"'
         + '             }'
         + '         }'
         + '     }'
         + ' ]'
         + '}', SOM_CancelPaymentAuthNotification.class);

    }
}
