@isTest
public with sharing class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 6 ? 2022';

    @IsTest
    static void testScheduledJob(){
        List<Lead> leads = new List<Lead>();

        for(Integer i = 0; i < 200; i++){
            Lead l = new Lead(LastName = 'Last ' + i, Company = 'The Test Inc.');
            leads.add(l);
        }
        insert leads;

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();
        
    }
}