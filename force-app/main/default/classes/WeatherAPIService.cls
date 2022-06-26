public with sharing class WeatherAPIService {
    @AuraEnabled
    public static Boolean isSettingsExists(){
        Weather_Setting__c settings ;
        try {
            settings = [
                SELECT Name 
                FROM Weather_Setting__c
                LIMIT 1
            ]; 
        } catch (Exception ex) {
            return false;
        }
        
        return true;
    }

    @AuraEnabled
    public static String getSettingsId(){
        Weather_Setting__c settings = [
            SELECT Name
            FROM Weather_Setting__c
            LIMIT 1
        ];
        return settings.Id;
    }

    public static WeatherWrapper getWeather(){
        Get_Weather_Setting__mdt mdt = Get_Weather_Setting__mdt.getInstance('My_Api');

        Weather_Setting__c setting = [
            SELECT City_Name__c, Language__c
            FROM Weather_Setting__c
            LIMIT 1
        ];
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String url = mdt.Endpoint__c + setting.City_Name__c + '&appid=' + mdt.Api_Id__c + setting.Language__c;  
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse response = http.send(req);

        return (WeatherWrapper) System.JSON.deserialize(response.getBody(), WeatherWrapper.class);
    }

    public static void createWeather(WeatherWrapper result){
        Weather__c weather = new Weather__c(
            City_Name__c = result.name,
            Date__c = System.today(),
            Humidity__c = result.Main.humidity,
            Latitude__c = result.Coord.lat,
            Longitude__c = result.Coord.lon,
            Pressure__c = result.Main.pressure,
            Temp_Feels_Like__c = result.Main.feels_like,
            Temperature__c = result.Main.temp,
            Wind_Speed__c = result.Wind.speed
        );

        insert weather;
    }
}
