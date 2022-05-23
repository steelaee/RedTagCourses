public with sharing class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Name FROM Lead WHERE LeadSource = NULL LIMIT 200];
        List<Lead> leadsToUpdate = new List<Lead>();

        for(Lead l : leads){
            l.LeadSource = 'DreamForce';
            leadsToUpdate.add(l);
        }

        update leadsToUpdate;
    }
}