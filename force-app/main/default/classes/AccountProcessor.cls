global  class AccountProcessor {
// Call async from triggers, etc, where callouts are not permitted.
    @future(callout=true)
    global static void countContacts(List<Id> recordIds)
    {
        //List<Account> accounts = [Select Id, Name from Account Where Id IN :recordIds];
        for(Account theAccount : [Select Id, Name from Account Where Id IN :recordIds])
        {
            Integer contactCount =0;
            contactCount= [Select COUNT() FROM Contact WHERE Contact.AccountId = :theAccount.Id];
            System.debug('Account/Count:'+ theAccount.Name +' '+contactCount);
            
            theAccount.Number_of_Contacts__c= contactCount;
            update theAccount;
        }
    }
}