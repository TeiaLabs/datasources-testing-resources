/**
* @description FailedRequestSelector test class
*/
@isTest
private class SOM_FailedRequestSelectorTest {
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldselectByAvaibilityOfRetryAndStatus() {
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name='Test Request', RetryAttempts__c = 10, RetryAttemptLimit__c = 12);
        insert failedRequest;

        Test.startTest();
        List<SOM_FailedRequest__c> failedRequests = new SOM_FailedRequestSelector().selectByAvaibilityOfRetryAndStatus(false, 'NOT STARTED', 200);
        Test.stopTest();

        System.assert(!failedRequests.isEmpty(), 'No failed requests found');
    }
}
