public with sharing class CaseController {
    @AuraEnabled
    public static List<Case> getCases() {
        String branchNum = [
            SELECT Branch_Number__c
            FROM User
            WHERE Id =: UserInfo.getUserId()
            LIMIT 1
        ].Branch_Number__c;

        return [
            SELECT Id, CaseNumber, Status, CreatedDate, Type, Subject, Branch_Number__c
            FROM Case
            WHERE Branch_Number__c =: branchNum
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
