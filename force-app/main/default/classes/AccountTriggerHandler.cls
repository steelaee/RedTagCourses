public with sharing class AccountTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        
        for(Account acc : (List<Account>)Trigger.New){
            Opportunity opp = new Opportunity(Name=acc.Name + ' ' + date.today().month() + ' ' + date.today().year(), 
            StageName='Prospecting', CloseDate=System.today().addDays(90), AccountId=acc.Id, Discount_Percent__c=0.6, Amount = 1);
            System.debug(acc.Id);
            oppsToInsert.add(opp);
        }

        insert oppsToInsert;
    }
    public override void afterUpdate() {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<Id, Account> myMap = new Map<Id, Account>();

        for(Account acc : (List<Account>)Trigger.New){
            if(acc.Name != ((Map<Id, Account>)Trigger.OldMap).get(acc.Id).Name){
                myMap.put(acc.Id, acc);
            }
        }
        
        List<Opportunity> oppsNew = [
            SELECT Name, AccountId 
            FROM Opportunity 
            WHERE AccountId IN :myMap.keySet()
        ];

        for(Opportunity opp : oppsNew){
            if(!opp.Name.contains(myMap.get(opp.AccountId).Name)){
                opp.Name = myMap.get(opp.AccountId).Name + ' ' + myMap.get(opp.AccountId).CreatedDate.month() + ' ' + myMap.get(opp.AccountId).CreatedDate.year();
                oppsToUpdate.add(opp);
            }
        }

        update oppsToUpdate;
    }
    public override void beforeDelete() {
        List<Opportunity> oppsToDelete = [
            SELECT Name, Amount, AccountId 
            FROM Opportunity 
            WHERE AccountId IN :((Map<Id, Account>)Trigger.OldMap).keySet()
        ];

        EmailTemplate et = [
            SELECT id, body, subject 
            FROM EmailTemplate 
            WHERE Name =: 'Account Deletion Template' 
            LIMIT 1
        ];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTemplateId(et.Id);
        User activeUser = [
            SELECT Email 
            FROM User 
            WHERE UserName =: UserInfo.getUserName() 
            LIMIT 1
        ];
        message.setTargetObjectId(activeUser.Id);
        message.saveAsActivity = false;

        String opps_list = '';
        Integer i = 0;
        
        for(Account acc : (List<Account>)Trigger.Old){
            for(Opportunity opp : [SELECT Name, Amount FROM Opportunity WHERE AccountId=:acc.Id]){
                i++;
                opps_list += i + '. ' + opp.id + ', ' + opp.Name + ', ' + opp.amount + '.\n';
            }
            String htmlBody = et.body;
            htmlBody =  htmlBody.replace('{AccountName}', acc.Name);
            htmlBody = htmlBody.replace('{opps_list}', opps_list);
            htmlBody = htmlBody.replace('{BestRegards}', Label.best_regards);
            message.setPlainTextBody(htmlBody);
            message.setToAddresses(new String[] {activeUser.Email});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});
            opps_list = '';
            i = 0;
        }

        delete oppsToDelete;
    }
}