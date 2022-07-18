@isTest
private with sharing class CaseServiceTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createCase();
    }

    @isTest
    private static void afterInsertTest(){
        Test.startTest();

        TestDataFactory.createCase();
        System.assertEquals(1, (CaseService.eventList).size());
        
        Test.stopTest();
    }
    @isTest
    private static void getCasesTest(){
        User u = TestDataFactory.createUser('bruh@acme.com', true);
        u.Branch_Number__c = '003';

        Test.startTest();
        System.runAs(u){
            System.assertEquals('0003', CaseService.getCases(u.Branch_Number__c)[0].Branch_Number__c);
        }
        Test.stopTest();
    }
    
    @isTest
    private static void changeCaseStatusTest(){
        Id caseId = [
            SELECT Id 
            FROM Case
            LIMIT 1
        ].Id;

        Test.startTest();

        CaseService.changeCaseStatus(caseId);
        System.assertEquals('In Progress', [SELECT Status FROM Case LIMIT 1].Status);
        
        Test.stopTest();
    }
}