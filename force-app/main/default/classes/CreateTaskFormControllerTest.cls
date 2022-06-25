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
        Id campaignId = '7017Q0000018gZJQAY';

        Test.startTest();
        CreateTaskFormController.createTask(campaignId, UserInfo.getUserId(), 'some description', Date.today());
        List<Task> tasks = [
            SELECT Id 
            FROM Task 
            WHERE WhatId=:campaignId AND OwnerId=:UserInfo.getUserId() AND ActivityDate=: Date.today()
        ];
        System.assertEquals(1, tasks.size());
        Test.stopTest();
    }
}