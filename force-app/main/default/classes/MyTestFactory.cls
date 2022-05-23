@isTest
public with sharing class MyTestFactory {
    public static void generateAccounts(Integer num, String name){
        
        List<Account> accs = new List<Account>();

        for(Integer i = 0; i < num; i++){
            Account acc = new Account(Name=name + i);
            accs.add(acc);
        }
        insert accs;
    }
}