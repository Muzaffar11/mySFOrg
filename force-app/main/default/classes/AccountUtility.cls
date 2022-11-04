public class AccountUtility {

    public static void viewAnnualRevenue(){
        list<Account> accountsList = new List<Account>();
        accountsList =  [select Id,Name ,	AnnualRevenue from Account];
        
        string acctRev = '';
        for (Account acc : accountsList)
        {
            acctRev =  acc.Name + ':'+ acc.AnnualRevenue;
           system.debug(':: acctRev' + acctRev);
        }
       system.debug(':: acctRev' + acctRev);
        
    }
    
}