@isTest
public class TestDataFactory {
    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
        return accts;
    }
    public static Opportunity createOppWithProduct(String oppName, Id contrId){
        Id stPriceBookId = Test.getStandardPricebookId();

        Product2 product = new Product2(
            Name = oppName
        );
        insert product;

        PricebookEntry standartPrice = new PricebookEntry(
            Pricebook2Id = stPriceBookId, 
            Product2Id = product.Id,
            UnitPrice = 10000,
            IsActive = true
        );
        insert standartPrice;

        Pricebook2 pricebook = new Pricebook2(
            Name = 'Test Pricebook',
            IsActive = true
        );
        insert pricebook;

        PricebookEntry price = new PricebookEntry(
            Pricebook2Id = pricebook.Id,
            Product2Id = product.Id, 
            UnitPrice = 12000,
            IsActive = true
        );
        insert price;

        Opportunity opp = new Opportunity(
            Name = 'TestOpp',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            Discount_Percent__c = 1,
            ContractId = contrId,
            Pricebook2Id = pricebook.Id
        );
        insert opp;

        OpportunityLineItem oppProduct = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = product.Id,
            Quantity = 5,
            UnitPrice = 10,
            PricebookEntryId = price.Id
        );
        insert oppProduct;

        return opp;
    }
    public static User createUser(String username){
        User u = new User(
            LastName = 'TestUser',
            Email = 'iroshchik03@gmail.com',
            Alias = 'Tcode',
            Username = username,
            CommunityNickname = 'test6431',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'GMT',
            ProfileID = '00e7Q000002idywQAA',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8'
        );
        insert u;

        return u;
    }
    public static Contract createContract(Id accId, Id companySignedId, Id customerSignedId){
        Contract contr = new Contract(
            AccountId = accId,
            Status = 'Draft',
            StartDate = System.today(),
            ContractTerm = 1,
            SpecialTerms = 'first \n second',
            CompanySignedId = companySignedId,
            CustomerSignedId = customerSignedId
        );
        insert contr;
        return contr;
    }
}