public with sharing class CaseTriggerHandler extends TriggerHandler{
    public override void afterInsert(){
        CaseService.publishEventOnCaseCreate((List<Case>)Trigger.New);
    }
}
