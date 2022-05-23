public class AccountHandler {
    public static Account insertNewAccount(String inpName){
        try{
			Account acct = new Account(Name=inpName);
        	insert acct;
        	return acct;
        }
        catch(DMLException e){
            return null;
        }
    }
}