import { LightningElement, api } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
export default class SomConfirmDialog extends LightningElement {
    @api yesButtonClicked = false;
    @api isModalOpen = false;
    @api text = 'Are you sure you want to proceed?';
    @api title = 'Confirm Dialog';

    connectedCallback() {
        this.openModal();
    }

    openModal() {
        this.isModalOpen = true;
    }

    handleCancel() {
        this.isModalOpen = false;
        this.yesButtonClicked = false;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
    
    handleConfirm() {
        this.isModalOpen = false;
        this.yesButtonClicked = true;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}
