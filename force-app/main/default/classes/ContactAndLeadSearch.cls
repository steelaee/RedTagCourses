public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(String namePart){
        List<List<sObject>> myList = [FIND :namePart IN NAME FIELDS RETURNING Contact(Name), Lead(Name)];
        return myList;
    }
}