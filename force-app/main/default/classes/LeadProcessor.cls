global class LeadProcessor implements    Database.Batchable<Sobject> 
{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator([Select LeadSource From Lead ]);
    }

    global void execute(Database.BatchableContext bc, List<Lead> scopes)
    {
            for (Lead Leads : scopes) 
            {
                Leads.LeadSource = 'Dreamforce';
            }
        update scopes;
    }    

    global void finish(Database.BatchableContext bc){   }    
}