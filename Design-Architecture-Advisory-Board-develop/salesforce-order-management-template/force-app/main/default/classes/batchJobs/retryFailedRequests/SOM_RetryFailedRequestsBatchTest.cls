/**
 * @description Test class of retry fail batch request handler
 */
@isTest
private class SOM_RetryFailedRequestsBatchTest {
    /**
    * @description Dummy handler class for testing
    */
    public class DummyHandler extends SOM_AbstractRequest {
        public override void  auth() {
            return;
        }
        public override Map<String, String>  createHeaders() {
            Map<String, String> headers = new Map<String, String>();
            headers.put(SOM_Constants.CONTENT_TYPE, SOM_Constants.APPLICATION_JSON);
            return headers;
        }
        public override String createRequestBody(List<Id> idList) {
            String serializedRequestBody = JSON.serialize(idList);
            return serializedRequestBody;
        }
        public override String createEndpoint() {
            return 'DummyEndPoint';
        }
        public override String createMethod() {
            return SOM_Constants.POST;
        }

        public override Boolean handleResponse(HttpResponse response) {
            return response.getStatusCode() == SOM_Constants.HTTP_SUCCESS_CODE ? true : false;
        }
    }

    /**
    * @description Tests SOM_RetryFailedRequestsBatch class and process method of SOM_AbstractRequest which takes SOM_FailedRequest__c parameter
        for the case which the number of attempts is equal to Retry Attempt Limit
    */
    @isTest
    static void testNumberOfAttemptsIsEqualToRetryLimit() {
        // Create failedRequest
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler', Data__c = '{"title": "foo","body": "bar", "userId": "1"}', RetryAttempts__c = 10, RetryAttemptLimit__c = 10);
        insert failedRequest;
        // Execute Batch
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock()); 
        Test.startTest();
        SOM_RetryFailedRequestsBatch retryFailedRequestBatch = new SOM_RetryFailedRequestsBatch('RetryFailedRequest');
        retryFailedRequestBatch.execute(null);
        Test.stopTest();
        List<SOM_FailedRequest__c> failedRequests = [SELECT RetryAttempts__c FROM SOM_FailedRequest__c WHERE Id =: failedRequest.Id];
        System.assertEquals(1, failedRequests.size(), 'HTTP Request should not be retried'); 
    }

    /**
    * @description Tests SOM_RetryFailedRequestsBatch class and process method of SOM_AbstractRequest which takes SOM_FailedRequest__c parameter
        for the case which the number of attempts is less than Retry Attempt Limit
    */
    @isTest
    static void testNumberOfAttemptsIsLessThanRetryLimit() {
        // Create failedRequest
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler', Data__c = '{"title": "foo","body": "bar", "userId": "1"}', RetryAttempts__c = 9, RetryAttemptLimit__c = 10);
        insert failedRequest;
        // Execute Batch
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        Test.startTest();
        SOM_RetryFailedRequestsBatch retryFailedRequestBatch = new SOM_RetryFailedRequestsBatch('RetryFailedRequest');
        retryFailedRequestBatch.execute(null);
        Test.stopTest();
        List<SOM_FailedRequest__c> failedRequests = [SELECT RetryAttempts__c FROM SOM_FailedRequest__c WHERE Id =: failedRequest.Id];
        System.assertEquals(0, failedRequests.size(), 'HTTP Request should be retried');
    }

    /**
    * @description Tests SOM_RetryFailedRequestsBatch class and process method of SOM_AbstractRequest which takes SOM_FailedRequest__c parameter
        for the case which the retried request is successful by sending with the same data
    */
    @isTest
    static void testRetryingWithSameDataSuccessfulRequest() {
        // Create failedRequest
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler', Data__c = '{"title": "foo","body": "bar", "userId": "1"}');
        insert failedRequest;
        // Execute Batch
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        Test.startTest();
        SOM_RetryFailedRequestsBatch retryFailedRequestBatch = new SOM_RetryFailedRequestsBatch('RetryFailedRequest');
        retryFailedRequestBatch.execute(null);
        Test.stopTest();
        List<SOM_FailedRequest__c> failedRequests = [SELECT RetryAttempts__c FROM SOM_FailedRequest__c WHERE Id =: failedRequest.Id];
        System.assertEquals(0, failedRequests.size(), 'Succesfully retried failedRequest should be deleted');
    }

    /**
    * @description Tests SOM_RetryFailedRequestsBatch class and process method of SOM_AbstractRequest which takes SOM_FailedRequest__c parameter
        for the case which the retried request failed by sending with the same data
    */
    @isTest
    static void testRetryingWithSameDataFailedRequest() {
        // Create failedRequest false, 
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler');
        insert failedRequest;
        // Execute Batch
        Test.setMock(HttpCalloutMock.class, new SOM_RestFailMock());
        Test.startTest();
        SOM_RetryFailedRequestsBatch retryFailedRequestBatch = new SOM_RetryFailedRequestsBatch('RetryFailedRequest');
        retryFailedRequestBatch.execute(null);
        Test.stopTest();
        SOM_FailedRequest__c failedRequestUpdated = [SELECT RetryAttempts__c FROM SOM_FailedRequest__c WHERE id =: failedRequest.Id];
        System.assertEquals(1, failedRequestUpdated.RetryAttempts__c, 'RetryAttempts should be incremented');
    }

    /**
    * @description Tests SOM_RetryFailedRequestsBatch class and process method of SOM_AbstractRequest which takes SOM_FailedRequest__c parameter
        for the case which the retried request failed by sending with the same data
    */
    @isTest
    static void testRegeneratingDataSuccessfulRequest() {
        // Create failedRequest
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler', RegenerateDataParameter__c = '[]', RegenerateData__c = true);
        insert failedRequest;
        // Execute Batch
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        Test.startTest();
        SOM_RetryFailedRequestsBatch retryFailedRequestBatch = new SOM_RetryFailedRequestsBatch('RetryFailedRequest');
        retryFailedRequestBatch.execute(null);
        Test.stopTest();
        List<SOM_FailedRequest__c> failedRequests = [SELECT RetryAttempts__c FROM SOM_FailedRequest__c WHERE Id =: failedRequest.Id];
        System.assertEquals(0, failedRequests.size(), 'Succesfully retried failedRequest should be deleted');
    }

    /**
    * @description Tests Overloaded process method of SOM_AbstractRequest which takes list of Id as parameter
    */
    @isTest
    static void testOverloadedProcessMethod() {
        // Create failedRequest
        SOM_FailedRequest__c failedRequest = new SOM_FailedRequest__c(Name = 'SOM_RetryFailedRequestsBatchTest.DummyHandler', RegenerateDataParameter__c = '[]', RegenerateData__c = true);
        insert failedRequest;
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());
        Test.startTest();
        DummyHandler handler = new DummyHandler();
        HttpResponse result = handler.process(new List<Id>{failedRequest.Id});
        Test.stopTest();
        System.assertEquals(SOM_Constants.HTTP_SUCCESS_CODE, result.getStatusCode(), 'Request body should not be null');
    }
}
