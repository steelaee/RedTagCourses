public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer cNum, String cLastName){
		List<Contact> contList = new List<Contact>();
        for(Integer i = 1; i < cNum + 1; i++){
            contList.add(new Contact(FirstName='Test ' + i, LastName = cLastName));
        }
        
        return contList;
   }
}