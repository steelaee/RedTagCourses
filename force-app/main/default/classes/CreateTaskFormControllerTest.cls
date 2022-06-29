@isTest
private with sharing class CreateTaskFormControllerTest {
    @isTest
    private static void testGetTaskSubjectValues(){
        Test.startTest();
        Integer num = CreateTaskFormController.getTaskSubjectValues().size();
        System.assertEquals(5, num);
        Test.stopTest();
    }
    @isTest
    private static void testCreateTask(){
        Id campaignId = [
            SELECT Id 
            FROM Campaign
            LIMIT 1
        ].Id;

        Profile p = [
            SELECT Id 
            FROM Profile 
            WHERE Name='Sales manager'
        ];
        User u = new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName= 'uniqueUserName123123123'
        );

        Test.startTest();
        insert u;
        CreateTaskFormController.createTask(campaignId, u.Id, 'some description', Date.today());
        List<Task> tasks = [
            SELECT Id 
            FROM Task 
            WHERE WhatId=:campaignId AND OwnerId=:u.Id AND ActivityDate=: Date.today()
        ];
        System.assertEquals(1, tasks.size());
        Test.stopTest();
    }
}