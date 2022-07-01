@isTest
private with sharing class CreateTaskFormControllerTest {
    @isTest
    private static void testGetTaskSubjectValues(){
        Test.startTest();

        Schema.DescribeFieldResult field = Task.Subject.getDescribe();
        List<Schema.PicklistEntry> ple = field.getPicklistValues();
        List<String> fieldValues = new List<String>();
        for( Schema.PicklistEntry pickListVal : ple){
            fieldValues.add(pickListVal.getLabel());
        }     

        Integer num = CreateTaskFormController.getTaskSubjectValues().size();
        System.assertEquals(fieldValues.size(), num);
        Test.stopTest();
    }
    @isTest
    private static void testCreateTask(){

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

        
        Campaign cgn = new Campaign(
            Name = 'TestCampaign'
        );

        Test.startTest();
        insert cgn;
        insert u;

        CreateTaskFormController.createTask(cgn.Id, u.Id, 'some description', Date.today());
        List<Task> tasks = [
            SELECT Id 
            FROM Task 
            WHERE WhatId=:cgn.Id AND OwnerId=:u.Id AND ActivityDate=: Date.today()
        ];
        
        System.assertEquals(1, tasks.size());
        Test.stopTest();
    }
}