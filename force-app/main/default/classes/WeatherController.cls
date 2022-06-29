public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static Weather__c getCityWeatherRecord(String city){
        Weather__c weather = [
            SELECT Name, City_Name__c, Date__c, Humidity__c, Latitude__c, Longitude__c, Temp_Feels_Like__c, Pressure__c, Temperature__c, Weather_Description__c, Wind_Speed__c
            FROM Weather__c
            WHERE City_Name__c =: city
            LIMIT 1
        ];

        return weather;
    }
}