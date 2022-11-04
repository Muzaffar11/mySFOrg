global class CurrencyConverter {
    
    
    public class CountryDetail {
    	public String alpha3;
    	public String currencyId;
    	public String currencyName;
    	public String currencySymbol;
    	public String id;
    	public String name;
    }
    
 	public static Decimal CurrencyConvert(String CurrFrom,String CurrTo){
       
       Decimal outputVal = 0;
       try{ 
       	
       	If(CurrFrom != NULL && CurrFrom != '' && CurrTo!= NULL && CurrTo!= ''){
          Http http = new Http();
           HttpRequest request = new HttpRequest();
           
            string curr = CurrFrom + '_' + CurrTo;
           
            request.setEndpoint('https://free.currconv.com/api/v7/convert?q=' + curr + '&compact=ultra&apiKey=bdcd74581675710a2d4e');
 		

	       request.setMethod('GET');
           HttpResponse response = http.send(request); 
           system.debug(response);
           system.debug('::response.getBody::' + response.getBody());
            // Deserializes the JSON string into collections of primitive data types.
           Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
           System.debug(results);
           
          
           outputVal = (decimal)results.get(curr);
       	}
          // return TotalAmount; 
       }
       catch(exception ex)
       {
       	
       }
       return outputVal;
    }
   
    public static Map<String, CountryDetail> getCountryList() {
    	Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://free.currconv.com/api/v7/countries?apiKey=bdcd74581675710a2d4e');
		request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            
            
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(results.get('results'));
            Map<String, Object> FinalResult = (Map<String, Object>) results.get('results');
            System.debug(FinalResult.get('AD'));
            
            Map<String, CountryDetail> returnMap = new Map<String, CountryDetail>();
            // KeySet  =   Map Key like (AD,AF etc) 
            
            for(String coCode: FinalResult.KeySet()) {
            	//Get all object keyvalue in string variable = "coCode" and then create map according of keyset  
            	Map<String, Object> innerObj = (Map<String, Object>) FinalResult.get(coCode);
            	CountryDetail cd = new CountryDetail();
		    	cd.currencyId = (String) innerObj.get('currencyId');
		    	cd.currencyName = (String) innerObj.get('currencyName');
		    	cd.currencySymbol = (String) innerObj.get('currencySymbol');
		    	cd.id = (String) innerObj.get('id');
		    	cd.name = (String) innerObj.get('name');
            	returnMap.put(coCode, cd);    //Put(Key,Value)   1) Key = AD,AF etc 2) Value = Class CountryDetail
            	
            }
            return returnMap;
 
        }
       return null;
    }
    
  
  
  
  

}