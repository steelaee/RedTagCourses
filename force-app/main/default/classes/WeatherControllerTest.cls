@isTest
public with sharing class WeatherControllerTest {
    @TestSetup
    static void makeData(){
        insert new Weather__c(
            City_Name__c = 'TestCity'
        );
        Weather_Setting__c setting = new Weather_Setting__c(
            City_Name__c = 'Osaka'
        );  
        insert setting;
    }

    @isTest
    static void getCityWeatherRecordsTest(){
        Test.startTest();

        System.assertEquals('TestCity', WeatherController.getCityWeatherRecords('TestCity')[0].City_Name__c);

        Test.stopTest();
    }

    @isTest
    static void getSettingsTest(){
        Test.startTest();

        List<Weather_Setting__c> weathers = WeatherController.getSettings();
        
        List<Weather_Setting__c> weathersFromQuery = [
            SELECT City_Name__c
            FROM Weather_Setting__c
        ];

        System.assertEquals(weathers, weathersFromQuery);

        Test.stopTest();

    }

    @isTest
    static void getWeathersTest(){
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new WeatherAPIServiceCalloutMock());

        List<Weather_Setting__c> settings =  WeatherController.getSettings();
        System.assertEquals('Osaka', (WeatherController.getWeathers(settings))[0].name);

        Test.stopTest();
    }

    @isTest
    static void createWeathersTest(){
        List<WeatherWrapper> wrappers = new List<WeatherWrapper>();

        WeatherWrapper wrapper = new WeatherWrapper();
        wrapper.name = 'Osaka';
        wrapper.main.humidity = 1;
        wrapper.coord.lat = 1;
        wrapper.coord.lon = 1;
        wrapper.main.pressure = 1;
        wrapper.main.feels_like = 1;
        wrapper.main.temp = 1;
        wrapper.wind.speed = 1;

        wrappers.add(wrapper);

        Test.startTest();
        WeatherController.createWeathers(wrappers);

        Weather__c weather = [
            SELECT City_Name__c
            FROM Weather__c
            LIMIT 1
        ];

        System.assertEquals('Osaka', weather.City_Name__c);
        Test.stopTest();
    }
}
