@isTest
public with sharing class LeadProcessorTest {
    @TestSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead lead = new Lead();
            lead.LastName = 'Test lead ' + i;
            lead.Company = 'Test lead company ' + i;
            leads.add(lead);
        }

        insert leads;
    }
    @isTest
    public static void test(){
        Test.startTest();
        LeadProcessor myBatchObj = new LeadProcessor();
        Id batchId = Database.executeBatch(myBatchObj);
        Test.stopTest();

    }
}