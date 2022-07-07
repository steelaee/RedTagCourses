@isTest
private with sharing class CaseTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createCases(3);
    }
    @isTest
    private static void afterUpdateTest() {
        List<Case> cases = [
            SELECT Status
            FROM Case
        ];
        
        for(Case c : cases){
            c.Status = 'In Progress';
        }
        update cases;

        System.assertEquals(3, CaseTriggerService.eventList.size());
    }
}
