@isTest
public class TestRestrictContactByName {
    @isTest static void Test1(){
        Contact c = new Contact(LastName = 'INVALIDNAME');
       
        Database.SaveResult res = Database.insert(c);
       	System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML', res.getErrors()[0].getMessage());
    }
}