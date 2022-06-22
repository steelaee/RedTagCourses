public with sharing class CreateTaskFormController {
    @AuraEnabled
    public static List<String> getTaskSubjectValues(){
        Map<String, String> pickListValuesList= new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Task.Subject.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.put(pickListVal.getLabel(), pickListVal.getValue());
        }     
        return pickListValuesList.values();
    }

    @AuraEnabled
    public static void createTask(Id campaignId, Id assignId, String description, Date dueDate){
        Task taskToInsert = new Task(
            WhatId = campaignId,
            OwnerId = assignId,
            Description = description,
            ActivityDate = dueDate,
            Subject = 'Call',
            Priority = 'Normal',
            Status = 'Not Started'
        );
        
        insert taskToInsert;
    }
}