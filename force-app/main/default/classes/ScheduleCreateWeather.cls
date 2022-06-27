global with sharing class ScheduleCreateWeather implements Schedulable {
    global void execute(SchedulableContext sc){
        WeatherWrapper wr = WeatherAPIService.getWeather();
        WeatherAPIService.createWeather(wr);
    }
}
