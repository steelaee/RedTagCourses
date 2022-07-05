global with sharing class ScheduleCreateWeather implements Schedulable, Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    @TestVisible
    private static final String cron = '0 0 12 1/1 * ? *';
   
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT City_Name__c, Language__c FROM Weather_Setting__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Weather_Setting__c> scope){
        List<Weather__c> weathersToInsert = new List<Weather__c>();
        for(sObject setting : scope){
            WeatherWrapper wr = WeatherAPIService.getWeather((Weather_Setting__c)setting);
            weathersToInsert.add(wr.parseToWeather());
        }
        insert weathersToInsert;
    }
    
    global void finish(Database.BatchableContext info){     
    }

    global void execute(SchedulableContext sc){
        ScheduleCreateWeather scw = new ScheduleCreateWeather();

        Database.executeBatch(scw);
    }
    
    public static String schedule(){
        ScheduleCreateWeather w = new ScheduleCreateWeather();

        return System.schedule('Create Weathers', cron, w);
    }
}