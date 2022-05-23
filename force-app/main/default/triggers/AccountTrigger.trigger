trigger AccountTrigger on Account (after insert, after update, before delete) {
    new AccountTriggerHandler().run();
}