@isTest
public with sharing class WeatherAPIServiceTest {
    @TestSetup
    static void makeData(){
        Weather_Setting__c setting = new Weather_Setting__c(
            City_Name__c = 'Osaka'
        );  
        insert setting;
    }

    @isTest
    static void getLocationsTest(){
        List<String> cities = WeatherAPIService.getLocations();

        Test.startTest();

        System.assertEquals('Osaka', cities[0]);
        
        Test.stopTest();
    }

    @isTest
    static void getWeathersTest(){
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new WeatherAPIServiceCalloutMock());

        List<Weather_Setting__c> settings =  WeatherAPIService.getSettings();
        System.assertEquals('Osaka', (WeatherAPIService.getWeathers(settings))[0].name);

        Test.stopTest();
    }

    @isTest
    static void createWeathersTest(){
        Test.startTest();
        WeatherWrapper wrapper = new WeatherWrapper();
        wrapper.name = 'Osaka';
        wrapper.Main.humidity = 1;
        wrapper.Coord.lat = 1;
        wrapper.Coord.lon = 1;
        wrapper.Main.pressure = 1;
        wrapper.Main.feels_like = 1;
        wrapper.Main.temp = 1;
        wrapper.Wind.speed = 1;

        List<WeatherWrapper> wrappers = new List<WeatherWrapper>();
        wrappers.add(wrapper);

        WeatherAPIService.createWeathers(wrappers);

        Weather__c weather = [
            SELECT City_Name__c
            FROM Weather__c
            LIMIT 1
        ];

        System.assertEquals('Osaka', weather.City_Name__c);
        Test.stopTest();
    }
}

