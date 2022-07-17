@isTest
private with sharing class CaseServiceTest {
    @isTest
    private static void afterInsertTest(){
        Test.startTest();

        TestDataFactory.createCase();
        System.assertEquals(1, (CaseService.eventList).size());
        
        Test.stopTest();
    }
}
