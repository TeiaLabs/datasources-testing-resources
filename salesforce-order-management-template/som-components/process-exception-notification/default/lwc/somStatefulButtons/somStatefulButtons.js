import { LightningElement, api} from 'lwc';
import {getCustomLabels} from 'c/somProcessExceptionNotificationUtils';

export default class SomStatefulButtons extends LightningElement {
    @api fieldname;
    @api buttons;
    get buttonsOfField(){
        if(this.buttons.hasOwnProperty(this.fieldname)){
            let buttonsWithVariants = JSON.parse(JSON.stringify(this.buttons));
            return buttonsWithVariants[this.fieldname].map(x => {
                x.variant = x.Checked ? 'brand' : 'brand-outline';
                return x;
            });
        }
        return null;
    }
    get titleOfButtonGroup(){
        return getCustomLabels().SOM_StatefulButtonTitle + ' ' + this.fieldname;
    }
    handleClick(event){
        this.dispatchEvent(new CustomEvent('addnewelement', { detail: {'fieldname': this.fieldname, 'buttonLabel': event.target.className}}));
    }
}