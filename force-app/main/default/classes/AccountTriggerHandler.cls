public class AccountTriggerHandler 
{
    public static void CreateAccounts(List<Account> acclist)
    {
        for(Account account : acclist)
        {
            if(account.ShippingState!=account.BillingState)
            {
                account.ShippingState = account.BillingState; // you need to update ShippingState
            }
        }
    }
}