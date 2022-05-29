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
    public void generatePDF(){
        String baseUrl = ApexPages.currentPage().getHeaders().get('Host');
        String urlValue = ApexPages.currentPage().getUrl(); 
        fullUrl = URL.getSalesforceBaseUrl().toExternalForm() + 
            '/apex/CreateContractPDF?core.apexpages.request.devconsole=1&id=' + opp.Id;

        insert new Attachment(
            ContentType = 'application/pdf',
            Name = 'Contract.pdf',  
            ParentId = opp.Id,
            Body = new PageReference(fullUrl).getContentAsPdf()
        );
    }
    public PageReference showPreview(){
        generatePDF();
        PageReference p = new PageReference(fullUrl);
        p.setRedirect(true);
        return p;
    }
}