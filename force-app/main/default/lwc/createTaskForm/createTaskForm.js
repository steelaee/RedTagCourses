import { api, LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTaskSubjectValues from '@salesforce/apex/CreateTaskFormController.getTaskSubjectValues';
import createTask from '@salesforce/apex/CreateTaskFormController.createTask';

export default class CreateTaskForm extends LightningElement {
    currDueDate;
    userId;
    currDescription;
    currSubject;
    @api recordId;
    @api isLoaded = false;
    @track optionsSubject;

    connectedCallback(){
        this.getOptionSubject()
    }
    
    getOptionSubject() {
        getTaskSubjectValues({})
          .then((result) => {
             let options = [];
            if (result) {
              result.forEach(r => {
                options.push({
                  label: r,
                  value: r,
                });
              });
            }
            this.optionsSubject = options;
        });
    }
    assignedToHandler(event){
        this.userId = event.target.value;
    }
    dueDateChangedHandler(event){
        this.currDueDate = event.target.value;
    }
    descriptionChangedHandler(event){
        this.currDescription = event.target.value;
    }
    subjectChangedHandler(event){
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
            const toast = new ShowToastEvent({
                title: 'Success!',
                message: 'New Task record has been created successfully.',
                variant: 'success',
            });
            this.dispatchEvent(toast);
        }).catch(error=>{
            console.log(error);
            const toast = new ShowToastEvent({
                title: 'Error!',
                message: 'New Task record has not been created successfully.',
                variant: 'error',
            });
            this.dispatchEvent(toast);
        }).finally(()=>{
            this.isLoaded = false;
        });

    }
}