public with sharing class CaseTriggerHandler extends TriggerHandler{
    List<Case> newCases;
    Map<Id, case> mapNewCases;
    Map<Id, Case> mapOldCases;
    public CaseTriggerHandler(){
        newCases = (List<Case>)Trigger.New;
        mapNewCases = (Map<Id, Case>)Trigger.NewMap;
        mapOldCases = (Map<Id, Case>)Trigger.OldMap;
    }

    public override void afterUpdate(){
        List<Case> casesChangedStatus = new List<Case>();
        for(Id caseId : mapNewCases.keySet()){
            Case updatedCase = mapNewCases.get(caseId);
            
            if((mapOldCases.get(caseId)).Status != updatedCase.Status && updatedCase.Status == 'In Progress'){
                casesChangedStatus.add(updatedCase);
            }
        }

        List<Case_Update__e> events = new List<Case_Update__e>();
        for(Case updatedCase : casesChangedStatus){
            events.add(new Case_Update__e(
                Record_Id__c = newCases[0].Id,
                User_Id__c = newCases[0].LastModifiedById
            ));
        }

        CaseTriggerService.publishEvents(events);
    }
}
