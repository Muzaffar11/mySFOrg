public class InvoiceDetailController {

    public string InvoiceId {get;set;}
    public NewInvoice__c InvoiceDetail {get; set;}
    public List<NewPayment__c> InvoicePayList {get; set;}
 //   public NewPayment__c PaymentDetail {get; set;}
    
    //Public Properties
    public Boolean showContent { get; set; }
    public Boolean btnSave { get; set; }
    public Boolean btnUpdate { get; set; }
     
     public Date PaymentDate{get;set;}
     public Double PAmount{get;set;}
     public string Status{get;set;}
     public string Rating{get;set;}

 	 public string PEditId {get;set;}

    public InvoiceDetailController(ApexPages.StandardController controller) {
    
     //Set the showContent variable to true on page load
        showContent = false;
   	    btnSave= false;
    	btnUpdate= false;
        InvoiceId = controller.getId();
        getInvoiceDetails();
    }

    public void getInvoiceDetails(){
    
        InvoicePayList = new List<NewPayment__c>();
        
        
        InvoiceDetail = [Select Id,Name,Invoice_Amount__c, (Select Id,Name,Payment_Amount__c,Payment_Date__c,Status__c,Rating__c from NewPayments__r)  from NewInvoice__c where Id =: InvoiceId];
        
             
       
        if(!InvoiceDetail.NewPayments__r.isEmpty())
            InvoicePayList = InvoiceDetail.NewPayments__r; 
    
    
    }

    public void toggleContent() {
        //If the showContent variable is true, set it to false, else, set it to true
        showContent = true;
        btnSave = true;
         btnUpdate = false;
        system.debug(':: showContent  '+showContent );
    }
    
    public PageReference save(){
    
    try{
        NewPayment__c objPay = new NewPayment__c();
        objPay.Payment_Amount__c=PAmount;
        objPay.Payment_Date__c=PaymentDate;
        objPay.Status__c=Status;
        objPay.Rating__c=Rating;
        objPay.NewInvoice__c=InvoiceId ;
        insert objPay ;
        getInvoiceDetails();
        
      /*  PageReference pr = new PageReference('/apex/Invoice_Detial?Id='+InvoiceId );
        pr.setRedirect(true);
        return pr;*/
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Invoice Add successfully'));
       
    }
    catch(Exception ex )
    {
    	 Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Record not saved' +  ex.getMessage()));
    }
    
     return null;
        
    }
    
          
    public PageReference update1(){
    
    try{
        NewPayment__c objPay = new NewPayment__c();
        objPay.Payment_Amount__c=PAmount;
        objPay.Payment_Date__c=PaymentDate;
        objPay.Status__c=Status;
        objPay.NewInvoice__c=InvoiceId ;
        objPay.Id =  PEditId;
        update objPay ;
        getInvoiceDetails();
        
      /*  PageReference pr = new PageReference('/apex/Invoice_Detial?Id='+InvoiceId );
        pr.setRedirect(true);
        return pr;*/
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Payment Update successfully'));
       
    }
    catch(Exception ex )
    {
    	 Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Record not saved'));
    }
    
     return null;
        
    }
    
    
    
      public Pagereference editPay(){
      
      showContent = true;
      btnUpdate = true;
      btnSave =  false;
     // String editId= ApexPages.currentPage().getParameters().get('editid'); 
     // system.debug(':: oppid' +oppid);
      
      
      NewPayment__c Pay = [Select id,Payment_Amount__c,Payment_Date__c,Status__c from NewPayment__c where id =:PEditId];
      
      PAmount =  Pay.Payment_Amount__c;
      PaymentDate = Pay.Payment_Date__c;
      Status =  Pay.Status__c;
      //PEditId =  Pay.Id;
      //return new PageReference('/006/e?id='+oppid+'&retURL=/006/');
     return null;
     }
    
     public Pagereference deleteOpp(){
     try{
     
       //  String deleteid= ApexPages.currentPage().getParameters().get('deleteid'); 
       //  system.debug(':: oppid ' +deleteid );
         NewPayment__c  pay = new NewPayment__c ();
         pay.id = PEditId;
         
         delete pay;   
      //InvoicePayList = [Select Id,Invoice_Amount__c, (Select Id,Payment_Amount__c,Payment_Date__c,Status__c from NewPayments__r)  from NewInvoice__c where Id =: InvoiceId];
     /*
     NewPayment__c opp = [Select id from NewPayment__c where id =:oppid];
     if(opp !=null && opp.id !=null){
      delete opp;
     }
    */
    system.debug(':: InvoiceId '+InvoiceId);
    getInvoiceDetails();
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Payment delete successfully'));
    } catch(Exception ex){
        Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'No such combination exists'));
    }
    return null;
    }
   
}