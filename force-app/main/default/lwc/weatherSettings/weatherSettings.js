import { LightningElement, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Weather_Setting__c.Name';
import CITY_NAME_FIELD from '@salesforce/schema/Weather_Setting__c.City_Name__c';
import LANG_FIELD from '@salesforce/schema/Weather_Setting__c.Language__c';
import isSettingsExists from '@salesforce/apex/WeatherAPIService.isSettingsExists';
import getSettingsId from '@salesforce/apex/WeatherAPIService.getSettingsId';

export default class WeatherSettingsComponent extends LightningElement {
    nameField = NAME_FIELD;
    cityNameField = CITY_NAME_FIELD;
    languageField = LANG_FIELD;
    recordId;
    exists;

    connectedCallback(){
        isSettingsExists().then(responce => {
            if(responce){
                this.exists = true;
            }
            else{
                this.exists = false;
            }
        });
    }

    initRecordId(){
        getSettingsId().then(responce => {
            this.recordId = responce;
        });
    }

    handleSuccess(){
        if(!this.exists){
            this.initRecordId();
            this.exists = true;
        }
    
        const success = new ShowToastEvent({
            title:'Success!',
            message: 'Your settings have been saved.',
            variant: 'success'
        });
        this.dispatchEvent(success)
    }

    handleError(){
        const error = new ShowToastEvent({
            title:'Erorr!',
            message: 'Your settings have not been saved',
            variant: 'error'
        });
        this.dispatchEvent(error);
    }
}