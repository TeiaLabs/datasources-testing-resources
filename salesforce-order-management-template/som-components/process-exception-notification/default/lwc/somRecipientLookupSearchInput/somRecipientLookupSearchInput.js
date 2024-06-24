import { LightningElement, wire, track, api } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import {getCustomLabels, showToast, showToastForWireError} from 'c/somProcessExceptionNotificationUtils';
import getIdAndNameOfItems from '@salesforce/apex/SOM_RecipientLookupSearchHandler.getIdAndNameOfItems';

const customLabelsArray = [
    {'SOM_RecipientSearchInputRecordTypeLabel' : getCustomLabels().SOM_RecipientSearchInputRecordTypeLabel},
    {'SOM_RecipientSearchInputRecordsLabel' : getCustomLabels().SOM_RecipientSearchInputRecordsLabel}
];
export default class SomRecipientLookupSearchInput extends LightningElement {
    // Expose the labels to use in the template.
    customLabels = Object.assign({}, ...customLabelsArray.map((x) => (x)));
    @track error;
    recipientIds = [];
    @api itemtypes;
    @track currentRecipientType;
    // Query processExceptionNotification Record
    potentialItems;
    _getIdAndNameOfItemsWireData;
    @wire(getIdAndNameOfItems, { objectName: "$currentRecipientType.value", labelApiName: "$currentRecipientType.labelApiName", whereClause: "$currentRecipientType.whereClause"})
    getIdAndNameOfItems(currentPotensialRecipientList) {
        this._getIdAndNameOfItemsWireData = currentPotensialRecipientList;
        const { data, error } = currentPotensialRecipientList;
        if(data) {
            this.potentialItems = [];
            data.map(x => {
                if(x.hasOwnProperty(this.currentRecipientType['labelApiName'])){
                    this.potentialItems.push(({'label' : x[this.currentRecipientType['labelApiName']], 'value': x['Id']}));
                }
            })
        }else if (error) {
            this.error = getCustomLabels().SOM_UnknownErrorMessage;
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
            let event = showToast(getCustomLabels().SOM_SalesChannelsNotReceivedErrorMessage, this.error, 'error', 'dismissable');
            this.dispatchEvent(event);
        }
    }
    // Change Item Type
    currentItemTypeChange(event){
        this.currentRecipientType = this.itemtypes.find(x => x.value == event.detail.value);
        refreshApex(this._getIdAndNameOfItemsWireData);
    }
    // Change selected item
    selectedItemId;
    selectedItemChange(event){
        this.selectedItemId = event.detail.value;
        let selectedRecipient = this.potentialItems.find(x => x.value == this.selectedItemId);
        this.dispatchEvent(new CustomEvent('addrecipient', { detail: {'newRecipient': selectedRecipient, 'icon': this.currentRecipientType.icon}}));
    }
    // Remove Pill
    @api selecteditems;
    handleRemovePill(event){
        this.dispatchEvent(new CustomEvent('removerecipient', { detail: event.target.label}));
    }
}