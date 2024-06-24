# Salesforce Order Management Template Features & Components

Use `master` branch for the stable version.

## Features
Besides the code base, there are built-in features in the project ready to be deployed & used.

_(Those features are added after after official start of the project)_

- #### Allow Users to Retry Ensure Funds
Allowing the front end user to capture any remaining amount from an Invoice which was not possible.
- #### Clear OMS Old Logs
Scheduled flow `SOM_ClearOldLogs` removes `OMS Logs` older than 30 days, every week. Both the date and schedule frequency are initial values. _(Only for development stage)_
- #### BatchApexErrorEvent Implementation for Logs
Notifies subscribers of errors and exceptions that occur during the execution of a batch Apex class. A record-triggered flow is subscribed to that event and creates SOM Log.
- #### Log Http Requests & Responses
Logging mechanism to log each HTTP request and response within its details. Implemented into `CalloutUtil` Apex class because it is centralized place for callouts.
- #### Http Retry Logic
Generic retry mechanism/logic that is covering failing integrations automatically instead of running jobs especially for the failed records.
- #### Purge Old OMS Data
Component includes a batch job which will delete old OMS data in a ***DEVELOPMENT*** environment to reduce the size of the org

## Components
The components are part of the project but won't be deployed until necessary steps are done.

See `readMe` inside component folder for more information.
- [cancel-reason-for-fulfillment-order](https://github.com/OSFDigital/Design-Architecture-Advisory-Board/blob/develop/salesforce-order-management-template/som-components/cancel-reason-for-fulfillment-order/README.md)
- [reject-fulfillment-order-partially](https://github.com/OSFDigital/Design-Architecture-Advisory-Board/blob/develop/salesforce-order-management-template/som-components/reject-fulfillment-order-partially/README.md)
- [process-exception-triggered-flow](https://github.com/OSFDigital/Design-Architecture-Advisory-Board/blob/develop/salesforce-order-management-template/som-components/process-exception-triggered-flow/README.md)

# Salesforce Order Management Template Prerequisites

## Grant permissions for custom fields
- `Invoice.NumberOfRetries__c`
- `Refund.CreditMemoId__c`
- `SOM_FailedRequest__c.Data__c`
- `SOM_FailedRequest__c.IsRetryAttemptLimitReached__c`
- `SOM_FailedRequest__c.RegenerateDataParameter__c`
- `SOM_FailedRequest__c.RegenerateData__c`
- `SOM_FailedRequest__c.RetryAttemptLimit__c`
- `SOM_FailedRequest__c.RetryAttempts__c`
- `SOM_FailedRequest__c.Status__c`
- `SOM_Log__c.AttachedToId__c`
- `SOM_Log__c.Category__c`
- `SOM_Log__c.IsError__c`
- `SOM_Log__c.Message__c`

## Enable Tab Settings
- `SOM_Log__c`
- `SOM_HttpLog__c`
- `SOM_FailedRequest__c`

To apply these permissions and tab settings you can execute the following command to assign the permission set to the user:
```
sfdx force:user:permset:assign --permsetname SOM_Startup_Kit_Customizations --targetusername <user/alias>
```

## Assign page layouts
- `CreditMemo`
- `Invoice`

## Known Issues
- Add `Manual Intervention Required` status to `ProcessException.Status` with `Active` StatusCategory

_(Salesforce issue: No StatusCategory support for ProcessException)_
- Add `Manual Intervention Alerted` status to `ProcessException.Status` with `Active` StatusCategory

_(Salesforce issue: No StatusCategory support for ProcessException)_
