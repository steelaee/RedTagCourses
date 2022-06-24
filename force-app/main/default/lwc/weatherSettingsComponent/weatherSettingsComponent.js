import { LightningElement } from 'lwc';
import createSettings from '@salesforce/apex/WeatherController.createSettings';
import isSettingsExists from '@salesforce/apex/WeatherController.isSettingsExists';
import getSettingsFields from '@salesforce/apex/WeatherController.getSettingsFields';

export default class WeatherSettingsComponent extends LightningElement {
    single = false;
    isModalOpen = false;
    cityInput;
    languageInput;
    citySettings;
    languageSettings;

    connectedCallback(){
        this.updateSettings();
    }

    cityChangedHandler(event){
        this.cityInput = event.target.value;
    }

    languageChangedHandler(event){
        this.languageInput = event.target.value;
    }

    openModal(){
        this.isModalOpen = true;
        this.single = true;
    }

    updateSettings(){
        isSettingsExists().then(response => {
            if(response){
                getSettingsFields().then(result => {
                    this.citySettings = result[0];
                    this.languageSettings = result[1];
                });
                this.single = true;
            }
            else{
                this.single = false;
            }
        })
    }

    closeModal(){
        this.updateSettings();
        this.isModalOpen = false;
    }

    createRecord(){
        createSettings({
            'city': this.cityInput,
            'lang': this.languageInput
        });
        this.isModalOpen = false;
    }
}