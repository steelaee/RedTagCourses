trigger AccountAddressTrigger on Account (after insert, after update) {
    List<Account> acctList = [SELECT Id,Name FROM Account WHERE Id IN :Trigger.New AND Id NOT IN (SELECT AccountId FROM Opportunity)];
    List<Opportunity> oppList = new List<Opportunity>();
    
    for(Account a: acctList){
        oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
                                   StageName='Prospecting',
                                   CloseDate=System.today().addMonths(1),
                                   AccountId=a.Id));
    }
    System.debug(oppList.size());
    if(oppList.size() > 0)
        insert oppList;
}