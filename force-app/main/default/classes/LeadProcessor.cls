public with sharing class LeadProcessor implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name FROM Lead]);
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> leads = new List<Lead>();

        for(Lead l : scope){
            l.LeadSource = 'DreamForce';
            leads.add(l);
        }

        update leads;
    }

    public void finish(Database.BatchableContext bc){

    }
}