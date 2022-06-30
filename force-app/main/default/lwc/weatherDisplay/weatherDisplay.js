import { LightningElement, track } from 'lwc';
import getCityWeatherRecords from '@salesforce/apex/WeatherController.getCityWeatherRecords';
import getSettings from '@salesforce/apex/WeatherAPIService.getSettings';

export default class WeatherComponent extends LightningElement {
    @track mapMarkers = [];
    @track columns = [
        { label: 'City Name', fieldName: 'cityName'},
        { label: 'Date', fieldName: 'date'},
        { label: 'Temperature', fieldName: 'temperature'},
        { label: 'Pressure', fieldName: 'pressure'},
        { label: 'Temperature feels like', fieldName: 'temperatureFeelsLike'},
        { label: 'Wind Speed', fieldName: 'windSpeed'}
    ];
    @track weather;
    @track data = [];
    currentCity;
    
    connectedCallback(){
        getSettings().then(response => {
            response.map((el) => {
                let marker = {
                    location: {
                        City: el.City_Name__c,
                        Latitude: el.Coordinates__latitude__s,
                        Longitude: el.Coordinates__longitude__s
                    },
                    value: el.City_Name__c
                };
                this.mapMarkers = [...this.mapMarkers, marker];
            });
        });
    }

    markerSelect(event){
        this.currentCity = event.target.selectedMarkerValue;
        this.data = [];
        getCityWeatherRecords({city:this.currentCity}).then(response => {
            this.weather = response[0];

            response.map((weath) => {
                let el ={
                    cityName: weath.City_Name__c,
                    date: weath.Date__c,
                    temperature: weath.Temperature__c,
                    pressure: weath.Pressure__c,
                    temperatureFeelsLike: weath.Temp_Feels_Like__c,
                    windSpeed: weath.Wind_Speed__c
                };
                this.data = [...this.data, el];
            });
        })
    }
}