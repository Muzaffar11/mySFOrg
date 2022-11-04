trigger ClosedOpportunityTrigger on Opportunity (before insert) {
 List<Task> taskListToInsert = new List<Task>();
    
    for (Opportunity o :trigger.new){
        if (o.StageName == 'Closed Won'){
             Task t= new Task();
              t.subject =  'Follow Up Test Task';
              t.WhatId=o.Id;
              taskListToInsert.add(t);
            
        }
        
    }
    if (taskListToInsert.size() > 0){
      insert  taskListToInsert;
    }
}