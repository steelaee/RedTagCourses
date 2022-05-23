trigger SalesItemTrigger on Sales_Item__c (before insert, before update) {
    new SalesItemTriggerHandler().run();
}