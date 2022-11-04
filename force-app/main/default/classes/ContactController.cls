public with sharing class ContactController {

    @AuraEnabled(cacheable = true)
    public static list<Contact> getContacts(){
        try {
            // return[
            //     select FirstName,LastName,Email
            //     from Contact
            // ];
            throw new AuraHandledException('Force Error');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactById(string recordId)
    {
    List<Contact> conList = new List<Contact>();
    System.debug(':: ConId  '+ recordId);
    conList =  [Select Id, Name,MailingCity, MailingStreet,MailingState,MailingPostalCode,MailingCountry
                ,FirstName,LastName, MobilePhone,Department, Email, AccountId
                From Contact Where Id =: recordId limit 1];
  
     return conList;
    } 
}