public with sharing class WeatherAPIService {
    @AuraEnabled
    public static List<Weather_Setting__c> getSettings(){
        List<Weather_Setting__c> settings = [
            SELECT City_Name__c, Language__c
            FROM Weather_Setting__c
        ];

        return settings; 
    }
    public static List<WeatherWrapper> getWeathers(List<Weather_Setting__c> settings){
        List<WeatherWrapper> results = new List<WeatherWrapper>();
        Get_Weather_Setting__mdt mdt = Get_Weather_Setting__mdt.getInstance('My_Api');
        HttpRequest req = new HttpRequest();
        String url;
        HTTPResponse response;

        req.setMethod('GET');

        for(Weather_Setting__c setting : settings){
            url = mdt.Endpoint__c + setting.City_Name__c + '&appid=' + mdt.Api_Id__c + setting.Language__c;
            req.setEndpoint(url);
            response = sendRequest(req);
            results.add((WeatherWrapper) System.JSON.deserialize(response.getBody(), WeatherWrapper.class));
        }
        return results;
    }

    static HTTPResponse sendRequest(HttpRequest request){
        Http http = new Http();
        return http.send(request);
    }

    public static void createWeathers(List<WeatherWrapper> results){
        List<Weather__c> weathers = new List<Weather__c>();
        for(WeatherWrapper result : results){
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
            weathers.add(weather);
        }
        

        insert weathers;
    }
}

