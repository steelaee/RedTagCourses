import { api, LightningElement } from 'lwc';

export default class WeatherCard extends LightningElement {
    @api weather;
}