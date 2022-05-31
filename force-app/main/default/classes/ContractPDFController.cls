public with sharing class ContractPDFController {
    private Opportunity opp { get;set;}
    private Contract contr {get;set;}
    public List<OpportunityLineItem> oppProducts {get;set;}
    public List<String> terms {get;set;}
    public String sellerCompanyName {get;set;}
    public String customerName {get;set;}
    String fullUrl;
    public ContractPDFController(ApexPages.StandardController stdController){
        opp = [SELECT Name, ContractId FROM Opportunity WHERE Id=:((Opportunity)stdController.getRecord()).Id LIMIT 1];
        contr = [SELECT CustomerSignedId, CompanySignedId, SpecialTerms FROM Contract WHERE Id=: opp.ContractId LIMIT 1];
        oppProducts = [SELECT Name, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opp.Id];
        terms = contr.SpecialTerms.split('\n');
        sellerCompanyName = [SELECT Name FROM User WHERE Id=:contr.CompanySignedId LIMIT 1].Name;
        customerName = [SELECT Name FROM Contact WHERE Id=:contr.CustomerSignedId LIMIT 1].Name;
    }
    @AuraEnabled
    public static Blob generatePDF(){
        
        String fullUrl = URL.getSalesforceBaseUrl().toExternalForm() + 
            '/apex/CreateContractPDF?core.apexpages.request.devconsole=1&id=' + ApexPages.currentPage().getParameters().get('Id');

        PageReference p = new PageReference(fullUrl);

        try {
            ContentVersion v = new ContentVersion();
            v.versionData = p.getContentAsPdf();
            v.title = 'Contr.pdf';
            v.pathOnClient = 'Contr.pdf';
            insert v;

            String versionId = [SELECT contentDocumentId FROM ContentVersion WHERE Id=:v.Id].contentDocumentId;
            ContentDocumentLink docLink = new ContentDocumentLink();
            docLink.contentDocumentId = versionId;
            docLink.shareType = 'I';
            docLink.linkedEntityId = ApexPages.currentPage().getParameters().get('Id');
            docLink.visibility = 'AllUsers';

            insert docLink;
        } catch (Exception e) {
            System.debug(e.getmessage());
        }
        return p.getContentAsPdf();
    }
}