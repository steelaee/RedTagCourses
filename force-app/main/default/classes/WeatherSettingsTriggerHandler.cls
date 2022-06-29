public with sharing class WeatherSettingsTriggerHandler extends TriggerHandler {
    List<Weather_Setting__c> newItems;

    public WeatherSettingsTriggerHandler(){
        newItems = (List<Weather_Setting__c>)Trigger.New;
    }

    public override void beforeInsert(){
        List<Weather_Setting__c> settings = [
            SELECT City_Name__c
            FROM Weather_Setting__c
        ];
        
        List<String> cityNames = new List<String>();
        
        for(Weather_Setting__c setting : settings){
            cityNames.add(setting.City_Name__c);
        }

        for(Weather_Setting__c setting : newItems){
            for(String cityName : cityNames){
                if(cityName.containsIgnoreCase(setting.City_Name__c)){
                    setting.addError('There can be only one setting per city.');
                }
            }
        }
    }
}