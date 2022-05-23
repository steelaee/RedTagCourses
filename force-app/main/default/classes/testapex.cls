public with sharing class testapex {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(){
        return [
            SELECT Id, FirstName, LastName, Email FROM Contact LIMIT 10
        ];
    }
}