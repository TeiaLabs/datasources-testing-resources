/**
* @description Email util class
*/
public with sharing class SOM_EmailUtil {
    /**
    * @description Sends email
    * @param emailAddresses Email address list
    * @param subject Email subject
    * @param body Email body (plaint text or html)
    * @param isHtml Is email body HTML
    * @return Send email result list
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public static Messaging.SendEmailResult[] sendEmail(String[] emailAddresses, String subject, String body, Boolean isHtml) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailAddresses);
        mail.setSubject(subject);
        
        if(isHtml) {
            mail.setHtmlBody(body);
        }
        else {
            mail.setPlainTextBody(body);
        }

        return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
    }

    /**
    * @description Sends email
    * @param emailAddresses Email address list
    * @param subject Email subject
    * @param body Email body (plaint text or html)
    * @param attachments Attachments
    * @param isHtml Is email body HTML
    * @return Send email result list
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public static Messaging.SendEmailResult[] sendEmail(String[] emailAddresses, String subject, String body, Messaging.EmailFileAttachment[] attachments, Boolean isHtml) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailAddresses);
        mail.setSubject(subject);

        if(isHtml) {
            mail.setHtmlBody(body);
        }
        else {
            mail.setPlainTextBody(body);
        }

        if (attachments != null && !attachments.isEmpty()) {
            mail.setFileAttachments(attachments);
        }

        return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
    }
}