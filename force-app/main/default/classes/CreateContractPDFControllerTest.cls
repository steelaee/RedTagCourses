@isTest
public with sharing class CreateContractPDFControllerTest {
    @isTest
    private static void createPDFControllerTest(){
        User u = TestDataFactory.createUser('testaskofifjpohgfaisdf@test.com');

        Contact ct = TestDataFactory.createContacts(1, 'TestContact', true)[0];

        Account acc = TestDataFactory.createAccounts(1, 'TestAccount', 'Prospecting', true)[0];

        Contract contr = TestDataFactory.createContract(acc.Id, u.Id, ct.Id);
        Opportunity opp = TestDataFactory.createOppWithProduct('TestOpp', contr.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        CreateContractPDFController pdfController = new CreateContractPDFController(sc);

        System.assertEquals(pdfController.opp.Id, opp.Id);
    }

    @isTest
    private static void generatePDFTest(){
        Opportunity opp = new Opportunity(
            Name = 'TestOpp',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            Discount_Percent__c = 1
        );
        insert opp;

        Id docId = GeneratePDF.generatePDF(opp.Id);

        System.assertEquals(docId, [SELECT contentDocumentId FROM ContentVersion LIMIT 1].contentDocumentId);

    }
}