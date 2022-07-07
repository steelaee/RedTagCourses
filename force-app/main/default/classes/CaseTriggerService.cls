public with sharing class CaseTriggerService {
    @testVisible private static List<Case_Update__e> eventList = new List<Case_Update__e>();
    public static void publishEvents(List<Case_Update__e> events){
        eventList.addAll(events);
        EventBus.publish(events);
    }
}
