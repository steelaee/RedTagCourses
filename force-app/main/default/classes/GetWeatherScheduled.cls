global with sharing class GetWeatherScheduled implements Schedulable {
    global void execute(SchedulableContext sc){
        WeatherWrapper wr = WeatherController.getWeather();
        WeatherController.createWeather(wr);
    }
}
