public class WorldayApi {

Opportunity opportunity;
public String current_date {get;set;}

public string STRres {get;set;}
public Integer current_year = 0;
public Datetime next_date {get;set;}
  
  
 public WorldayApi(){
 
      Datetime cDT = System.now();
      current_year = cDT.year();
      next_date = System.now().addHours(1);
      current_date = cDT.format('MM/d/yyyy');
      
     System.debug('testing ');
     STRres = '';
      for(string s:ApexPages.currentPage().getParameters().keyset()){
      STRres += s +' = '+ ApexPages.currentPage().getParameters().get(s)+', ';  
    }
    system.debug('::STRres::' +STRres);
  }
   public void init(){
   

   system.debug('::Result Start222::' );
   
   Opportunity objOpp = new Opportunity();
   
  
    string PayStatus   = ApexPages.currentPage().getParameters().get('transStatus');
    string Opname     = ApexPages.currentPage().getParameters().get('futurePayId');
    string Email     = ApexPages.currentPage().getParameters().get('email');
    string rawAuthCode = ApexPages.currentPage().getParameters().get('rawAuthCode');
   // Decimal amount =  Decimal.valueOf(ApexPages.currentPage().getParameters().get('amount '));
    
  
      system.debug('::Result ::' +PayStatus + ' ' + Opname + ' ' +  Email     + ' '+ rawAuthCode  );
    objOpp.name = Opname +'-' + 'Donation' +'-' + current_date;
    objOpp.amount = 5;
    objOpp.CloseDate = Date.today();
    objOpp.stageName = 'Pledged';
     system.debug('::objOpp::' + objOpp);
       insert objOpp;
 
    
    }
 }