public with sharing class GetWeatherResponse {
    @AuraEnabled
    public static void getWeather(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String geoUrl = 'https://api.openweathermap.org/geo/1.0/direct?q=Lviv&limit=1&appid=07e676cc2e56bb333fef2dc4a8dc1738';
        req.setEndpoint(geoUrl);
        req.setMethod('GET');
        HttpResponse response = http.send(req);

        if(response.getStatusCode() == 200){
            List<Object> results=(List<Object>)JSON.deserializeUntyped(response.getBody());

            System.debug(results);
        }
        else {
            System.debug('bruh');
        }

        String url = 'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=';
    }
    @AuraEnabled
    public static List<Weather__c> getAllWeatherRecords(){
        List<Weather__c> weathers = [
            SELECT City_Name__c, Date__c, Humidity__c, Latitude__c, Longitude__c, Pressure__c, Temp_Feels_Like__c, Temperature__c, Weather_Description__c, Wind_Speed__c
            FROM Weather__c
        ];

        return weathers;
    }
}
