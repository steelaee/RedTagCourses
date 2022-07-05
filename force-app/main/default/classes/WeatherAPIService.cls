public with sharing class WeatherAPIService {
    public static WeatherWrapper getWeather(Weather_Setting__c setting){
        Weather_API_Metadata__mdt metaData = Weather_API_Metadata__mdt.getInstance('Weather_API');

        Http httpClient = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String url = metaData.Endpoint__c + setting.City_Name__c + '&appid=' + metaData.Api_Id__c + setting.Language__c;
        req.setEndpoint(url);
        HTTPResponse res = httpClient.send(req);

        WeatherWrapper wr = WeatherWrapper.parseJSON(res.getBody());
        
        return wr;
    }
}