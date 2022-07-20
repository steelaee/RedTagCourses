trigger CaseTrigger on Case (after update) {
    new CaseTriggerHandler().run();
}