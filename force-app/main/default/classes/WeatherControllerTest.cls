@isTest
private with sharing class WeatherControllerTest {
    @TestSetup
    private static void makeData(){
        TestDataFactory.createWeathers(1, 'TestCity');

        TestDataFactory.createWeatherSettings(1, 'Osaka');
    }

    @isTest
    private static void getCityWeatherRecordsTest(){
        Test.startTest();
        List<Weather__c> weathers = WeatherController.getCityWeatherRecords('TestCity');
        Test.stopTest();

        System.assertEquals(1, weathers.size());
        System.assertEquals('TestCity', weathers[0].City_Name__c);
    }

    @isTest
    private static void getSettingsTest(){
        Test.startTest();

        List<Weather_Setting__c> weatherSettings = WeatherController.getSettings();

        System.assertEquals(1, weatherSettings.size());
        System.assertEquals('Osaka', weatherSettings[0].City_Name__c);

        Test.stopTest();
    }
}