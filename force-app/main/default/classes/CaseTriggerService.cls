public with sharing class CaseTriggerService {
    @testVisible private static List<Case_Update__e> eventList = new List<Case_Update__e>();
    public static void publishEventOnStatusUpdate(){
        List<Case> casesChangedStatus = new List<Case>();
        for(Id caseId : ((Map<Id, Case>)Trigger.NewMap).keySet()){
            Case updatedCase = ((Map<Id, Case>)Trigger.NewMap).get(caseId);
            
            if((((Map<Id, Case>)Trigger.OldMap).get(caseId)).Status != updatedCase.Status && updatedCase.Status == 'In Progress'){
                casesChangedStatus.add(updatedCase);
            }
        }

        for(Case updatedCase : casesChangedStatus){
            eventList.add(new Case_Update__e(
                Record_Id__c = ((List<Case>)Trigger.New)[0].Id,
                User_Id__c = ((List<Case>)Trigger.New)[0].LastModifiedById
            ));
        }

        EventBus.publish(eventList);
    }
}
