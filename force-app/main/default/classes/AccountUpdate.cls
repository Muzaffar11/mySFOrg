global class AccountUpdate implements schedulable {
    
  global void execute(SchedulableContext sc) {
      
      integer count = 0 ;  
      List<Account> accList = new List<Account>();
        
	  accList = [Select Id,Name,Rating from Account 
              where IsSchedule__c = true];
      
      if (!accList.isEmpty()){
       for (Account acc :accList ){
       acc.schedulerUpdate__c = 'Update By Scheduler 3';
           count++;
           
       } 
      
          update accList;
      }
      list<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
      
      List<Messaging.SingleEmailMessage> EmailsToSend = new List<Messaging.SingleEmailMessage>();
      
      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      string HTMLBody = 'Hi '+userinfo.getUserName()+', <br/><br/>  ' + count +' Account has been updated';
      mail.setHtmlBody(HTMLBody); 
      mail.SetSubject('Daily Transaction Result');
      list<string> toAddress = new list<string>();
      toAddress.add('muzaffar.beyondvision@gmail.com');
      mail.setToAddresses(toAddress);
      mail.setSaveAsActivity(false);
      mail.setOrgWideEmailAddressId(owa[0].id);
      //mail.setTargetObjectId(userinfo.getUserId());
      EmailsToSend.add(mail);
	        
      Messaging.SendEmailResult[] results = Messaging.sendEmail(EmailsToSend,false);
      
      
      }



    
     /* 
      //public Account AccountDetail {get; set;}
    
    
         
	  
        
         
   //   database.executebatch(b);
   //   

   }

*/
  
}