@isTest
public with sharing class ScheduleCreateWeatherTest {
    @isTest
    static void executeTest(){
        Test.startTest();

        String chron = '0 0 0 9 9 ? 2022';        
        System.schedule('Test Sched', chron, new ScheduleCreateWeather());

        Integer settingsNum = [
            SELECT Id 
            FROM Weather_Setting__c
        ].size();

        Integer weathersNum = [
            SELECT Id 
            FROM Weather__c
        ].size();

        System.assertEquals(settingsNum, weathersNum);
        Test.stopTest();
    }
}
