public with sharing class CaseService {
    public static List<Case_Create__e> eventList = new List<Case_Create__e>();

    public static void publishEventOnCaseCreate(List<Case> cases){
        String branchNum = [
            SELECT Branch_Number__c
            FROM User
            WHERE Id =: UserInfo.getUserId()
            LIMIT 1
        ].Branch_Number__c;
        
        List<Case_Create__e> events = new List<Case_Create__e>();

        for(Case cs : cases){
            events.add(new Case_Create__e(
                Branch_Number__c = cs.Branch_Number__c
            ));
        }
        
        eventList.addAll(events);
        EventBus.publish(events);
    }
}
