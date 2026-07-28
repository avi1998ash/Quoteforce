import { LightningElement, api } from 'lwc';

export default class DeleteConfirmModal extends LightningElement {
    @api title = '';
    @api message = '';

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleConfirm() {
        console.log('### handleConfirm CALLED in child');
        this.dispatchEvent(new CustomEvent('confirm'));
        
    }
}