trigger AccountDeletion on Account (before delete) {
// Prevent the deletion of accounts if they have related opportunities.
    for(Account a : [select Id from Account
                 where id in (select Accountid from Opportunity) 
                  and Id IN :Trigger.old])
        {
        Trigger.oldMap.get(a.Id).addError(
            'Cannot delete account with related opportunities.');
    }
    
}