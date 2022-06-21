public with sharing class CreateContractPDFExtension {
    public Opportunity opp { get;set;}
    public Contract contr {get;set;}
    public List<OpportunityLineItem> oppProducts {get;set;}
    public List<String> terms {get;set;}
    public String sellerCompanyName {get;set;}
    public String customerName {get;set;}
    
    public CreateContractPDFExtension(ApexPages.StandardController stdController){
        Id oppId = stdController.getRecord().Id;
        opp = [SELECT Name, ContractId FROM Opportunity WHERE Id=:oppId];
        contr = [SELECT CustomerSignedId, CompanySignedId, SpecialTerms FROM Contract WHERE Id=: opp.ContractId LIMIT 1];
        oppProducts = [SELECT Name, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:oppId];
        terms = contr.SpecialTerms.split('\n');
        sellerCompanyName = [SELECT Name FROM User WHERE Id=:contr.CompanySignedId LIMIT 1].Name;
        customerName = [SELECT Name FROM Contact WHERE Id=:contr.CustomerSignedId LIMIT 1].Name;
    }
}
