public with sharing class AddPrimaryContact implements Queueable {
    Contact cont;
    String stateAbb;

    public AddPrimaryContact(Contact ct, String stateAb){
        cont = ct;
        stateAbb = stateAb;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account WHERE BillingState =: stateAbb LIMIT 200];
        List<Contact> contacts = new List<Contact>();

        for(Account acc : accounts){
            Contact c = cont.clone();
            c.AccountId = acc.Id;
            contacts.add(c);
        }

        insert contacts;
    }
}