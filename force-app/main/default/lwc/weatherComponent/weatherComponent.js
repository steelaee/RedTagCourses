import { LightningElement, wire } from 'lwc';
import GetAllWeatherRecords from '@salesforce/apex/GetWeatherResponse.GetAllWeatherRecords';

export default class WeatherComponent extends LightningElement {
    @wire(GetAllWeatherRecords) weathers;
}