global with sharing class GetWeatherScheduled implements Schedulable {
    global void execute(SchedulableContext sc){
        WeatherController.createWeather(WeatherController.getWeather());
    }
}
