import { LightningElement, track, wire, api } from 'lwc';
import { createRecord, updateRecord, getRecord } from 'lightning/uiRecordApi';
import {refreshApex} from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import {getCustomLabels, showToast, showToastForWireError} from 'c/somProcessExceptionNotificationUtils';
import selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel from '@salesforce/apex/SOM_ExceptionNotificationHelper.selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel';
import getSelectedObjectLabelsAndIcons from '@salesforce/apex/SOM_RecipientLookupSearchHandler.getSelectedObjectLabelsAndIcons';
import PROCESS_EXCEPTION_OBJECT from '@salesforce/schema/ProcessException';
import CATEGORY_FIELD from '@salesforce/schema/ProcessException.Category';
import STATUS_FIELD from '@salesforce/schema/ProcessException.Status';
import SEVERITY_FIELD from '@salesforce/schema/ProcessException.Severity';

const COMMA_SEPERATED_FIELDS = ['Recipients__c', 'ProcessExceptionCategories__c', 'ProcessExceptionSeverities__c', 'ProcessExceptionStatuses__c'];
const FIELDS = [
    'SOM_PEConfiguration__c.Name',
    'SOM_PEConfiguration__c.SalesChannelId__c',
    'SOM_PEConfiguration__c.Recipients__c',
    'SOM_PEConfiguration__c.ConfigurationType__c',
    'SOM_PEConfiguration__c.IsEnabled__c',
    'SOM_PEConfiguration__c.ChatterMessage__c',
    'SOM_PEConfiguration__c.IsPostToRelatedRecordFeedEnabled__c',
    'SOM_PEConfiguration__c.ProcessExceptionCategories__c',
    'SOM_PEConfiguration__c.ProcessExceptionSeverities__c',
    'SOM_PEConfiguration__c.ProcessExceptionStatuses__c'
];
const customLabelsArray = [
    {'SOM_PEConfigurationNameLabel' : getCustomLabels().SOM_PEConfigurationNameLabel},
    {'SOM_PEConfigurationsComboboxLabel' : getCustomLabels().SOM_PEConfigurationsComboboxLabel},
    {'SOM_PEConfigurationsComboboxPlaceHolder' : getCustomLabels().SOM_PEConfigurationsComboboxPlaceHolder},
    {'SOM_PEConfigurationNameLabel' : getCustomLabels().SOM_PEConfigurationNameLabel},
    {'SOM_ChatterConfigurationCardTitle' : getCustomLabels().SOM_ChatterConfigurationCardTitle},
    {'SOM_ChatterConfigurationMessageLabel' : getCustomLabels().SOM_ChatterConfigurationMessageLabel},
    {'SOM_ChatterConfigurationMessagePlaceHolder' : getCustomLabels().SOM_ChatterConfigurationMessagePlaceHolder},
    {'SOM_ChatterConfigurationPostOptionsLabel' : getCustomLabels().SOM_ChatterConfigurationPostOptionsLabel},
    {'SOM_Save' : getCustomLabels().SOM_Save},
    {'SOM_SaveAs' : getCustomLabels().SOM_SaveAs},
    {'SOM_Cancel' : getCustomLabels().SOM_Cancel},
    {'SOM_Close' : getCustomLabels().SOM_Close}
];  

