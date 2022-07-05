public with sharing class WeatherController{
    @AuraEnabled
    public static List<Weather__c> getCityWeatherRecords(String city){
        List<Weather__c> weathers = [
            SELECT Name, City_Name__c, Date__c, Humidity__c, Latitude__c, Longitude__c, Temp_Feels_Like__c, Pressure__c, Temperature__c, Weather_Description__c, Wind_Speed__c
            FROM Weather__c
            WHERE City_Name__c =: city
        ];
        
        return weathers;
    }

    @AuraEnabled
    public static List<Weather_Setting__c> getSettings(){
        List<Weather_Setting__c> settings = [
            SELECT City_Name__c, Language__c
            FROM Weather_Setting__c
        ];

        return settings; 
    }
}