public class AccountUtils {
    public static List<Account> accountsByState(String state)
    {
        return [SELECT Id, Name, BillingState FROM Account WHERE BillingState=:state];
    }
}