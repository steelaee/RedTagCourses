public class StringArrayTest7 {
    public static void generateStringArray(){
        // Create the account sObject 
Account acct = new Account(Name='Acme', Phone='(415)555-1212', NumberOfEmployees=100);
// Insert the account by using DML
insert acct;
// Get the new ID on the inserted sObject argument
ID acctID = acct.Id;
// Display this ID in the debug log
System.debug('ID = ' + acctID);
// Debug log result (the ID will be different in your case)
// DEBUG|ID = 001D000000JmKkeIAF
    }
}