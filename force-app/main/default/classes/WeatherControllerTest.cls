@isTest
public with sharing class WeatherControllerTest {
    @TestSetup
    static void makeData(){
        insert new Weather__c(
            City_Name__c = 'TestCity'
        );
    }

    @isTest
    static void getCityWeatherRecordsTest(){
        Test.startTest();

        System.assertEquals('TestCity', WeatherController.getCityWeatherRecords('TestCity')[0].City_Name__c);

        Test.stopTest();
    }
}
