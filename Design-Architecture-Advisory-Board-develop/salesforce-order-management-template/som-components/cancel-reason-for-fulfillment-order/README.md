# Overview
The purpose of this component; forces users to set a cancel reason in case of Fulfillment Order Status Category is changed to Canceled.

The field for cancel reason should be available to user after validation rule outputs the error on the layout.

## Deployment Notes
### Sandbox
```
  sfdx force:source:deploy --sourcepath ./som-components/cancel-reason-for-fulfillment-order -u <org alias>
```
### Scratch Org
```
{
    "packageDirectories": [
      {
        "path": "force-app",
        "default": true
      },
      {
        "path": "som-components/cancel-reason-for-fulfillment-order"
      }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "55.0",
    "pushPackageDirectoriesSequentially": true
}
```

## Set permissions for the custom fields
- ```FulfillmentOrder.CancelReason__c```
