# Overview
Salesforce doesn't offer a core action to cancel authorization, which shoppers usually wish for when orders are cancelled.
Considering there are a multitude of payment gateways, this would require a handler to check order payment summaries and respective payment authorizations to get the payment gateway and to match it against a record in a new custom metadata type to get the API credentials.
In terms of API requests, 1 or 2 (get bearer token and request to void authorization) will be required per payment gateway. 
A retry job for failed requests is also provided.

## Deployment Notes
### Sandbox
```
  sfdx force:source:deploy --sourcepath ./som-components/cancel-payment-authorization -u <org alias>
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
        "path": "som-components/cancel-payment-authorization"
      }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "55.0",
    "pushPackageDirectoriesSequentially": true
}
```

## Set permissions for the custom fields
- ```OrderSummary.CancelAuthorizationRetryAttempts__c```
- ```OrderSummary.CancelAuthorizationStatus__c```
To do this step, get the user name from the org and run the following command:
```
sfdx force:user:permset:assign --permsetname SOM_Authorization_Cancel --targetusername <user/alias>
```
