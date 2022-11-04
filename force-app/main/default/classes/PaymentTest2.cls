@isTest
public class PaymentTest2
{
    static TestMethod void test1()
    {
        
        NewInvoice__c objInv = new NewInvoice__c();
        objInv.Invoice_Amount__c =12000;
        objInv.Invoice_Date__c =Date.today();
        objInv.Status__c ='Paid';
        insert objInv ;
        
        
        NewPayment__c objPay = new NewPayment__c(); 
        objPay.Payment_Amount__c=500;
        objPay.Payment_Date__c=Date.today();
        objPay.Status__c='Paid';
        objPay.NewInvoice__c=objInv.Id ;
        insert objPay;
   
        ApexPages.StandardController stdController = new ApexPages.StandardController(objInv);
        InvoiceDetailController  Invcon= new InvoiceDetailController(stdController);
        Invcon.toggleContent();
        Invcon.PaymentDate =  Date.today();
        Invcon.PAmount =  900;
        Invcon.Status = 'Pending';
        
        Invcon.save();
        
        Invcon.PEditId = objPay.Id;
        Invcon.editPay();
    
        Invcon.update1();
        Invcon.deleteOpp();
        Invcon.getInvoiceDetails();
        
        
       
    }
    
    
     static TestMethod void test209()
    {
        
        NewInvoice__c objInv = new NewInvoice__c();
        objInv.Invoice_Amount__c =12000;
        objInv.Invoice_Date__c =Date.today();
        objInv.Status__c ='Paid';
        insert objInv ;
        
        
        NewPayment__c objPay = new NewPayment__c(); 
        objPay.Payment_Amount__c=500;
        objPay.Payment_Date__c=Date.today();
        objPay.Status__c='Paid';
        objPay.NewInvoice__c=objInv.Id ;
        insert objPay;
   
       ApexPages.StandardController stdController = new ApexPages.StandardController(objInv);
        InvoiceDetailController  Invcon= new InvoiceDetailController(stdController);
        Invcon.toggleContent();
        Invcon.PaymentDate =  Date.today();
       // Invcon.PAmount =  NULL;
        Invcon.Status = 'Pending';
        
        Invcon.save();
        
        Invcon.PEditId = objPay.Id;
        Invcon.editPay();
        Invcon.PAmount =  NULL;
    
        Invcon.update1();
        Invcon.PEditId = NULL;
        Invcon.deleteOpp();
        Invcon.getInvoiceDetails();
    
    }
}