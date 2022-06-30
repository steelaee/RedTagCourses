global with sharing class ScheduleCreateWeather implements Schedulable, Database.Batchable<sObject>,   Database.AllowsCallouts  {
    @TestVisible
    private static final String cron = '0 0 12 1/1 * ? *';

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.QueryLocator(query);
    }

    global void execute(SchedulableContext sc){
        List<Weather_Setting__c> settings = WeatherAPIService.getSettings();
        List<WeatherWrapper> wr = WeatherAPIService.getWeathers(settings);
        WeatherAPIService.createWeathers(wr);
    }
    public static String schedule(){
        ScheduleCreateWeather w = new ScheduleCreateWeather();

        return System.schedule('Create Weathers', cron, w);
    }
}
