trigger UpdateInvoiceOnNewPayment on NewPayment__c (after insert, after update, after delete, before insert, before update) {
	
	if(trigger.isAfter) {
		
		//Create List for Invoice Update 
		List<NewInvoice__c > lstInv = new List<NewInvoice__c >();
		//Create List for Payment log Update
		List<NewPayment__c> lstPayLog = new List<NewPayment__c>();
		Set<ID> InvIDs = new Set<ID>();
		
		Set<ID> PayId = new Set<ID>(); 
	 	
	    if(trigger.isinsert || trigger.isUpdate){ 
	    	// Get Id for Invoice Update or insert 
	        for(NewPayment__c c : trigger.new){ 
	        	// Add Payment NewInvoice Id 
	            InvIDs.add(c.NewInvoice__c);
	        }
	        // Get Id for Payment Log Update of Insert 
	        for(NewPayment__c p : trigger.new){
	            PayId.add(p.Id);
	             system.debug(':: GetPayId '+PayId);
	        }
	    }
	    else if(trigger.isDelete) {
	    	for(NewPayment__c c : trigger.old){
	            InvIDs.add(c.NewInvoice__c);
	        }
	    }
	     // Check If Payment Id Greater than zero then get list of payment using Invoice Id  
	     if(InvIDs.size() > 0){
	        lstInv = [Select id, Name, Invoice_Amount__c,Status__c,TPaid_Amount__c, 
	        		(Select Id, Name, Payment_Amount__c, Status__c From NewPayments__r) From NewInvoice__c where Id IN: InvIDs limit 50];
	    }
	     
	
	            
	   for(NewInvoice__c inv : lstInv)
	   {
	   		if(inv.TPaid_Amount__c == null)
	   			inv.TPaid_Amount__c = 0;
	   		for(NewPayment__c pay : inv.NewPayments__r) {
	        	if(pay.Status__c == 'Paid' && pay.Payment_Amount__c != null)
	        	{
	            	inv.TPaid_Amount__c += pay.Payment_Amount__c;
	            	system.debug('::Payment_Amount__c' + pay.Payment_Amount__c);
	            }
	   		}
	    }
	    
	        update lstInv ;
	        
	   // Check If Payment Id Greater than zero then get list of payment using Payment Id   
	   if(PayId.size() > 0){
	        
	        lstPayLog = [Select Id, Name, Payment_Amount__c, Status__c From NewPayment__c where Id IN: PayId limit 50]; 
	    }
	    system.debug(':: lstPayLog '+lstPayLog.size());        
	    List<Payment_Log__c> paylogList =  new List<Payment_Log__c>();
	    for(NewPayment__c paylog : lstPayLog){
	    	Payment_Log__c p = new Payment_Log__c();
	   
		   
		     // If Insert Payment than insert payment log with both field (Status and payment amount ) with 'insert' status  
		    if (trigger.isinsert ){
			    p.NewPayments__c = paylog.Id;
			    p.Payment_Status__c =  paylog.Status__c;
			    p.Payment_Amount__c = paylog.Payment_Amount__c;
			    p.Payment_Log_Status__c =  'Insert'; 
			     paylogList.add(p);
			    }
		    else{
		    	// If Update Payment than insert payment log with (Status  ) with 'Update' status  and compaire both old and new value  
		    	
			    if( Trigger.oldMap.get( paylog.Id ).Status__c != Trigger.newMap.get( paylog.Id ).Status__c )
			      {
				    p.NewPayments__c = paylog.Id;
				    p.Payment_Status__c =  paylog.Status__c;
				    p.Payment_Log_Status__c =  'Update'; 
				     paylogList.add(p);
				   }
				 // If Update Payment than insert payment log with (Payment Amount  ) with 'Update' status  and compaire both old and new value  
				if( Trigger.oldMap.get( paylog.Id ).Payment_Amount__c != Trigger.newMap.get( paylog.Id ).Payment_Amount__c )
				  {
				  
				     p.NewPayments__c = paylog.Id;
				     p.Payment_Amount__c = paylog.Payment_Amount__c;
				     p.Payment_Log_Status__c =  'Update'; 
				     paylogList.add(p);
				  }
		  } 
		  
		  
	    
	    }
	    insert paylogList;
	
     }
     
     
     // Check Payment amount with different condition and update or insert their rating      Before Insert and Before Update
     if(trigger.isBefore && (trigger.isUpdate ||  trigger.isInsert)) {
     	
     	for(NewPayment__c c : trigger.new){
     		system.debug(':: Payment_Amount__c '  + c.Payment_Amount__c);
     		if(c.Payment_Amount__c > 800) 
     			c.Rating__c = 'High';
	     	if(c.Payment_Amount__c > 500 && c.Payment_Amount__c < 800 ) 
	     		c.Rating__c = 'Average';
	     	if(c.Payment_Amount__c > 0 && c.Payment_Amount__c < 500 ) 
	     		c.Rating__c = 'Low';
     	}
     	
     	
     }
    
}