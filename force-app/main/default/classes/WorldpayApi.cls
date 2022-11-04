public class WorldpayApi {
    
    public string PayMode {get;set;} 
	public string DonCurrency {get;set;} 
    public String name {get;set;}
    public String CreditcardNo {get;set;}
    public String ExpiryYear {get;set;}
    public String ExpiryMonth {get;set;}
    public String cvc {get;set;}
    public Integer current_year = 0;
    public String City {get;set;} 
    public string PCode {get;set;}
    public Double TotalAmount {get;set;}
    public string TAmount {get;set;}
    public string Street {get;set;}
	public string currency_code {get;set;}
    public string TAmount2 {get;set;}
    public string Amount {get;set;}
   	public string Line1 {get;set;}
	public string Line2 {get;set;}
	//Donor Details
	public string Fname {get;set;}
	public string Lname {get;set;}
	public string Email {get;set;}
	public string Mobile {get;set;}
	public string Phone {get;set;}
	public string Prefix {get;set;} 
    
    public string State {get;set;} 
   	public string DonorCountry {get;set;}  
    public string Address {get;set;} 
   	public string DonType {get;set;}  
    
    public string ErrMsg {get;set;}
    public string Error {get;set;}
    public string CardNo {get;set;}
    
   // public string currency_code {get;set;}
    
    
    
  public List<SelectOption> getYearSelectList()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        for(Integer i = current_year; i <= (current_year + 10); i++)
        {
            options.add(new selectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options; //return the List
    }
    
 
    
   private String toProperCase(String OrginalString){  
        List<String> Character_List = new List<String>();
        system.debug('OrginalString::   '+OrginalString);
        Character_List = OrginalString.split('');
        
        String NewString = '';
        for(Integer i=1; i<Character_List.size(); i++){
            if( i==1 || Character_List[i-1] == ' ' || Character_List[i-1] == '-'){
                NewString += Character_List[i].toUpperCase();
            }
            else{
                NewString += Character_List[i].tolowerCase();
            }
        }
        return NewString;
    }
    public PageReference save()
    {
        try{
            
            system.debug(':: Start Save');
            
            PageReference pg;
            
            	//system.debug('This is toProperCase(Fname)0::'+Fname);
				//system.debug('This is toProperCase(Lname)0::'+Lname);
				//Fname = toProperCase(Fname);
				//Lname = toProperCase(Lname);
				//system.debug('This is toProperCase(Fname)1::'+Fname);
				//system.debug('This is toProperCase(Lname)1::'+Lname);
				
				//Line1 = toProperCase(Line1);
				//system.debug('This is Line 2::'+Line2);
				//Line2 = toProperCase(Line2);
				
				City = 'Karachi';
				Pcode = '74700';
            	DonCurrency = 'pound';
				
				TotalAmount = 0;
            	TotalAmount += decimal.valueOf(Amount);
			
			//if(PayMode != 'Direct Debit' && DonationGiving == 'Donate1')
            //{
                
			
			   
				TAmount = string.valueof(TotalAmount);               
				if(DonCurrency == 'pound')
                {
					currency_code = 'GBP';
					TAmount2 = '£';
				}
				TAmount2 += string.valueof(TotalAmount);    
				
				system.debug(':: currency_code'+ currency_code);
				if(Prefix == null || Prefix == ''){
					Prefix = 'Mr';
				}
				
				Name = Prefix + ' ' +Fname+' '+Lname;
            
            	system.debug(':: Name' + Name);
									
				Address = Line1 + ' ' + Line2 + ' ' + City + ' ' + State + ' ' + Pcode + ' ' + DonorCountry;                                         
				PayMode =  'Credit / Debit card';
				 if(PayMode == 'Credit / Debit card'){
					DonType = 'Single Donation';
					string OrderCode = 'Donation'+string.valueOf(Math.random()*100);
					string fundAllocation = 'A general donation where the need is greatest';
                    // New Work Sherbaz-7-July-2020
                   // List<Opportunity> opListToCheck =   [Select Id, StageName From Opportunity 
                    //                                    where id =: NewDonation.Id and StageName = 'Donation'];
                   // if(!opListToCheck.isEmpty()) 
                  //  {
                    //    system.debug(':::This donation is already completed');
                        // init();
                  //      ErrMsg = '';
                  //      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This donation is already completed. Kindly Refresh Page for New Donation'));
                  //      return null;
                  //  }

                    //New Work Sherbaz-20-July-2020 (Change the order of getAccount and ProcessCard methods)
                    //Now getAccount will be called first and then ProcessCard
                    //If Donor's Email or Fname or Lname is null then return with error msg
                    
					// Donor = getAccount(false);
                    // if(Donor == null)
                    // { 
                    //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Kindly Refresh Page for New Donation'));
                    //     return null;
                    // }

					string cardresult = ProcessCard(OrderCode,fundAllocation);
					//Donor = getAccount(false);

                    system.debug('This is card Result:::');
					
                    if(cardresult.contains('Card process failed') == true){
							//ProcessDonation(Donor,'Declined','Declined',false,Error ,true,false,OrderCode,cardresult);                         
							ErrMsg = 'Card Failed to process: '+Error;
						
							return null; 
					}
					else{
							//ProcessDonation(Donor,'Donation','Success',true,'Payment successfull',false,true,OrderCode,'');
							ErrMsg = '';
							//pg = new PageReference('/apex/Thankyou);
							//pg.setRedirect(true);
							return pg; 
					}                  
				}
 		
				   
							
				//return new PageReference('/apex/PayPalConfirmation');
            return null;
        }
        catch(Exception ex){
			
			return null;
		}
       
    }
    
     private string ProcessCard(string Ocode,string description){
		try{
			//WorldPay_PayPayl_Config__c cs = WorldPay_PayPayl_Config__c.getOrgDefaults();
			//WorldPayCart cart = new WorldPayCart(true);
			system.debug(':: ProcessCard Start');
			WorldPayCart cart = new WorldPayCart();
            system.debug(':: ProcessCard cart Start' + currency_code + ' CreditcardNo ' + CreditcardNo );            
			
			cart.wpCurrency = currency_code;//'GBP';//DonCurrency
			CreditcardNo = CreditcardNo.trim();
						CreditcardNo = CreditcardNo.replaceAll('(\\s+)', '');   
            
            system.debug(':: ProcessCard cart Start 2' + cart);    
			//purchase specific
			cart.purchaseValue = string.valueof(TotalAmount);
			cart.purchaseName = Ocode;
			description = description.replace('£','GBP ');
			description = description.replace('€','EUR ');
			description = description.replace('$','USD ');
			cart.purchaseDesc = 'Donation: '+description;
			cart.purchaseCount = '1';
			cart.purchaseId = Ocode;
			system.debug('ProcessCard Middle 1');
			//customer specifc
			if(Prefix != null)
				cart.buyerTitle = Prefix;
			else 
				cart.buyerTitle = 'Mr';
			if(Fname != null)
				cart.buyerFirst = Fname;
			else
				cart.buyerFirst = 'John';
			if(Lname != null)
				cart.buyerLast = Lname;
			else
				cart.buyerLast = 'Doe';
			if(Mobile != null)
				cart.buyerPhone = Mobile;
			else
				cart.buyerPhone = '012345687';
			if(Email != null)
				cart.buyerEmail = Email ;
			else
				cart.buyerEmail = '';
			if(PCode != null)
				cart.buyerPostcode = PCode;
			else        
				cart.buyerPostcode = '12365';
			if(PCode != null)
				cart.buyerHouseNo = PCode;
			else
				cart.buyerHouseNo = '12';
			if(Line2 != null)
				cart.buyerAddressTwo = Line2;
			else
				cart.buyerAddressTwo = '';
			if(city != null)
				cart.buyerCity = city;
			else
				cart.buyerCity = 'test';
				system.debug('ProcessCard Middle 2');
			//if(DonorCountry != null && DonorCountry != '' && CountryMap.keyset().contains(DonorCountry))
			cart.buyerCountry = 'GB';
			system.debug('This is card number is process card method'+GetCreditCardType(CreditcardNo));
			cart.buyerCardType = GetCreditCardType(CreditcardNo);
			if(Line1 != null)
				cart.buyerAddress = Line1;
			else
				cart.buyerAddress = 'test street';
			
			if(State != null)
				cart.buyerState = State;
			else
				cart.buyerState = 'test state';
			
			// Credit card fileds
		   
			
			system.debug('This is CreditcardNo '+CreditcardNo);       
			cart.ccNumber = CreditcardNo;
			cart.ccExpiryMonth = ExpiryMonth;
			cart.ccExpiryYear = ExpiryYear;
			system.debug('This is month year '+ExpiryMonth+' '+ExpiryYear);
			string name = '';  
			if(Fname != null)
					name = Fname ;
			if(Lname != null )
				name += ' '+Lname;
			cart.ccHolderName = name;               
			cart.cvc = cvc;
			system.debug('This is cart '+cart);
            
            system.debug('ProcessCard end' +  cart);
			WorldPayCart.PaymentResponse response;
            
            
			if(!Test.isRunningTest()){
				response = cart.send_payment_worldpay_xml();
			}else{
				response = new WorldPayCart.PaymentResponse();
				response.LastEvent = 'AUTHORISED';
			}
			system.debug('This is resposen '+response);
			if(response.LastEvent != 'AUTHORISED'){
					   if(Error==null || Error=='' || Error.trim()!=response.ISO8583ReturnCodeDescription){
						   if(response.ErrorCodeMessage != null && response.ErrorCodeMessage != '')
									Error += ' '+response.ErrorCodeMessage;                                  
						   else if(response.ISO8583ReturnCodeDescription != null && response.ISO8583ReturnCodeDescription != '')
									Error += ' '+response.ISO8583ReturnCodeDescription;
					   }   
						system.debug('Error in Proccess card '+Error);                           
								//ProcessDonation('Declined','Declined',false,Error ,true,false,Ocode);
								return 'Card process failed '+Error;
						}
				else if(response.LastEvent == 'AUTHORISED'){                                 
			   //ProcessDonation('Donation','Success',true,'Payment successfull',false,true,Ocode ); 
			   return 'true';                              
				}       
			system.debug('Error in Proccess card '+Error);
			return 'Card process failed '+Error;
		}
		catch(Exception ex) {
			system.debug('Error in Proccess card ');
			return 'Card process failed ';
		}
	 }
    
    
     public string GetCreditCardType(string CreditCardNumber)
	 {
   
	if(Pattern.matches('^4[0-9]{12}(?:[0-9]{3})?$', CreditCardNumber))
		return 'VISA-SSL';        
	if(Pattern.matches('5[1-5][0-9]{14}', CreditCardNumber))
		return 'ECMC-SSL';
	if(Pattern.matches('^3[47][0-9]{13}$', CreditCardNumber))
		return 'AMEX-SSL';
	if(Pattern.matches('^3(?:0[0-5]|[68][0-9])[0-9]{11}$', CreditCardNumber))
		return 'DINERS-SSL';
	if(Pattern.matches('^6(?:011|5[0-9]{2})[0-9]{12}$', CreditCardNumber))
		return 'DISCOVER-SSL';
	if(Pattern.matches('^(?:2131|1800|35\\d{3})\\d{11}$',CreditCardNumber ))     
		return 'JCB-SSL';
	if(Pattern.matches('^3$|^3[47][0-9]{0,13}$',CreditCardNumber))
		return 'AMEX-SSL';
	if(Pattern.matches('^(5[06-8]|6\\d)\\d{14}(\\d{2,3})?$',CreditCardNumber))
		return 'MAESTRO-SSL';
		
	return 'invalid';
 }

    
}