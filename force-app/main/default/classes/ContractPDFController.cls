public with sharing class ContractPDFController {
    
    @AuraEnabled
    public static Id generatePDF(Id recordId){
        PageReference pdf = Page.CreateContractPDF;
        pdf.getParameters().put('id', recordId);
        
        ContentVersion v = new ContentVersion(
            VersionData = pdf.getContentAsPdf(),
            Title = 'Contract',
            PathOnClient = 'Contract.pdf'
        );
        insert v;

        Id docId = [SELECT contentDocumentId FROM ContentVersion WHERE Id=:v.Id].contentDocumentId;
        
        insert new ContentDocumentLink(
            ContentDocumentId = docId,
            ShareType = 'I',
            LinkedEntityId = recordId, 
            Visibility = 'AllUsers'
        );
        
        return docId;
    } 
}