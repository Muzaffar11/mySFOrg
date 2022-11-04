public class CurrencyConverterController {
	public List<SelectOption> CurrFrom{get;set;}
    public List<SelectOption> CurrTo{get;set;}
    public Double CurCount{get;set;}
    public Double  TotalAmount{get;set;}
    
    public string selectedCurrFrom{get;set;}
    public string selectedCurrTo{get;set;}
    
    public CurrencyConverterController() {
    	CurCount =  1;
    	CurrFrom = new List<SelectOption>();
    	CurrTo = new List<SelectOption>();
    	CurrFrom.add(new SelectOption('--Select--', '--Select--'));
        CurrTo.add(new SelectOption('--Select--', '--Select--'));
            
    	selectedCurrFrom = '--Select--';
    	selectedCurrTo = '--Select--';
    	
    	FillDropDowns();
    }
    
    public void FillDropDowns() {
    	
    	Map<String, CurrencyConverter.CountryDetail> AllCountriesMap = CurrencyConverter.getCountryList();
    	if(AllCountriesMap != null && !AllCountriesMap.isEmpty()) {
    		for(String C_Code : AllCountriesMap.KeySet()) {
    			//CurrFrom.add(new SelectOption(C_Code, AllCountriesMap.get(C_Code).currencySymbol));
        		//CurrTo.add(new SelectOption(C_Code, AllCountriesMap.get(C_Code).currencySymbol));
        		String Label = AllCountriesMap.get(C_Code).currencySymbol + ' ' + AllCountriesMap.get(C_Code).currencyName;
        		CurrFrom.add(new SelectOption(AllCountriesMap.get(C_Code).currencyId, Label));
        		CurrTo.add(new SelectOption(AllCountriesMap.get(C_Code).currencyId, Label));
    		}
    	}
    }
    
    public PageReference Calculate() {
    	if(Validation()){
    	
    	try{
    	
	    	Decimal RetAmount = CurrencyConverter.CurrencyConvert(selectedCurrFrom,selectedCurrTo);
	    	
	    	TotalAmount = RetAmount * CurCount;
	    	}
	    	catch(Exception ex){
	    	apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.ERROR,': '+ ex.getMessage()+' Line Number ' + ex.getLineNumber()  ));
	    	}
	    	
    	}
    		
	    	return null; 
    }
    
    
    public boolean Validation(){
    
    if(selectedCurrFrom ==  '--Select--')
    {
      apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.ERROR,'Please select currencyFrom code'));
    	return false;
    
    }
    if(selectedCurrTo ==  '--Select--')
    {
      apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.ERROR,'Please select currencyTo code'));
    	return false;
    
    }
    if(CurCount ==  0 || CurCount ==  null)
    {
      apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.ERROR,'Please enter currency Count'));
    	return false;
    
    }
    return true;
    
    
    
    
    }
    
    
    
	
	

}