public class AwesomeCalculator {
    
    public static Double Add (Double x , Double y){
        
        calculatorServices.CalculatorImplPort Calculator =  new calculatorServices.CalculatorImplPort();
        
       return Calculator.doAdd(x,y);

    }
}