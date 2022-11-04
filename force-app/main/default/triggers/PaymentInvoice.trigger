trigger PaymentInvoice on Payment__c (before insert) {

    Set<Id> invids =  new Set<Id>(); 
    for (Payment__c pay : trigger.new) {
        invids.add(pay.Invoice__c);
    }
    List<Invoice__c>  invList = [select id,Invoice_Amount__c from invoice__c where id in : invids];
    Map<id,decimal> inbmap =  new map<ID,decimal>();
    for (Invoice__c i : invList){
        inbmap.put(i.Id,i.Invoice_Amount__c);
    }
    
    for (Payment__c pay : trigger.new) {
        decimal invamt = inbmap.get(pay.Invoice__c);
        if(pay.Payment_Amount__c > invamt) {
            pay.AddError('Payment Amount is greater than Invoice amount');
        }
    }
}