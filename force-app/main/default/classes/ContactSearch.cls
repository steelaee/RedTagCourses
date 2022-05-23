public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName, String mailingPostalCode){
        List<Contact> contactList = [SELECT Name FROM Contact WHERE LastName =: lastName and MailingPostalCode =: mailingPostalCode];
        return contactList;
    }
}