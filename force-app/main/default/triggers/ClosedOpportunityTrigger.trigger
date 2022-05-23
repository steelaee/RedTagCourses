trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> taskList = new List<Task>();
    
    for(Opportunity op : Trigger.New){
        if(op.StageName == 'CLosed Won')
            taskList.add(new Task(Subject='Follow Up Test Task', WhatId=op.Id));
    }
    if(taskList.size() >0)
    	insert taskList;
}