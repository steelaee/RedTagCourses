public with sharing class GeneratePDF {
    @AuraEnabled
    public static Id generatePDF(Id recordId){
        PageReference pdf = Page.CreateContractPDF;
        pdf.getParameters().put('id', recordId);
        
        Blob b;
        if(!Test.isRunningTest()){
            b = pdf.getContentAsPdf();
        }
        else{
            b = Blob.valueOf('TEST');
        }

        ContentVersion v = new ContentVersion(
            VersionData = b,
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