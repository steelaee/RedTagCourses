@isTest
private with sharing class SalesItemTriggerHandlerTest {

    @testSetup
    static void makeData(){
        TestDataFactory.createOppsWithSalesItems('TestOpp', 2, 2, 1);
    }
    @isTest
    private static void testBeforeInsert(){
        List<Opportunity> opps = [SELECT Name, Sales_Item_Num__c FROM Opportunity LIMIT 2];
        try {
            TestDataFactory.createSalesItems('TestSalesItem', 2, opps[0].Id, true);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Sales Items Capacity is full!'));
        }

        Test.startTest();

        TestDataFactory.createSalesItems('TestOppSi2', 1, opps[1].Id, true);
        System.assertEquals(2, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Id=:opps[1].Id].Sales_Item_Num__c);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testBeforeUpdate(){
        List<Opportunity> opps = [SELECT Name, Sales_Item_Num__c FROM Opportunity LIMIT 2];

        Sales_Item__c si = TestDataFactory.createSalesItems('TestSalesItem', 1, opps[0].Id, true)[0];
        si.Opportunity__c = opps[1].Id;
        update si;

        System.assertEquals(1, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Id =: opps[0].Id][0].Sales_Item_Num__c);
        System.assertEquals(2, [SELECT Sales_Item_Num__c FROM Opportunity WHERE Id =: opps[1].Id][0].Sales_Item_Num__c);

        Test.startTest();
        
        List<Sales_Item__c> salesItems = TestDataFactory.createSalesItems('TestSalesItem2', 2, opps[0].Id, true);

        try {
            for(Sales_Item__c si2 : salesItems){
                si2.Opportunity__c = opps[1].Id;
            }

            update salesItems;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Sales Items Capacity is full!'));
        }

        Test.stopTest();
        
    }
}