import { LightningElement, track } from 'lwc';
import getCityWeatherRecord from '@salesforce/apex/WeatherController.getCityWeatherRecord';
import getLocations from '@salesforce/apex/WeatherAPIService.getLocations';

export default class WeatherComponent extends LightningElement {
    @track mapMarkers = [];
    weather;
    options = [];
    
    connectedCallback(){
        getLocations().then(response => {
            for(let i = 0; i < response.length; i++){
                let marker = {
                    location: {
                        City: response[i]
                    }
                };
                this.mapMarkers = [...this.mapMarkers, marker];


                
                let option = {
                    label: response[i],
                    value: response[i]
                };
                this.options = [...this.options, option];
            }   
        });
    }
    handleChange(event){
        let value = event.detail.value;
        getCityWeatherRecord({city: value}).then(response => {
            this.weather = response;
        })
    }
}