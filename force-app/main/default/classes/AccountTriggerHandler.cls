public with sharing class AccountTriggerHandler extends TriggerHandler {
    List<Account> newAccs;
    List<Account> oldAccs;
    Map<Id, Account> mapOldAccs = (Map<Id, Account>)Trigger.OldMap;
    public AccountTriggerHandler(){
        newAccs = (List<Account>)Trigger.New;
        mapOldAccs = (Map<Id, Account>)Trigger.OldMap;
        oldAccs = (List<Account>)Trigger.Old;
    }

    public override void afterInsert() {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        
        for(Account acc : newAccs){
            Opportunity opp = new Opportunity(Name=acc.Name + ' ' + date.today().month() + ' ' + date.today().year(), 
            StageName='Prospecting', CloseDate=System.today().addDays(90), AccountId=acc.Id, Discount_Percent__c=0.6, Amount = 1);
            System.debug(acc.Id);
            oppsToInsert.add(opp);
        }

        insert oppsToInsert;
    }
    public override void afterUpdate() {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<Id, Account> mapUpdatedAccsById = new Map<Id, Account>();

        for(Account acc : newAccs){
            if(acc.Name != mapOldAccs.get(acc.Id).Name){
                mapUpdatedAccsById.put(acc.Id, acc);
            }
        }
        
        List<Opportunity> oppsNew = [
            SELECT Name, AccountId 
            FROM Opportunity 
            WHERE AccountId IN :mapUpdatedAccsById.keySet()
        ];

        for(Opportunity opp : oppsNew){
            if(!opp.Name.contains(mapUpdatedAccsById.get(opp.AccountId).Name)){
                opp.Name = mapUpdatedAccsById.get(opp.AccountId).Name + ' ' + mapUpdatedAccsById.get(opp.AccountId).CreatedDate.month() + ' ' + mapUpdatedAccsById.get(opp.AccountId).CreatedDate.year();
                oppsToUpdate.add(opp);
            }
        }

        update oppsToUpdate;
    }
    public override void beforeDelete() {
        List<Opportunity> oppsToDelete = [
            SELECT Name, Amount, AccountId 
            FROM Opportunity 
            WHERE AccountId IN : mapOldAccs.keySet()
        ];

        // Map<Id, List<Opportunity>> mapOppsByAccId = new Map<Id, List<Opportunity>>();

        // for(Opportunity opp : oppsToDelete){
        //     if(!mapOppsByAccId.containsKey(opp.AccountId)){
        //         mapOppsByAccId.put(opp.AccountId, new List<Opportunity>());
        //     }
        //     mapOppsByAccId.get(opp.AccountId).add(opp);
        // }

        Map<Id, List<String>> mapOppDescByAccId = new Map<Id, List<String>>();
        
        for(Opportunity opp : oppsToDelete){
            if(!mapOppDescByAccId.containsKey(opp.AccountId)){
                mapOppDescByAccId.put(opp.AccountId, new List<String>());
            }
            mapOppDescByAccId.get(opp.AccountId).add(opp.id + ', ' + opp.Name + ', ' + opp.amount);
        }

        EmailTemplate et = [
            SELECT id, body, subject 
            FROM EmailTemplate 
            WHERE Name =: 'Account Deletion Template' 
            LIMIT 1
        ];
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

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
        message.setToAddresses(new String[] {activeUser.Email});
        
        for(Account acc : oldAccs){
            // String opps_list = '';
            // Integer i = 0;
            // for(Opportunity opp : mapOppsByAccId.get(acc.Id)){
            //     i++;
            //     opps_list += i + '. ' + opp.id + ', ' + opp.Name + ', ' + opp.amount + '.\n';
            // }

            String s = String.join(mapOppDescByAccId.get(acc.Id), '\n');
            
            String htmlBody = et.body;
            htmlBody =  htmlBody.replace('{AccountName}', acc.Name);
            htmlBody = htmlBody.replace('{opps_list}', s);
            htmlBody = htmlBody.replace('{BestRegards}', Label.best_regards);
            message.setPlainTextBody(htmlBody);

            messages.add(message);
        }
        
        Messaging.sendEmail(messages);

        delete oppsToDelete;
    }
}