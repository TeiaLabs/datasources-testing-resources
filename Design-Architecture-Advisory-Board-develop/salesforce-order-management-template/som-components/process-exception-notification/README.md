# Overview
The purpose of this component is to notify users by sending emails, posting to Chatter or sending custom notifications when a process exception is created. Configuration UI allows users to create configurations (for triggering the notification) based on sales channel, recipients (user, role, public group), process exception category, severity and status.

> **⚠ WARNING:**  
> For orgs which are not in English, the developer for that project will need to go to the flow and change the value of finalStatus variable to the status value in the corresponding language.

### Sandbox
```
  sfdx force:source:deploy --sourcepath ./som-components/process-exception-notification -u <org alias>
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
        "path": "som-components/process-exception-notification"
      }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "55.0",
    "pushPackageDirectoriesSequentially": true
}
```
## Set permissions for the custom fields
To do this step, get the user name from the org and run the following command:

```
sfdx force:user:permset:assign --permsetname SOM_Startup_Kit_Process_Exception_Notifications --targetusername <user/alias>
```
