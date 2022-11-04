@isTest
private class AccountProcessorTest {
    @isTest
    static void testMethodOne() {
        Account acc = new Account();
        acc.Name='Test Account' ;
        insert acc;

        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Email='demo@demo.com';
        cont.Accountid=acc.id;
        insert cont;
        
        Test.startTest();
        
        List<Id> accList = new List<Id>();
        accList.add(acc.Id);
        AccountProcessor.countContacts(accList);
        Test.stopTest();
        Account accNew = [select Id, Number_of_Contacts__c from Account where Id =: acc.Id LIMIT 1];
        
        System.assertEquals(1, accNew.Number_of_Contacts__c);
        
    }
}