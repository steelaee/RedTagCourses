import { api, LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTaskSubjectValues from '@salesforce/apex/CreateTaskFormController.getTaskSubjectValues';
import createTask from '@salesforce/apex/CreateTaskFormController.createTask';

export default class CreateTaskForm extends LightningElement {
    @api isLoaded = false;
    @api recordId;
    @track optionsSubject = [];
    currDueDate;
    userId;
    currDescription;
    currSubject;

    connectedCallback(){
        this.getSubjectOptions()
    }
    
    getSubjectOptions() {
        getTaskSubjectValues({})
          .then((result) => {
            result.map((el) => {
                let option = {
                    label: el,
                    value: el
                };
                this.optionsSubject = [...this.optionsSubject, option];
            });
        });
    }
    assignedToHandler(event){
        this.userId = event.target.value;
    }
    handleDueDateInputChange(event){
        this.currDueDate = event.target.value;
    }
    handleDescriptionInputChange(event){
        this.currDescription = event.target.value;
    }
    handleSubjectInputChange(event){
        this.currSubject = event.target.value;
    }

    validateFields(){
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        let inputFieldLookup = this.template.querySelector('.validateLookup');

        inputFields.forEach(field => {
            if(!field.checkValidity()){
                field.reportValidity();
                isValid = false;
            }
        });
        if(inputFieldLookup.value == undefined){
            inputFieldLookup.reportValidity();
            isValid = false;
        }

        return isValid;
    }

    showToast(title, message, variant){
        const toast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toast);
    }

    createRecord(){
        this.isLoaded = true;

        if(!this.validateFields()){
            this.isLoaded = false;
            return;
        }
        createTask({
            'campaignId':this.recordId, 
            'assignId':this.userId, 
            'description':this.currDescription, 
            'dueDate':this.currDueDate
        }).then(()=>{
            this.showToast('Success!', Label.successful_task_creation, 'success');
        }).catch(error=>{
            this.showToast('Error!', Label.error_task_creation, 'error');
        }).finally(()=>{
            this.isLoaded = false;
        });

    }
}