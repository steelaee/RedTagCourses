public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static List<Weather__c> getAllWeatherRecords(){
        List<Weather__c> weathers = [
            SELECT Name, City_Name__c, Date__c, Humidity__c, Latitude__c, Longitude__c, Temp_Feels_Like__c, Pressure__c, Temperature__c, Weather_Description__c, Wind_Speed__c
            FROM Weather__c
        ];

        Boolean sorted = false;
        Weather__c temp;
        while (!sorted) {
            sorted = true;
            for(Integer i = 0; i < weathers.size() - 1; i++){
                if(weathers[i].Date__c < weathers[i + 1].Date__c){
                    temp = weathers[i];
                    weathers[i] = weathers[i + 1];
                    weathers[i + 1] = temp;
                    sorted = false;
                }
            }
        }

        return weathers;
    }
}