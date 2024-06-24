import { LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import SOM_Cancel from '@salesforce/label/c.SOM_Cancel';
import SOM_SaveAs from '@salesforce/label/c.SOM_SaveAs';
import SOM_Save from '@salesforce/label/c.SOM_Save';
import SOM_Close from '@salesforce/label/c.SOM_Close';
import SOM_PEConfigurationNameLabel from '@salesforce/label/c.SOM_PEConfigurationNameLabel';
import SOM_PEConfigurationsComboboxLabel from '@salesforce/label/c.SOM_PEConfigurationsComboboxLabel';
import SOM_PEConfigurationsComboboxPlaceHolder from '@salesforce/label/c.SOM_PEConfigurationsComboboxPlaceHolder';
import SOM_NoProcessExceptionRecordTypeMessage from '@salesforce/label/c.SOM_NoProcessExceptionRecordTypeMessage';
import SOM_NoProcessExceptionSeverityValuesMessage from '@salesforce/label/c.SOM_NoProcessExceptionSeverityValuesMessage';
import SOM_NoProcessExceptionStatusValuesMessage from '@salesforce/label/c.SOM_NoProcessExceptionStatusValuesMessage';
import SOM_NoProcessExceptionCategoryValuesMessage from '@salesforce/label/c.SOM_NoProcessExceptionCategoryValuesMessage';
import SOM_CurrentConfigurationNotReceivedErrorMessage from '@salesforce/label/c.SOM_CurrentConfigurationNotReceivedErrorMessage';
import SOM_RecordCreationErrorTitle from '@salesforce/label/c.SOM_RecordCreationErrorTitle';
import SOM_RecordUpdationErrorTitle from '@salesforce/label/c.SOM_RecordUpdationErrorTitle';
import SOM_PEConfigurationNoRecipientErrorMessage from '@salesforce/label/c.SOM_PEConfigurationNoRecipientErrorMessage';
import SOM_PEConfigurationAlreadyExistErrorMessage from '@salesforce/label/c.SOM_PEConfigurationAlreadyExistErrorMessage';
import SOM_PEConfigurationNoRecipientLabelsErrorMessage from '@salesforce/label/c.SOM_PEConfigurationNoRecipientLabelsErrorMessage';
import SOM_PEConfigurationInvalidPicklistValuesErrorMessage from '@salesforce/label/c.SOM_PEConfigurationInvalidPicklistValuesErrorMessage';
import SOM_PERecordCreatedMessage from '@salesforce/label/c.SOM_PERecordCreatedMessage';
import SOM_PERecordUpdatedMessage from '@salesforce/label/c.SOM_PERecordUpdatedMessage';
import SOM_UnknownErrorMessage from '@salesforce/label/c.SOM_UnknownErrorMessage';
import SOM_ChatterConfigurationCardTitle from '@salesforce/label/c.SOM_ChatterConfigurationCardTitle';
import SOM_ChatterConfigurationMessageLabel from '@salesforce/label/c.SOM_ChatterConfigurationMessageLabel';
import SOM_ChatterConfigurationMessagePlaceHolder from '@salesforce/label/c.SOM_ChatterConfigurationMessagePlaceHolder';
import SOM_ChatterConfigurationPostOptionsLabel from '@salesforce/label/c.SOM_ChatterConfigurationPostOptionsLabel';
import SOM_ChatterConfigurationPostToRelatedFalseOptionLabel from '@salesforce/label/c.SOM_ChatterConfigurationPostToRelatedFalseOptionLabel';
import SOM_ChatterConfigurationPostToRelatedTrueOptionLabel from '@salesforce/label/c.SOM_ChatterConfigurationPostToRelatedTrueOptionLabel';
import SOM_CustomNotificationConfigurationMessageLabel from '@salesforce/label/c.SOM_CustomNotificationConfigurationMessageLabel';
import SOM_CustomNotificationConfigurationNotificationTypeLabel from '@salesforce/label/c.SOM_CustomNotificationConfigurationNotificationTypeLabel';
import SOM_CustomNotificationConfigurationNotificationTypePlaceHolder from '@salesforce/label/c.SOM_CustomNotificationConfigurationNotificationTypePlaceHolder';
import SOM_CustomNotificationConfigurationTitleLabel from '@salesforce/label/c.SOM_CustomNotificationConfigurationTitleLabel';
import SOM_CustomNotificationConfigurationCardTitle from '@salesforce/label/c.SOM_CustomNotificationConfigurationCardTitle';
import SOM_EmailConfigurationBodyLabel from '@salesforce/label/c.SOM_EmailConfigurationBodyLabel';
import SOM_EmailConfigurationCardTitle from '@salesforce/label/c.SOM_EmailConfigurationCardTitle';
import SOM_EmailConfigurationSubjectLabel from '@salesforce/label/c.SOM_EmailConfigurationSubjectLabel';
import SOM_NoPEConfigurationOptionsMessage from '@salesforce/label/c.SOM_NoPEConfigurationOptionsMessage';
import SOM_SalesChannelsNotReceivedErrorMessage from '@salesforce/label/c.SOM_SalesChannelsNotReceivedErrorMessage';
import SOM_RecipientSearchInputRecordTypeLabel from '@salesforce/label/c.SOM_RecipientSearchInputRecordTypeLabel';
import SOM_RecipientSearchInputRecordsLabel from '@salesforce/label/c.SOM_RecipientSearchInputRecordsLabel';
import SOM_StatefulButtonTitle from '@salesforce/label/c.SOM_StatefulButtonTitle';
import SOM_ConfigurationNameMustBeUnique from '@salesforce/label/c.SOM_ConfigurationNameMustBeUnique';


const getCustomLabels = () => { 
    return {
        SOM_ConfigurationNameMustBeUnique: SOM_ConfigurationNameMustBeUnique,
        SOM_Cancel: SOM_Cancel,
        SOM_SaveAs: SOM_SaveAs,
        SOM_Save: SOM_Save,
        SOM_Close: SOM_Close,
        SOM_PEConfigurationNameLabel: SOM_PEConfigurationNameLabel,
        SOM_PEConfigurationsComboboxLabel: SOM_PEConfigurationsComboboxLabel,
        SOM_PEConfigurationsComboboxPlaceHolder: SOM_PEConfigurationsComboboxPlaceHolder,
        SOM_NoProcessExceptionRecordTypeMessage: SOM_NoProcessExceptionRecordTypeMessage,
        SOM_NoProcessExceptionSeverityValuesMessage: SOM_NoProcessExceptionSeverityValuesMessage,
        SOM_NoProcessExceptionStatusValuesMessage: SOM_NoProcessExceptionStatusValuesMessage,
        SOM_NoProcessExceptionCategoryValuesMessage: SOM_NoProcessExceptionCategoryValuesMessage,
        SOM_CurrentConfigurationNotReceivedErrorMessage: SOM_CurrentConfigurationNotReceivedErrorMessage,
        SOM_RecordCreationErrorTitle: SOM_RecordCreationErrorTitle,
        SOM_RecordUpdationErrorTitle: SOM_RecordUpdationErrorTitle,
        SOM_PEConfigurationNoRecipientErrorMessage: SOM_PEConfigurationNoRecipientErrorMessage,
        SOM_PEConfigurationAlreadyExistErrorMessage: SOM_PEConfigurationAlreadyExistErrorMessage,
        SOM_PEConfigurationNoRecipientLabelsErrorMessage: SOM_PEConfigurationNoRecipientLabelsErrorMessage,
        SOM_PEConfigurationInvalidPicklistValuesErrorMessage: SOM_PEConfigurationInvalidPicklistValuesErrorMessage,
        SOM_PERecordCreatedMessage: SOM_PERecordCreatedMessage,
        SOM_PERecordUpdatedMessage: SOM_PERecordUpdatedMessage,
        SOM_UnknownErrorMessage: SOM_UnknownErrorMessage,
        SOM_ChatterConfigurationCardTitle: SOM_ChatterConfigurationCardTitle,
        SOM_ChatterConfigurationMessageLabel: SOM_ChatterConfigurationMessageLabel,
        SOM_ChatterConfigurationMessagePlaceHolder: SOM_ChatterConfigurationMessagePlaceHolder,
        SOM_ChatterConfigurationPostOptionsLabel: SOM_ChatterConfigurationPostOptionsLabel,
        SOM_ChatterConfigurationPostToRelatedFalseOptionLabel: SOM_ChatterConfigurationPostToRelatedFalseOptionLabel,
        SOM_ChatterConfigurationPostToRelatedTrueOptionLabel: SOM_ChatterConfigurationPostToRelatedTrueOptionLabel,
        SOM_CustomNotificationConfigurationMessageLabel: SOM_CustomNotificationConfigurationMessageLabel,
        SOM_CustomNotificationConfigurationNotificationTypeLabel: SOM_CustomNotificationConfigurationNotificationTypeLabel,
        SOM_CustomNotificationConfigurationNotificationTypePlaceHolder: SOM_CustomNotificationConfigurationNotificationTypePlaceHolder,
        SOM_CustomNotificationConfigurationTitleLabel: SOM_CustomNotificationConfigurationTitleLabel,
        SOM_CustomNotificationConfigurationCardTitle: SOM_CustomNotificationConfigurationCardTitle,
        SOM_EmailConfigurationBodyLabel: SOM_EmailConfigurationBodyLabel,
        SOM_EmailConfigurationCardTitle: SOM_EmailConfigurationCardTitle,
        SOM_EmailConfigurationSubjectLabel: SOM_EmailConfigurationSubjectLabel,
        SOM_NoPEConfigurationOptionsMessage: SOM_NoPEConfigurationOptionsMessage,
        SOM_SalesChannelsNotReceivedErrorMessage: SOM_SalesChannelsNotReceivedErrorMessage,
        SOM_RecipientSearchInputRecordTypeLabel: SOM_RecipientSearchInputRecordTypeLabel,
        SOM_RecipientSearchInputRecordsLabel: SOM_RecipientSearchInputRecordsLabel,
        SOM_StatefulButtonTitle: SOM_StatefulButtonTitle
    };
}

const showToast = (title, message, variant, mode) => {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: mode
    });
    return event;
}

const showToastForWireError = (error, title) => {
    let errorMessage = SOM_UnknownErrorMessage;
    if (Array.isArray(error.body)) {
        errorMessage = error.body.map(e => e.message).join(', ');
    } else if (typeof error.body.message === 'string') {
        errorMessage = error.body.message;
    }
    return showToast(title, errorMessage, 'error', 'dismissable');
}

export {
    getCustomLabels,
    showToast,
    showToastForWireError
};