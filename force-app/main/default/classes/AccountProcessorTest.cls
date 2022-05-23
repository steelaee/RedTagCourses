@isTest
public with sharing class AccountProcessorTest {
    @isTest
    public static void testContactsCount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact cont = new Contact(FirstName = 'Vova', LastName = 'Meda', AccountId = acc.Id);
        Contact cont2 = new Contact(FirstName = 'Yuri', LastName = 'Lytvyn', AccountId = acc.Id);

        insert cont;
        insert cont2;

        List<Id> accountIds = new List<Id>();
        accountIds.add(acc.Id);

        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();
    }
}