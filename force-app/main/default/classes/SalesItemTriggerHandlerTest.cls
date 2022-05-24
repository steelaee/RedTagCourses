@isTest
private with sharing class SalesItemTriggerHandlerTest {
    @testSetup
    static void makeData(){
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for(Integer i = 0; i < 2; i++){
            Opportunity opp = new Opportunity(
                Name = 'Testopp ' + i,
                CloseDate = System.Today().addDays(1),
                StageName = 'Prospecting',
                Discount_Percent__c = 1,
                Sales_Items_Capacity__c = 2
            );
            oppsToInsert.add(opp);
        }
        insert oppsToInsert;
    }
    @isTest
    private static void testBeforeInsert(){
        Opportunity opp = [SELECT Name, Sales_Item_Num__c FROM Opportunity WHERE Name=:'Testopp 0'];
        List<Sales_Item__c> listSalesItems = new List<Sales_Item__c>();
        for(Integer i = 0; i < 3; i++){
            Sales_Item__c si = new Sales_Item__c();
            si.Name = 'Testa' + i;
            si.Opportunity__c = opp.Id;
            listSalesItems.add(si);
        }

        try {
            insert(listSalesItems);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Sales Items Capacity is full!'));
        }

        Test.startTest();
        
        listSalesItems.remove(listSalesItems.size() - 1);
        insert listSalesItems;
        
        Test.stopTest();

        System.assertEquals(2, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Id=:opp.Id LIMIT 1].Sales_Item_Num__c);
    }
    
    @isTest
    private static void testBeforeUpdate(){
        List<Opportunity> opps = [SELECT Name, Sales_Item_Num__c FROM Opportunity LIMIT 2];

        Sales_Item__c si = new Sales_Item__c(
            Name = 'Testa 0',
            Opportunity__c = opps[0].Id
        );
        insert si;

        si.Opportunity__c = opps[1].Id;
        update si;
        System.assertEquals(0, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Name=:'Testopp 0'][0].Sales_Item_Num__c);
        System.assertEquals(1, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Name=:'Testopp 1'][0].Sales_Item_Num__c);

        List<Sales_Item__c> listSalesItems = new List<Sales_Item__c>();
        for(Integer i = 0; i < 2; i++){
            Sales_Item__c si2 = new Sales_Item__c();
            si2.Name = 'Testa' + i;
            si2.Opportunity__c = opps[0].Id;
            listSalesItems.add(si2);
        }

        Test.startTest();
        
        insert listSalesItems;

        try {
            for(Sales_Item__c si3 : listSalesItems){
                si3.Opportunity__c = opps[1].Id;
            }

            update listSalesItems;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Sales Items Capacity is full!'));
        }

        Test.stopTest();
        
    }
}