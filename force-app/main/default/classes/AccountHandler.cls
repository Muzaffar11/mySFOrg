public class AccountHandler {
	
    public static void insertAccount(Integer value) {
        
        Integer counter = 1;
        List<Account> addAccounts = new List<Account>(); 
        while(counter <= value) {
            System.debug('Counter Value before Incrementing ' + counter);
            
            Account a = new Account();
            a.Name = 'Acme Inc ' + counter;
            a.AccountNumber = 'A000' + counter;
            
            addAccounts.add(a);            
            counter = counter + 1;
        }        
        insert addAccounts;
    }
    
}