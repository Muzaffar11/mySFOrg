trigger UpdateInvoiceAmountOnContact on Invoice__c (after insert,after  update, after delete) {
    //List<Contact> conList = new List<Contact>();
    Set<Id> conIds = new Set<Id>();
    if(trigger.isDelete) {
        for(Invoice__c inv : Trigger.old) {
            conIds.add(inv.Contact__c);
        }
    } else  {
        for(Invoice__c inv : Trigger.new) {
            conIds.add(inv.Contact__c);
        }
    }
    
    
    List<Contact> conList= [Select Id, Trigger_Paid_Amount__c, Trigger_Pending_Amount__c, 
                            (Select Id, Invoice_Amount__c, Status__c from Invoices__r) 
                            from Contact where ID IN: conIds];
    for(Contact con: conList) {
        Decimal PaidAmount = 0;
        Decimal PendingAmount = 0;
        Decimal PendingInvoices =  0;
        Decimal PaidInvoice =  0;
        if(!con.Invoices__r.isEmpty()) {
            for(Invoice__c inv : con.Invoices__r) {
                if(inv.Status__c == 'Paid') {
                    PaidAmount += inv.Invoice_Amount__c;
                    PaidInvoice++;
                   // PaidInvoice =  PaidInvoice;
                    
                } else {
                    PendingAmount += inv.Invoice_Amount__c;
                    PendingInvoices++;
                    //PendingInvoices =  PendingInvoices;
                }
            }
        }
        con.Trigger_Paid_Amount__c = PaidAmount;
        con.Trigger_Pending_Amount__c = PendingAmount;
        con.Trigger_Paid_Invoices__c = PaidInvoice ;
        con.Tigger_Pending_Invoices__c =  PendingInvoices;
    }
    update conList;
    /*for (Invoice__c i : [select id,Invoice_Amount__c From Invoice__c
                         where Status__c = 'Paid']){
                             conList.add(new Contact(
                                 Trigger_Paid_Amount__c = Trigger_Paid_Amount__c + i.Invoice_Amount__c,
                                 InvoiceId = i.Id));
                         }
    */    
    

}