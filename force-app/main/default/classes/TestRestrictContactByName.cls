@isTest
public class TestRestrictContactByName {
  @isTest static void TestContactWithInvalidName() {
        // Test data setup
        // Create an account with an opportunity, and then try to delete it
        Contact acct = new Contact(LastName='INVALIDNAME',Email='test@gmail.com');
        //insert acct;
      	Test.startTest();
        Database.SaveResult result = Database.insert(acct, false); 	
        Test.stopTest();   
   		System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             result.getErrors()[0].getMessage());

    }
    

}