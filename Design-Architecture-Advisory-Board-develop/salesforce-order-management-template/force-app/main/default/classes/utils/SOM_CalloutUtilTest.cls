/**
* @description CalloutUtil test class
*/
@isTest
private class SOM_CalloutUtilTest {
    
    /**
    * @description Test method of CalloutUtil.createRequestLog
    */
    @isTest(SeeAllData=true)
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    static void shouldCreateRequestLog() {
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = SOM_CalloutUtil.doCallout('.com/api/orders', SOM_Constants.POST, headers, '{ "go": true }');
        Id logId = SOM_CalloutUtil.insertHttpLogs()[0].getId();
        Test.stopTest();

        // Get response header
		List<String> headerKeys = response.getHeaderKeys();
		Map<String, String> responseHeaders = new Map<String, String>();
		for (String headerKey : headerKeys) {
			responseHeaders.put(headerKey, response.getHeader(headerKey));
		}

        SOM_HttpLog__c httpLog = [SELECT Endpoint__c, Method__c, RequestHeader__c, RequestBody__c, ResponseHeader__c, ResponseBody__c FROM SOM_HttpLog__c WHERE Id =: logId];
        
        System.assertEquals('.com/api/orders', httpLog.Endpoint__c, 'Endpoint of log does not match');
        System.assertEquals(SOM_Constants.POST, httpLog.Method__c, 'Method of log does not match');
        System.assertEquals(JSON.serialize(headers), httpLog.RequestHeader__c, 'Request field of log does not match');
        System.assertEquals('{ "go": true }', httpLog.RequestBody__c, 'Request Body of log does not match');
        System.assertEquals(response.getBody(), httpLog.ResponseBody__c, 'Response Body of log does not match');
        System.assertEquals(JSON.serialize(responseHeaders), httpLog.ResponseHeader__c, 'Request Body of log does not match');
    }

    /**
    * @description Test method of CalloutUtil.doCallout (positive)
    */
    @isTest
    static void shouldSuccessCallout() {
        Test.setMock(HttpCalloutMock.class, new SOM_RestSuccessMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = SOM_CalloutUtil.doCallout('.com/api/orders', SOM_Constants.POST, headers, '{ "go": true }');
        Test.stopTest();

        System.assert(response.getStatusCode() == 200, 'Http status code of the response should 200 OK');
    }

    /**
    * @description Test method of CalloutUtil.doCallout (negative)
    */
    @isTest
    static void shouldFailCallout() {
        Test.setMock(HttpCalloutMock.class, new SOM_RestFailMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = SOM_CalloutUtil.doCallout('.com/api/orders', SOM_Constants.POST, headers, '{ "go": true }');
        Test.stopTest();

        System.assert(response.getStatusCode() == 500, 'Http status code of the response should 500');
    }
}