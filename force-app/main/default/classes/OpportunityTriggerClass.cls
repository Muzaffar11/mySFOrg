public class OpportunityTriggerClass {
    
    public static void check_opp(List<Opportunity> ops)
    {
        Double Total_Amount =  0;
        for(Opportunity ol :[Select Amount from Opportunity where createdDate =  TODAY
                             AND CreatedbyID =  :UserInfo.getUserID()]){
                                 if (ol.Amount != null)     {Total_Amount += ol.Amount;  }                 
                               
          }
        for (Opportunity op2 : ops){
            Total_Amount += op2.Amount;
            if (Total_Amount > 1000){
                op2.adderror('You have exceed today amount');
            }
        }
    }

}