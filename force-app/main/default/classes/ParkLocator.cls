public class ParkLocator {
    
    public static string[] country (string CName){
           // calculatorServices.CalculatorImplPort Calculator =  new calculatorServices.CalculatorImplPort();
        
         ParkService.ParksImplPort p = new ParkService.ParksImplPort();
        string[] ParkList =  p.byCountry(CName);
       return ParkList;
        
        
    }

}