trigger CaseTrigger on Case (after insert) {
    new CaseTriggerHandler().run();
}