@isTest
public with sharing class AccountTriggerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.generateAccounts(1, 'Illia');
    }

    @isTest
    public static void testBeforeInsert(){
        Test.startTest();
        Account acc = [SELECT Name, CreatedDate FROM Account LIMIT 1];
        Opportunity opp = [SELECT Name, CloseDate FROM Opportunity WHERE AccountId =: acc.Id LIMIT 1];
        Test.stopTest(); 
        
        System.assertEquals(acc.Name + ' ' + date.today().month() + ' ' + date.today().year(), opp.Name);
        System.assertEquals(acc.CreatedDate.addDays(90).day(), opp.CloseDate.day());
        System.assertEquals(acc.CreatedDate.addDays(90).month(), opp.CloseDate.month());
        System.assertEquals(acc.CreatedDate.addDays(90).year(), opp.CloseDate.year());
    } 

    @isTest
    public static void testAfterUpdate(){
        Account acc = [SELECT Name, CreatedDate FROM Account LIMIT 1];
        acc.Name = 'Illia0New';

        Test.startTest();
        update acc;
        System.assertEquals('Illia0New ' + acc.CreatedDate.month() + ' ' + acc.CreatedDate.year(), [SELECT Name FROM Opportunity WHERE AccountId =: acc.Id LIMIT 1].Name);
        Test.stopTest();
    }

    @isTest
    public static void testBeforeDelete(){
        List<Account> accs = [SELECT Name FROM Account LIMIT 5];

        Test.startTest();
        delete accs;
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId =: accs[0].Id];
        System.assert(true, opps.isEmpty());
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
    }
}