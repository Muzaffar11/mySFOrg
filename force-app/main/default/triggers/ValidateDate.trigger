trigger ValidateDate on Invoice__c (before insert, before update) {

    For (Invoice__c  i : trigger.new){
        If(Trigger.isinsert && i.Invoice_Date__c > Date.TODAY()){
            i.addError('Date is not greater than today');
        }
       else If(Trigger.isupdate && i.Invoice_Date__c > Date.TODAY()){
            i.addError('Date is not greater than today');
        }
    }
}