import { LightningElement, api, wire, track } from 'lwc';
import currency from "@salesforce/i18n/currency";
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import REASON_FIELD from '@salesforce/schema/SOM_RejectOrderLineItem__c.Reason__c';

export default class SomRejectFulfillmentOrderProductSelector extends LightningElement {
    @api itemListParam = [];
    @track inputItemListTemp = [];
    @api fullyRejected = false;
    reasonOptions = [];
    defaultReason = null;
    currencyCode = currency;
    disabledRowStyle = "disabledRow";

    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: REASON_FIELD
    })
    getReasonValues(result) {
        if (result && result.data) {
            for (let reason of result.data.values) {
                this.reasonOptions.push({
                    label: reason.label,
                    value: reason.value
                });
            }
            this.defaultReason = result.data.values[0].value;
            this.setupValues();
        }
    }

    cloneReadOnlyObjectToAllowChanges(object) {
        return JSON.parse(JSON.stringify(object));
    }

    setupValues() {
        this.inputItemListTemp = this.cloneReadOnlyObjectToAllowChanges(this.itemListParam);
        this.inputItemListTemp.forEach(item => {
            if (item.description) {
                item.shortDescription = item.description.substring(0, item.description.length > 30 ? 30 : item.description.length);
            }
            item.reasonOptions = [...this.reasonOptions];
            item.reason = this.defaultReason;
            item.quantityOptions = this.getQuantityOptionsForItem(item);
            item.quantityText = item.quantity.toString();
        });

        this.assignNewValuesToItemListParam();
        this.setFullyRejectedIfAllItemsAreSelectedWithMaxQuantity();
    }

    assignNewValuesToItemListParam() {
        this.itemListParam = [];
        this.inputItemListTemp.forEach(item => {
            this.itemListParam.push({
                fulfillmentItemId: item.fulfillmentItemId,
                quantity: item.quantity,
                originalQuantity: item.originalQuantity,
                unitPrice: item.unitPrice,
                reason: item.reason,
                orderItemSummaryId: item.orderItemSummaryId
            });
        });
    }

    getQuantityOptionsForItem(item) {
        let quantityOptions = [];
        for (let quantityCounter = 1; quantityCounter <= item.quantity; quantityCounter++) {
            quantityOptions.push({
                label: quantityCounter.toString(),
                value: quantityCounter.toString()
            });
        }
        return quantityOptions;
    }

    masterCheckboxChanged(event) {
        let isChecked = event.target.checked;

        var checkboxList = this.template.querySelectorAll("lightning-input[data-control='checkbox']");

        checkboxList.forEach((element) => {
            element.checked = isChecked;
        });

        let cells = this.template.querySelectorAll("td[data-element='content']");

        if (isChecked) {
            this.assignNewValuesToItemListParam();
            this.enableRow(cells);
        } else {
            this.itemListParam = [];
            this.disableRow(cells);
        }

        this.setFullyRejectedIfAllItemsAreSelectedWithMaxQuantity();
    }

    checkboxChanged(event) {
        const selectedId = event.target.dataset.id;
        let cells = this.template.querySelectorAll("td[data-id='" + selectedId + "']");
        let itemChanged = this.inputItemListTemp.find(item => item.fulfillmentItemId === selectedId);

        if (event.target.checked) {
            this.insertItemInOutput(itemChanged);
            this.enableRow(cells);
        } else {
            this.removeItemInOutput(itemChanged);
            this.disableRow(cells);
        }

        var checkboxList = this.template.querySelectorAll("lightning-input[data-control='checkbox']");

        var selectedCount = 0;
        checkboxList.forEach((item) => {
            if (item.checked) {
                selectedCount++;
            }
        });

        var masterCheckbox = this.template.querySelector("lightning-input[data-control='masterCheckbox']");
        masterCheckbox.checked = selectedCount === checkboxList.length && selectedCount > 0;
        this.setFullyRejectedIfAllItemsAreSelectedWithMaxQuantity();
    }

    setFullyRejectedIfAllItemsAreSelectedWithMaxQuantity() {
        this.fullyRejected = true;

        if (this.itemListParam.length != this.inputItemListTemp.length) {
            this.fullyRejected = false;
            return;
        }
        this.itemListParam.forEach(item => {
            if (item.quantity != item.originalQuantity) {
                this.fullyRejected = false;
                return;
            }
        });
    }

    insertItemInOutput(itemChanged) {
        this.itemListParam.push(itemChanged);
    }

    removeItemInOutput(itemChanged) {
        this.itemListParam = this.itemListParam.filter(item => item.fulfillmentItemId != itemChanged.fulfillmentItemId);
    }

    reasonChanged(event) {
        const id = event.target.dataset.id;
        let lineItem = this.itemListParam.find((i) => i.fulfillmentItemId == id);
        lineItem.reason = event.target.value;
    }

    quantityChanged(event) {
        let item = this.itemListParam.find((item) => item.fulfillmentItemId == event.target.dataset.id);
        item.quantity = parseInt(event.target.value);
        let itemTemp = this.inputItemListTemp.find((item) => item.fulfillmentItemId == event.target.dataset.id);
        itemTemp.totalWithTax = item.quantity * item.unitPrice;
        itemTemp.quantity = item.quantity;
        this.setFullyRejectedIfAllItemsAreSelectedWithMaxQuantity();
    }

    enableRow(cells) {
        cells.forEach((cell) => {
            cell.classList.remove(this.disabledRowStyle);
        });
    }

    disableRow(cells) {
        cells.forEach((cell) => {
            cell.classList.add(this.disabledRowStyle);
        });
    }
}