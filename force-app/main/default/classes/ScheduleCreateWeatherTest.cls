@isTest
public with sharing class ScheduleCreateWeatherTest {
    @isTest
    static void executeTest(){
        Test.startTest();

        String jobId = System.schedule('Test Schedule', ScheduleCreateWeather.cron, new ScheduleCreateWeather());

        CronTrigger ct = [
            SELECT CronExpression, TimesTriggered
            FROM CronTrigger
            WHERE Id =: jobId
        ];

        System.assertEquals(ScheduleCreateWeather.cron, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }

    @isTest
    static void scheduleDailyAt12AMTest(){
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