export default class SomChatterConfiguration extends LightningElement {
    // Expose the labels to use in the template.
    customLabels = Object.assign({}, ...customLabelsArray.map((x) => (x)));
    @track error;
    @api saleschannelid;
    @track statefulButtons = {};
    isChanged = false;
    // Get recordTypeId of processException object
    processExceptionRecordTypeId;
    @wire(getObjectInfo, { objectApiName: PROCESS_EXCEPTION_OBJECT })
    wiredObject({ error, data }) {
        if (data) {
            this.processExceptionRecordTypeId = Object.keys(data.recordTypeInfos)[0];
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_NoProcessExceptionRecordTypeMessage);
            this.dispatchEvent(event);
        }
    }
    // Get picklist values of status field in ProcessException Object
    _statusPicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$processExceptionRecordTypeId', fieldApiName: STATUS_FIELD })
    wiredStatusValues(statusPicklistData) {
        this._statusPicklistValues = statusPicklistData;
        var { error, data } = statusPicklistData;
        if (data) {
            this.statefulButtons['status'] = data.values.map(x => x.value).map(x => ({ Label: x, Checked: false }));
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_NoProcessExceptionStatusValuesMessage);
            this.dispatchEvent(event);
        }
    }
    // Get picklist values of category field in ProcessException Object
    _categoryPicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$processExceptionRecordTypeId', fieldApiName: CATEGORY_FIELD })
    wiredCategoryValues(categoryPicklistData) {
        this._categoryPicklistValues = categoryPicklistData;
        var { error, data } = categoryPicklistData;
        if (data) {
            this.statefulButtons['category'] = data.values.map(x => x.value).map(x => ({ Label: x, Checked: false }));
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_NoProcessExceptionCategoryValuesMessage);
            this.dispatchEvent(event);
        }
    }
    // Get picklist values of severity field in ProcessException Object
    _severityPicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$processExceptionRecordTypeId', fieldApiName: SEVERITY_FIELD })
    wiredSeverityValues(severityPicklistData) {
        this._severityPicklistValues = severityPicklistData;
        var { error, data } = severityPicklistData;
        if (data) {
            this.statefulButtons['severity'] = data.values.map(x => x.value).map(x => ({ Label: x, Checked: false }));
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_NoProcessExceptionSeverityValuesMessage);
            this.dispatchEvent(event);
        }
    }
    // Update statefulButtons based on loaded record
    changeStatefulButtonsBasedOnRecord(categories, severities, statuses){
        this.statefulButtons.status = this.statefulButtons.status.map(x => {
            x.Checked = statuses.value != null ? statuses.value.split(',').includes(x.Label) : false;
            return x;
        });
        this.statefulButtons.category = this.statefulButtons.category.map(x => {
            x.Checked = categories.value != null ? categories.value.split(',').includes(x.Label) : false;
            return x;
        });
        this.statefulButtons.severity = this.statefulButtons.severity.map(x => {
            x.Checked = severities.value != null ? severities.value.split(',').includes(x.Label) : false;
            return x;
        });
    }
    // Handle changes on form elements
    messageValue;
    messageChange(event) {
        this.messageValue = event.detail.value;
        this.isChanged = true
    }
    // Update Configuration name input in save as Pop up box
    @track saveAsConfigurationName;
    saveAsConfigurationNameChange(event) {
        this.saveAsConfigurationName = event.detail.value;
    }
    // Update Stateful Buttons
    updateStatefulButtons(event){
        var currentButton =  this.statefulButtons[event.detail.fieldname].find(x => x.Label === event.detail.buttonLabel);
        currentButton.Checked = !currentButton.Checked;
        this.isChanged = true
    }
    // Toggle Button
    toggleButtonLabel = 'Disabled';
    handleToggleClick(event){
        this.toggleButtonLabel = this.template.querySelector(".isConfigEnabled").checked ? 'Enabled' : 'Disabled';
        this.isChanged = true
    }
    // Radio Buttons
    radioValue = false;
    radioGroupChange(event){
        this.radioValue = !this.radioValue;
        this.template.querySelector(".isConfigEnabled").value = this.radioValue;
        this.isChanged = true
    }
    get radioOptions() {
        return [
            { label: getCustomLabels().SOM_ChatterConfigurationPostToRelatedFalseOptionLabel, value: false },
            { label: getCustomLabels().SOM_ChatterConfigurationPostToRelatedTrueOptionLabel, value: true },
        ];
    }
    // Query configuration options
    @track configurationSettings;
    _getConfigurationRecordWireData;
    @wire(selectProcessExceptionConfigurationByConfigurationTypeAndSalesChannel, { configuratonType: 'Chatter', salesChannelId: '$saleschannelid' }) 
    getConfigurationRecords(wireConfigurationResults) {
        this._getConfigurationRecordWireData = wireConfigurationResults;
        const { data, error } = wireConfigurationResults;
        if (data) {
            this.configurationSettings = data.map(x => ({ label: x.Name, value: x.Id }));
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_NoPEConfigurationOptionsMessage);
            this.dispatchEvent(event);
        }
    }
    // Get current fields from form
    getFieldsOfNewRecord(){
        return {
            'ConfigurationType__c' : 'Chatter', 
            'SalesChannelId__c' : this.saleschannelid, 
            'IsEnabled__c' : this.toggleButtonLabel === 'Enabled',
            'Recipients__c' : this.recipientIds.toString(),
            'ChatterMessage__c' : this.messageValue, 
            'IsPostToRelatedRecordFeedEnabled__c' : Boolean(this.radioValue),
            'ProcessExceptionStatuses__c' : this.statefulButtons.status.filter(x => x.Checked).length > 0 ? this.statefulButtons.status.filter(x => x.Checked).map(x => x.Label).toString(): null,
            'ProcessExceptionCategories__c' : this.statefulButtons.category.filter(x => x.Checked).length > 0 ? this.statefulButtons.category.filter(x => x.Checked).map(x => x.Label).toString(): null, 
            'ProcessExceptionSeverities__c' : this.statefulButtons.severity.filter(x => x.Checked).length > 0 ? this.statefulButtons.severity.filter(x => x.Checked).map(x => x.Label).toString(): null,
        };
    }
    @track settingValue;
    // Query processExceptionNotification Record
    currentConfiguration;
    _getCurrentConfigurationWireData;
    @wire(getRecord, { recordId: '$settingValue', fields: FIELDS })
    getCurrentConfiguration(currentConfigurationRecord) {
        this._getCurrentConfigurationWireData = currentConfigurationRecord;
        const { data, error } = currentConfigurationRecord;
        if(data){
            this.currentConfiguration = {};
            Object.keys(data.fields).map(key => {
                this.currentConfiguration[key] = data.fields[key].value;
            })
            this.messageValue = data.fields.ChatterMessage__c.value;
            this.radioValue = data.fields.IsPostToRelatedRecordFeedEnabled__c.value;
            this.template.querySelector(".isConfigEnabled").checked = data.fields.IsEnabled__c.value;
            this.toggleButtonLabel = this.template.querySelector(".isConfigEnabled").checked ? 'Enabled' : 'Disabled';
            this.changeStatefulButtonsBasedOnRecord(data.fields.ProcessExceptionCategories__c, data.fields.ProcessExceptionSeverities__c, data.fields.ProcessExceptionStatuses__c);
            this.recipientIds = (data.fields.Recipients__c.value != null) ? data.fields.Recipients__c.value.split(',') : [];
            refreshApex(this._getRecipientList);
            this.isChanged = false;
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_CurrentConfigurationNotReceivedErrorMessage);
            this.dispatchEvent(event);
        }
    }
    // Configuration Settings
    get getConfigurationSettings() {
        return this.configurationSettings;
    }
    // Handle configuration Change
    handleConfigurationChange(event){
        this.settingValue = event.detail.value;
    }
    // Check if two field values are same
    compareTwoFields(firstField, secondField, isFieldListed){
        if((firstField == null || secondField == null)){
            return firstField == null && secondField == null;
        }
        if(isFieldListed){
            let areSetsEqual = (a, b) => a.size === b.size && [...a].every(value => b.has(value));
            let firstFieldSet = new Set(firstField.split(','));
            let secondFieldSet = new Set(secondField.split(','));
            return areSetsEqual(firstFieldSet, secondFieldSet);
        }
        return firstField == secondField;
    }
    // Compare two configuration based on given fields
    isTwoConfigurationSame(firstConfiguration, secondConfiguration, comparedKeys){
        for (var keyIndex = 0; keyIndex < comparedKeys.length; keyIndex++) {
            let keyName = comparedKeys[keyIndex];
            if(!this.compareTwoFields(firstConfiguration[keyName], secondConfiguration[keyName], COMMA_SEPERATED_FIELDS.includes(keyName))){
                return false;
            }
        }
        return true;
    }
    // Checks if currentConfiguration exist in another record
    checkIfConfigurationExist(comparedKeys){
        var isExist = true;
        var inputfields = this.getFieldsOfNewRecord();
        const { data, error } = this._getConfigurationRecordWireData;
        for (var recordIndex = 0; recordIndex < data.length; recordIndex++) {
            isExist = this.isTwoConfigurationSame(data[recordIndex], inputfields, comparedKeys);
            if(isExist){
                return data[recordIndex].Name;
            }
        }
        return null;
    }
    // Validate Inputs
    isInputValid(className) {
        let isValid = true;
        // Check recipients
        if(this.customLookupItems.length == 0){
            let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, getCustomLabels().SOM_PEConfigurationNoRecipientErrorMessage, 'Error', 'dismissable');
            this.dispatchEvent(event);
            return false;
        }
        // Check stateful Buttons
        if(!this.statefulButtons['category'].map(x => x.Checked).includes(true) && !this.statefulButtons['status'].map(x => x.Checked).includes(true) && !this.statefulButtons['severity'].map(x => x.Checked).includes(true)){;
            let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, getCustomLabels().SOM_PEConfigurationInvalidPicklistValuesErrorMessage, 'Error', 'dismissable');
            this.dispatchEvent(event);
            isValid =  false;
        }
        let inputFields = this.template.querySelectorAll(className);
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }
    // Create a new configuration record
    createConfigurationRecord(){
        // Creating mapping of fields of Account with values
        var fields = this.getFieldsOfNewRecord();
        if(this.isModalOpen){
            fields['Name'] = this.saveAsConfigurationName; 
            this.isModalOpen = false;
        }
        let existingConfigurationNames = this.configurationSettings.map(x => x.label);
        if(existingConfigurationNames.includes(fields['Name'])){
            let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, getCustomLabels().SOM_ConfigurationNameMustBeUnique, 'Error', 'dismissable');
            this.dispatchEvent(event);
        }else{
            // Record details to pass to create method with api name of Object.
            var objRecordInput = {'apiName' : 'SOM_PEConfiguration__c', fields};
            createRecord(objRecordInput).then(response => {
                let event = showToast(getCustomLabels().SOM_PERecordCreatedMessage, response, 'Success', 'dismissable');
                this.dispatchEvent(event);
                this.settingValue = response.id;
                refreshApex(this._getConfigurationRecordWireData);
                refreshApex(this._getCurrentConfigurationWireData);
                this.isChanged = false;
            }).catch(error => {
                let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, error.body.message, 'Error', 'dismissable');
                this.dispatchEvent(event);
            });
        }
    }
    // Update selected configuration
    updateConfigurationRecord(){
        // Creating mapping of fields of Account with values
        var fields = this.getFieldsOfNewRecord();
        // Record details to pass to update method with api name of Object.
        fields['Id'] = this.settingValue;
        var objRecordInput = {fields};
        // LDS method to update record.
        updateRecord(objRecordInput).then(response => {
            let event = showToast(getCustomLabels().SOM_PERecordUpdatedMessage, response, 'Success', 'dismissable');
            this.dispatchEvent(event);
            refreshApex(this._getConfigurationRecordWireData);
            refreshApex(this._getCurrentConfigurationWireData);
        }).catch(error => {
            let event = showToast(getCustomLabels().SOM_RecordUpdationErrorTitle, error.body.message, 'Error', 'dismissable');
            this.dispatchEvent(event);
        });
    }
    // Control of Save Buttons
    get isSaveButtonDisable(){
        if(this.currentConfiguration != null){
            return this.isChanged ? false : true;
        }else{
            return true;
        }
    }
    handleSaveAction(){
        let isInputValid = this.isInputValid('.validate');
        if(isInputValid){
            let settingInputField = this.template.querySelector('.validateSettingCombobox');
            if(this.isChanged) {
                let nullOrMatchedConfiguration = this.checkIfConfigurationExist(['Recipients__c', 'ProcessExceptionCategories__c', 'ProcessExceptionSeverities__c', 'ProcessExceptionStatuses__c']);
                if(nullOrMatchedConfiguration == null || nullOrMatchedConfiguration == this.configurationSettings.find(x => x.value == settingInputField.value).label){
                    let isConfigurationChanged = !this.isTwoConfigurationSame(this.currentConfiguration, this.getFieldsOfNewRecord(), FIELDS.map(x => x.split(".")[1]).filter(x => x != 'Name'));
                    if(isConfigurationChanged){
                        this.updateConfigurationRecord();
                    }
                }else{
                    let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, getCustomLabels().SOM_PEConfigurationAlreadyExistErrorMessage, 'Error', 'dismissable');
                    this.dispatchEvent(event);
                }
            }
        }
    }
    handleSaveAsAction(){
        if(this.isInputValid('.saveAsName')){
            this.createConfigurationRecord();
        }
    }
    // Modal Controls
    @track isModalOpen = false;
    openModal() {
        let isInputValid = this.isInputValid('.validate');
        if(isInputValid){
            let nullOrMatchedConfiguration = this.checkIfConfigurationExist(['Recipients__c', 'ProcessExceptionCategories__c', 'ProcessExceptionSeverities__c', 'ProcessExceptionStatuses__c']);
            if(nullOrMatchedConfiguration == null ){
                this.isModalOpen = true;
            }else{
                let event = showToast(getCustomLabels().SOM_RecordCreationErrorTitle, getCustomLabels().SOM_PEConfigurationAlreadyExistErrorMessage, 'Error', 'dismissable');
                this.dispatchEvent(event);
            }
        }
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    // Custom Multi Lookup Seach Component Event Handling
    recipientTypes = [
        {"label":"User", "value":"User", "labelApiName": "Name", "icon": "standard:user", "whereClause" : "isActive = true"},
        {"label":"Public Group", "value":"Group", "labelApiName": "Name", "icon": "standard:groups", "whereClause" : ""},
        {"label":"Role", "value":"UserRole", "labelApiName": "Name", "icon": "standard:user_role", "whereClause" : ""}
    ]
    recipientIds = [];
    customLookupItems = [];
    // Add new recipient to recipient list
    addRecipient(event){
        let selectedRecipient = event.detail.newRecipient;
        if(!this.recipientIds.includes(selectedRecipient.value)){
            this.recipientIds = this.recipientIds.concat([selectedRecipient.value]);
            this.isChanged = true
        }
    }
    // Remove recipient from recipient list
    removeRecipient(event){    
        const index = this.customLookupItems.findIndex(x => x.label == event.detail);
        if (index > -1) {
            this.recipientIds = this.recipientIds.filter(x => x != this.customLookupItems[index].key);
            this.customLookupItems = this.customLookupItems.filter(function(value, i, arr){ 
                return i != index;
            });
            this.isChanged = true
        }
    }
    // Get labels and icons of recipients
    stringifiedRecipientTypes = JSON.stringify(this.recipientTypes);
    _getRecipientList;
    @wire(getSelectedObjectLabelsAndIcons, { itemIds: '$recipientIds', itemTypes: '$stringifiedRecipientTypes'}) 
    getRecipientObjectsRecords(getRecipientWireResult) {
        this._getRecipientList = getRecipientWireResult;
        const { data, error } = getRecipientWireResult;
        if (data) {
                var updatedRecipients = [];
                let parsed = JSON.parse(data);
                parsed.map(wrapper => {
                    let recipientList = wrapper.itemList;
                    let recipientType = this.recipientTypes.find(x => x.value == wrapper.itemApiName);
                    recipientList.map(recipientRecord => {
                        updatedRecipients.push({
                            label: recipientRecord[recipientType.labelApiName],
                            icon: this.recipientTypes.find(x => x.value == wrapper.itemApiName).icon,
                            variant: 'circle',  
                            key : recipientRecord.Id
                        });
                    });
                this.customLookupItems = updatedRecipients;
                });
        } else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_PEConfigurationNoRecipientLabelsErrorMessage);
            this.dispatchEvent(event);
        } 
    }
}