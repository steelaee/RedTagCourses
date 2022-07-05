@isTest
private with sharing class ScheduleCreateWeatherTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createWeatherSettings(200, 'Osaka', 34.672314, 135.484802);
    }

    @isTest
    private static void executeBatchTest(){
        Test.setMock(HttpCalloutMock.class, new WeatherAPIServiceCalloutMock());

        Test.startTest();
        ScheduleCreateWeather scw = new ScheduleCreateWeather();
        Database.executeBatch(scw, 200);
        Test.stopTest();

        Integer num = [SELECT count() FROM Weather__c];
        System.assertEquals(200, num);
    }

    @isTest
    private static void scheduleDailyAt12AMTest(){
        Test.startTest();

        String jobId = ScheduleCreateWeather.schedule();

        CronTrigger ct = [
            SELECT CronExpression, TimesTriggered
            FROM CronTrigger
            WHERE Id =: jobId
        ];

        System.assertEquals(ScheduleCreateWeather.cron, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}