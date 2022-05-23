public with sharing class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIdL){
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> accountList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: accountIdL];

        for(Account acc : accountList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
            accountsToUpdate.add(acc);
        }

        update accountsToUpdate;
    }
}