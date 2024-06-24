import { LightningElement, wire, track } from 'lwc';
import {getCustomLabels, showToastForWireError} from 'c/somProcessExceptionNotificationUtils';
import getSalesChannelList from '@salesforce/apex/SOM_ExceptionNotificationHelper.getSalesChannelList';

export default class SomProcessExceptionNotification extends LightningElement {
    @track error;
    salesChannels;
    numberOfSalesChannels = 0;
    // Get sales channels
    @wire(getSalesChannelList)
    wiredObject(objectData) {
        var { error, data } = objectData;
        if (data) {
            this.salesChannels = data;
            this.numberOfSalesChannels = this.salesChannels.length;
        }else if (error) {
            let event = showToastForWireError(error, getCustomLabels().SOM_SalesChannelsNotReceivedErrorMessage);
            this.dispatchEvent(event);
        }
    }
    // Check number of sales channels
    get doesAnySalesChannelExist(){
        return this.numberOfSalesChannels > 0;
    }
}