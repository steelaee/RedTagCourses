public with sharing class WeatherController {
    public static WeatherWrapper getWeather(){
        List<Weather_Setting__c> settings = [
            SELECT City_Name__c, Language__c
            FROM Weather_Setting__c
        ];
        //error if more than 1 setting
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String url = 'https://api.openweathermap.org/data/2.5/weather?q=' + settings.City_Name__c +  
            '&appid=07e676cc2e56bb333fef2dc4a8dc1738&' + settings.Language__c;
        //apiId і endpoint у кастом метадату
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse response = http.send(req);

        return (WeatherWrapper) System.JSON.deserialize(response.getBody(), WeatherWrapper.class);
    }

    // @AuraEnabled
    // public static void createSettings(String city, String lang){
    //     insert new Weather_Setting__c(
    //         City_Name__c = city,
    //         Language__c = lang
    //     );
    // }

    // @AuraEnabled
    // public static Boolean isSettingsExists(){
    //     Weather_Setting__c settings ;
    //     try {
    //         settings = [
    //             SELECT Name 
    //             FROM Weather_Setting__c
    //             LIMIT 1
    //         ]; 
    //     } catch (Exception ex) {
    //         return false;
    //     }
    //     return true;
    // }

    // @AuraEnabled
    // public static List<String> getSettings(){
    //     Weather_Setting__c settings = [
    //         SELECT City_Name__c, Language__c
    //         FROM Weather_Setting__c
    //         LIMIT 1
    //     ];
    //     List<String> result = new List<String>();
    //     result.add(settings.City_Name__c);
    //     result.add(settings.Language__c);
    //     return result;
    // }
    // public static void createWeather(WeatherWrapper result){
    //     Weather__c weather = new Weather__c(
    //         City_Name__c = result.name,
    //         Date__c = System.today(),
    //         Humidity__c = result.Main.humidity,
    //         Latitude__c = result.Coord.lat,
    //         Longitude__c = result.Coord.lon,
    //         Pressure__c = result.Main.pressure,
    //         Temp_Feels_Like__c = result.Main.feels_like,
    //         Temperature__c = result.Main.temp,
    //         Wind_Speed__c = result.Wind.speed
    //     );

    //     insert weather;
    // }
        
    @AuraEnabled(cacheable=true)
    public static List<Weather__c> getAllWeatherRecords(){
        List<Weather__c> weathers = [
            SELECT Name, City_Name__c, Date__c, Humidity__c, Latitude__c, Longitude__c, Temp_Feels_Like__c, Pressure__c, Temperature__c, Weather_Description__c, Wind_Speed__c
            FROM Weather__c
        ];

        return weathers;
    }
}