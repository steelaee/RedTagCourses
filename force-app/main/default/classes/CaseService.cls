public with sharing class CaseService {
    public static List<Case_Create__e> eventList = new List<Case_Create__e>();

    public static void publishEventOnCaseCreate(List<Case> cases){
        String branchNum = [
            SELECT Branch_Number__c
            FROM User
            WHERE Id =: UserInfo.getUserId()
            LIMIT 1
        ].Branch_Number__c;
        
        List<Case_Create__e> events = new List<Case_Create__e>();

        for(Case cs : cases){
            eventList.add(new Case_Create__e(
                Branch_Number__c = cs.Branch_Number__c
            ));
        }
        
        EventBus.publish(eventList);
    }
    
    @AuraEnabled
    public static List<Case> getCases(String branchNum) {
        return [
            SELECT Id, CaseNumber, Status, CreatedDate, Type, Subject, Branch_Number__c
            FROM Case
            WHERE Branch_Number__c =: branchNum
            ORDER BY CreatedDate
        ];
    }
    
    @AuraEnabled
    public static void changeCaseStatus(String caseId){
        Case cs = new Case();
        cs.Id = caseId;
        cs.Status = 'In Progress';
        
        update cs;
    }
}