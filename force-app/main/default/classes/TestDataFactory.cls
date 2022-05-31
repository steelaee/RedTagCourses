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
                opps.add(new Opportunity(
                    Name=acct.Name + ' Opportunity ' + k,
                    StageName='Prospecting',
                    CloseDate=System.today().addMonths(1),
                    AccountId=acct.Id,
                    Discount_Percent__c = 1
                ));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
        return accts;
    }

    public static List<Opportunity> createOppsWithSalesItems(String name, Integer numOpps, Integer siCapacity, Integer numSi){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            opps.add(new Opportunity(
                Name = name,
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(1),
                Sales_Items_Capacity__c = siCapacity, 
                Discount_Percent__c = 1
            ));
        }
        insert opps;

        List<Sales_Item__c> salesItems = new List<Sales_Item__c>();
        for(Opportunity opp : opps){
            salesItems.addAll(createSalesItems('TestOppSi', numSi, opp.Id, true));
        }

        return opps;
    }

    public static List<Sales_Item__c> createSalesItems(String name, Integer numSalesItems, Id oppId, Boolean isInsert){
        List<Sales_Item__c> salesItems = new List<Sales_Item__c>();

        for(Integer i = 0; i < numSalesItems; i++){
            salesItems.add(new Sales_Item__c(
                Name = name + ' ' + i,
                Opportunity__c = oppId
            ));
        }

        if(isInsert){
            insert salesItems;
        }
        return salesItems;
    }
}