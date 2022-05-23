@isTest
public with sharing class AddPrimaryContactTest {
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        
        for(Integer i = 0; i < 50; i++){
            ACcount acc = new Account();
            acc.Name = 'Test account NY ' + i;
            acc.BillingState = 'NY';

            accounts.add(acc);
        }

        insert accounts;
        accounts.clear();

        for(Integer i = 0; i < 50; i++){
            ACcount acc = new Account();
            acc.Name = 'Test account CA ' + i;
            acc.BillingState = 'CA';

            accounts.add(acc);
        }

        insert accounts;
    }

    @IsTest
    static void testQueueable(){
        
        Contact testContact = new Contact(LastName = 'Test Last Name');
        insert testContact;

        AddPrimaryContact apc = new AddPrimaryContact(testContact, 'NY');

        Test.startTest();
        System.enqueueJob(apc);
        Test.stopTest();
        
    }
}