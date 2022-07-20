public with sharing class CaseTriggerHandler extends TriggerHandler{
    public override void afterUpdate(){
        CaseTriggerService.publishEventOnStatusUpdate();
    }
}
