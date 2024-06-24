/**
* @description PaymentSelector test class
*/
@isTest
public with sharing class SOM_PaymentSelectorTest {
    /**
    * @description Test method of PaymentSelector.selectByIds
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSelectByIds() {
        SOM_TestDataFactory.createOrderAction();
        SOM_TestDataInput.PaymentInput paymentInput = new SOM_TestDataInput.PaymentInput();
        paymentInput.status = SOM_PaymentStatus.PROCESSED.enumValue;
        paymentInput.type = SOM_PaymentType.CAPTURE.enumValue;
        paymentInput.amount = 2;
        Payment payment = SOM_TestDataFactory.createPayment(paymentInput);
        insert payment;
        Test.startTest();
        List<Payment> payments = new SOM_PaymentSelector().selectByIds(new List<String>{ payment.Id });
        Test.stopTest();
        Set<Id> resultIds = (new Map<Id,SObject>(payments)).keySet();
        System.assert(resultIds.contains(payment.Id), 'No payment record(s) found');
    }
}
