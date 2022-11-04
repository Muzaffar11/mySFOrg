public class PropertyUtility {
    
    
    Public static void newListedProperties(){
        list<Property__c> newPropList = new list<Property__c>();
            
        newPropList = [select Name,Broker__r.Email__c,Days_On_Market__c from Property__c where Date_Listed__c <= LAST_N_DAYS:30];
        
        for(Property__c pro : newPropList){
            string propEmail;
            propEmail = pro.Name + ':' + pro.Broker__r.Email__c;
                system.debug(':: propEmail' + propEmail); 
         }
    }

}