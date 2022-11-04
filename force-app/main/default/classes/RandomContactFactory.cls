public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numCon,String LName){
      List<Contact> Con = new List<Contact>();
        
        for(Integer i=0;i<numCon;i++) {
        Contact c = new Contact( FirstName = 'Test '+i,LastName=LName);
        Con.add(c);
      }
        
         Return Con;
    }

}