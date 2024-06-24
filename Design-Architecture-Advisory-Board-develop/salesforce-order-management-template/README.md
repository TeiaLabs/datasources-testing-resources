# Salesforce Order Management Template
SOM (Salesforce Order Management) StartUp Kit, which is extendable to any Salesforce Core project, is a boilerplate template which aims to reduce development time by using reusable modules, increasing and maintaining code quality by running static code analyzer and implementing best practices/principles.

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## ONE-CLICK READY FOR DEVELOPMENT
SOM StartUp Kit is compatible for both **scratch orgs** and **sandboxes** for development. If the development environment is configured for OM, SOM StartUp Kit can be deployed to the environment with Salesforce CLI commands. Scratch org configuration doesn’t require any additional steps since SOM StartUp Kit already has the necessary settings & options defined in the configuration file.

*Reduces effort and time for OM development environment configuration, creation of initial OMS records and test data records which will also make B2C Integration ready to be tested.*

## DATA READY
SOM StartUp Kit provides **Apex scripts** which those can be used to create initial (necessary) OMS records & test data (order and related records) in the development environment. Those initial OMS records can be used for **B2C Integration** as well.

_Reduces effort and time for preparing initial OMS records & test data for sandboxes and each scratch org._

## BUILT-IN FEATURES
SOM StartUp Kit provides a code base that covers most of the common processes. The code base can be extendable and reusable in the new projects regardless OM or not.

The built-in features are:
- Util classes for Http callouts, exception management & logging, parsing (XML, CSV), pre defined Enums
- Selector & Service layers
- Test Data Factory
- Batch & Trigger base classes
- Salesforce Order Management APIs
- Apex Scripts
- Retry mechanism for Http requests
- GitHub CI/CD pipeline actions
- Allow Users to Retry Ensure Funds/Refunds
- Purge Old OMS Data and OMS Logs Batches
- Retry Jobs for Payment Capture

_This reduces significant development time for base/infrastructure code, provides code base standardization and high code coverage by unit tests with no PMD violations._

## REUSABLE INDEPENDENT COMPONENTS
Besides the base code SOM StartUp Kit provides, components can be installed on top of the project, if needed. Those components have no dependency with the base code therefore they are totally independent and developed for reusability.

The components are:
- Cancel Reason for Fulfillment Order - Component forces user to set a cancel reason in case of Fulfillment Order Status Category is changed to Canceled
- Reject Fulfillment Order Partially - Component allows users to handle fully/partial reject for Fulfillment Order items with a reject reason
- Process Exception Notification & Configuration - Component allows users to create configuration for Process Exception notification based on Sales Channel and notification type (Chatter, Email, Custom Notification), Status and so on
- Cancel Payment Authorization - Component allows payment authorization cancellation once the status of the Order Summary is changed to cancelled

![image](https://user-images.githubusercontent.com/15785611/193037203-791841d0-e609-444d-b912-d1f8f4697be6.png)
