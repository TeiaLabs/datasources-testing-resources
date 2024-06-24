/**
* @description Test class of BatchJobHandler
*/
@isTest
private class SOM_BatchJobHandlerTest {
    /**
    * @description Test method of BatchJobHandler constructor 
    */
    @isTest
    static void shouldSetConfigurationValues() {
        SOM_BatchJobHandler handler = new SOM_BatchJobHandler('');
        Integer batchSize = handler.batchSize;

        handler.sendSuccessEmail();
        handler.sendErrorEmail('Error message');
        System.assert(batchSize > 0, 'Batch size should be greater than zero');
    }

    /**
    * @description Test method of BatchJobHandler.sendSuccessEmail 
    */
    @isTest
    static void shouldSendSuccessEmail() {
        SOM_BatchJobHandler handler = new SOM_BatchJobHandler('');

        List<Messaging.SendEmailResult> sendEmailResult = handler.sendSuccessEmail();
        System.assert(sendEmailResult[0].isSuccess(), 'Send email result should be success');
    }

    /**
    * @description Test method of BatchJobHandler.sendErrorEmail 
    */
    @isTest
    static void shouldSendErrorEmail() {
        SOM_BatchJobHandler handler = new SOM_BatchJobHandler('');

        List<Messaging.SendEmailResult> sendEmailResult = handler.sendErrorEmail('Error message');
        System.assert(sendEmailResult[0].isSuccess(), 'Send email result should be success');
    }
}