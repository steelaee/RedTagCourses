global with sharing class ScheduleCreateWeather implements Schedulable {
    global void execute(SchedulableContext sc){
        List<Weather_Setting__c> settings = WeatherAPIService.getSettings();
        List<WeatherWrapper> wr = WeatherAPIService.getWeathers(settings);
        WeatherAPIService.createWeathers(wr);
    }
}
