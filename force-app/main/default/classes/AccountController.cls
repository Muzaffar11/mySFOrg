public with sharing class AccountController {
  @AuraEnabled(cacheable=true)

  public static List<Contact> getRelatedContacts(Id accountId) {
    return [
        SELECT Name, Title, Email, Phone
        FROM Contact
        WHERE AccountId = :accountId
        WITH SECURITY_ENFORCED
   ];
}
@AuraEnabled(cacheable=true)
public static List<Account> getAccounts() {
  // return [
  //     SELECT Name, AnnualRevenue, Industry
  //     FROM Account
  //     WITH SECURITY_ENFORCED
  //     ORDER BY Name
  // ];
  throw new AuraHandledException('Forced error');
}

@AuraEnabled(cacheable=true)
public static List<Contact> getContacts() {
  return [
      SELECT Name, Email, Phone
      FROM Contact
     
  ];
}


@AuraEnabled(cacheable=true)
public static List<Contact> getContactsByName(string recordName) {
System.debug(':: Test' +recordName);
  return [
      SELECT Id,Name, Email, Phone
      FROM Contact
      where Name like: '%'+recordName+'%'
     
  ];
}

  public static List<Account> getAllActiveAccounts() {
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }


  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountRecordWithRelatedContactList(Id recordId) {

      List <Account> accountList = new List<Account>();
      accountList =  [Select Id,(Select Id, FirstName, LastName, Title, Phone, Email FROM Contacts) from Account WHERE Id = :recordId];

      return accountList;
  }

  @AuraEnabled(cacheable = true)
    public static List<SObject> findRecords(String searchKey){
        String key = '%' + searchKey + '%';
        String QUERY = 'Select Id, name From Campaign';
        System.debug(System.LoggingLevel.DEBUG, QUERY);
        List<SObject> sObjectList = Database.query(QUERY);
        return sObjectList;
    }
 
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry> GetAllPriceBookEnteriesByDonTypeAndCountry(String ProjectCurrency, String DonationType, String Country) {
        List<PriceBookEntry> pbeList = [Select Id, Name, Product2Id, Product2.Donation_Type__c, //Product2.Country__c, 
                                        Product2.Family//, Product2.Project_Info__c, Product2.Default_Product__c
                                         From PriceBookEntry Where IsActive = true 
                                        and PriceBook2Id != null and CurrencyISOCode =: ProjectCurrency and Product2.Donation_Type__c =: DonationType and 
                                        //Product2.Country__c =: Country and 
                                        Product2.Family != null];
        return pbeList;                                        
    }


    @AuraEnabled
    public static Map<String, String> CreateDonation(map<string,string> AllDonationFieldMap, List<Map<String, Object>> FundAllocationMap)
    {
		//Map<String, String> valid = ValidateData(AllDonationFieldMap);

		// if(valid.get('isError') == 'true')
		// { return valid; }

        Map<String, String> responseMap = new Map<String, String>();
        AccountController lwz = new AccountController();
        //CreditCardDynamicProcess ccdp = new CreditCardDynamicProcess();
       // DD_DynamicProcess dddp = new DD_DynamicProcess();
       // Recurring__c NewRec = new Recurring__c();
        Opportunity NewOpp = new Opportunity();
        

        responseMap.put('isError', 'false');

        system.debug('::FundAllocationMap::' + FundAllocationMap);
        if(AllDonationFieldMap != null && !AllDonationFieldMap.isEmpty()) {
            try {
                
                Boolean isError = false;                
                string PurchaseId = '';
                string paymentGatewayUsed = '';

                //For Stripe
                Boolean isRecurring = false;
                String stripeOcode = '';
                string stripeCustomerId = '';
                string stripeRecurrSubsId = '';

                //For GoCardless
                string GC_CustomerId = '';
                string GC_SubscriptionID = '';
                string GC_MandateId = '';
                string GC_bankAccountId = '';

				Decimal Amount;
				String PaymentMethod;
				Contact con; 
				if(AllDonationFieldMap.get('DonationAmount')  != null)
                { Amount = Decimal.valueof(AllDonationFieldMap.get('DonationAmount')); }
				if(AllDonationFieldMap.get('SelectedPaymentType') != null)
				{ PaymentMethod = AllDonationFieldMap.get('SelectedPaymentType'); }

				if(AllDonationFieldMap.get('DonorContactId') != null)
				{ con = getContactById(AllDonationFieldMap.get('DonorContactId'))[0]; }

                // if(PaymentMethod == 'Card') {
                //     PurchaseId = 'Donation'+string.valueOf(Math.random()*100);
                //     WorldPay_PayPayl_Config__c wpSetting = WorldPay_PayPayl_Config__c.getOrgDefaults();
                //     Stripe_Settings__c StripeSetting = Stripe_Settings__c.getOrgDefaults(); 

                //     ccdp = new CreditCardDynamicProcess();

                //     //New Work Sherbaz-24-Nov-2020 (For Conditionally Stripe and WorldPay Charge)
                //     if(StripeSetting.Enable_Stripe__c && !wpSetting.Enable_World_Pay__c)
                //     {
                //         paymentGatewayUsed = 'Stripe';
                //     }  
                //     else if(wpSetting.Enable_World_Pay__c && !StripeSetting.Enable_Stripe__c)
                //     {
                //         paymentGatewayUsed = 'WorldPay';
                //     }
                //     else{
                //         responseMap.put('isError', 'true');
                //         responseMap.put('Message', 'Please Enable one Payment Gateway. Either Stripe or WorldPay');
                //         isError = true;
                //         return responseMap;
                //     }

                    
                    
                //     if(AllDonationFieldMap.get('CreditCardNumber') != null && AllDonationFieldMap.get('SelectedExpMonth') != null
                //     && AllDonationFieldMap.get('SelectedExpYear') != null && AllDonationFieldMap.get('SelectedCurrency') != null)
                //     {
                        
                //         if(AllDonationFieldMap.get('isRecurring') != null && AllDonationFieldMap.get('isRecurring') == 'true')
                //             isRecurring = true;
                        
                //         ccdp.ProcessCard(con, AllDonationFieldMap.get('CreditCardNumber'),
                //         AllDonationFieldMap.get('SelectedExpMonth'),AllDonationFieldMap.get('SelectedExpYear'), 
                //         Amount, AllDonationFieldMap.get('SelectedCurrency') != null ? AllDonationFieldMap.get('SelectedCurrency') : 'GBP',
                //         PurchaseId, isRecurring);

                //         //Changing Our Random Number Donation Id to Stripe Charge Id
                //         if(ccdp.Ocode != null && ccdp.Ocode != '')
                //             PurchaseId         = ccdp.Ocode;

                //         System.debug('::::ccdp.Ocode'+ ccdp.Ocode);
                //         System.debug('::::ccdp.StripeCustomerID'+ ccdp.StripeCustomerID);
                //         System.debug('::::ccdp.recurringSubscriptionId'+ ccdp.recurringSubscriptionId);

                //         stripeCustomerId    = ccdp.StripeCustomerID;
                //         stripeRecurrSubsId  = ccdp.recurringSubscriptionId;

                //         if(ccdp.isError) {
                //             responseMap.put('isError', 'true');
                //             responseMap.put('Message', ccdp.ErrorMessage);
                //             isError = true;
                //         }
                //             //For Stripe Recurring
                //         else if(ccdp.recurringSubscriptionId != null && ccdp.recurringSubscriptionId != '' && !ccdp.isError)
                //         {
                //             lwz = new LWC_DonationFormSearchController();
                //             System.debug('::::Inside Stripe Recurring');
                //             NewRec = lwz.CreateRecurring(PaymentMethod, con.Id, '', '', 'Monthly',
                //                     'In-Process', Date.today(), Amount, 
                //                     stripeRecurrSubsId,paymentGatewayUsed, 
                //                     '', AllDonationFieldMap.get('SelectedCurrency') != null ? AllDonationFieldMap.get('SelectedCurrency') : 'GBP');
                //             System.debug('::::Inside Stripe Recurring => NewRec.Id ' + NewRec.Id);
                            
                //         }
                //     }

                    
                // }
                // else if(PaymentMethod == 'Direct Debit') {
                //     dddp = new DD_DynamicProcess();
                //     SmartDebit_Config__c SmartDebitSetting   = SmartDebit_Config__c.getOrgDefaults();
                //     GoCardless_Settings__c GoCardlessSetting = GoCardless_Settings__c.getOrgDefaults();
                    

                //     //New Work Sherbaz-25-Nov-2020 (For Conditionally Smart Debit and GoCardless Charge)
                //     if(SmartDebitSetting.Enable_Direct_Debit__c && !GoCardlessSetting.Enable_Go_Cardless__c)
                //     {
                //         paymentGatewayUsed = 'Smart Debit';
                //     }  
                //     else if(GoCardlessSetting.Enable_Go_Cardless__c && !SmartDebitSetting.Enable_Direct_Debit__c)
                //     {
                //         paymentGatewayUsed = 'GoCardless';
                //     }
                //     else 
                //     {
                //         responseMap.put('isError', 'true');
                //         responseMap.put('Message', 'Please Enable one Payment Gateway. Either "Smart Debit" or "GoCardless"');
                //         isError = true;
                //         return responseMap;
                //     }
                //     isRecurring         = true;
                    
                //     //SMART DEBIT
                //     if(paymentGatewayUsed == 'Smart Debit')
                //     {
                //         if(AllDonationFieldMap.get('DDAccNo') != null && AllDonationFieldMap.get('DDSortCode') != null
                //         && AllDonationFieldMap.get('DDSelectedFrequency') !=  null && AllDonationFieldMap.get('DDSelectedDate') != null)
                //         {
                //             dddp.ValidateDD(con, String.valueof((Integer)(Math.random()*1000000000)),
                //             AllDonationFieldMap.get('DDAccNo'), AllDonationFieldMap.get('DDSortCode'),
                //             AllDonationFieldMap.get('DDSelectedFrequency'), Date.parse(AllDonationFieldMap.get('DDSelectedDate')),
                //             Amount);
                //         }
                //     }
                //     //GOCARDLESS
                //     else if(paymentGatewayUsed == 'GoCardless')
                //     {
                //         if(AllDonationFieldMap.get('DDAccNo') != null && AllDonationFieldMap.get('DDSortCode') != null
                //         && AllDonationFieldMap.get('DDSelectedFrequency') !=  null && AllDonationFieldMap.get('DDSelectedDate') != null)
                //         {
                //             System.debug(':::: Before ProcessGoCardless');
                //             dddp.ProcessGoCardless(con, String.valueof((Integer)(Math.random()*1000000000)),
                //                 AllDonationFieldMap.get('DDAccNo'), AllDonationFieldMap.get('DDSortCode'),
                //                 AllDonationFieldMap.get('DDSelectedFrequency'),Amount);

                //             System.debug('::::After ProcessGoCardless => isError ' + dddp.isError);
                //             System.debug('::::After ProcessGoCardless => ErrorMessage ' + dddp.ErrorMessage);
                //             System.debug('::::After ProcessGoCardless => GC_SubscriptionID ' + dddp.GC_SubscriptionID);
                //         }
                //     }

                //     //CREATE RECURRING FOR BOTH SMART DEBIT AND GOCARDLESS
                //     if(!dddp.isError) {

                //         if(dddp.GC_SubscriptionID != null && dddp.GC_SubscriptionID != '')
                //             GC_SubscriptionID = dddp.GC_SubscriptionID;
                         
                //         //New Work Sherbaz 27-Nov-2020 (GoCardless CUSTOMER ID, BANK ACCOUNT ID, MANDATE ID)
                //         if(dddp.GC_CustomerId != null && dddp.GC_CustomerId != '')
                //             GC_CustomerId = dddp.GC_CustomerId;
                //         if(dddp.GC_BankAccountId != null && dddp.GC_BankAccountId != '')
                //             GC_bankAccountId = dddp.GC_BankAccountId;
                //         if(dddp.GC_MandateId != null && dddp.GC_MandateId != '')
                //             GC_MandateId = dddp.GC_MandateId;
                        
                //         lwz = new LWC_DonationFormSearchController();
                //         NewRec = lwz.CreateRecurring(PaymentMethod, con.Id, dddp.AccNumber, dddp.SortCode, (string) AllDonationFieldMap.get('DDSelectedFrequency'), //dddp.Frequency,
                //                                 'In-Process', dddp.FirstPaymentDate, Amount, 
                //                                 '',paymentGatewayUsed, 
                //                                 GC_SubscriptionID, AllDonationFieldMap.get('SelectedCurrency') != null ? AllDonationFieldMap.get('SelectedCurrency') : 'GBP');

                //         if(paymentGatewayUsed == 'Smart Debit')
                //             dddp.CreateDD(NewRec.Name);
                //         //New Work Sherbaz-27-Nov-2020
                //         else if(paymentGatewayUsed == 'GoCardless')
                //             createDonorPaymentGateway(GC_MandateId, GC_bankAccountId, 
                //                                     AllDonationFieldMap.get('DDSortCode'), con.Id, AllDonationFieldMap.get('DDAccNo'));

                //     }
                //     else {
                //         responseMap.put('isError', 'true');
                //         responseMap.put('Message', dddp.ErrorMessage);
                //         isError = true;
                //     }
                // }

          //       if(!isError) {
          //           lwz = new LWC_DonationFormSearchController();

          //           //New Work Sherbaz-24-Nov-2020 (Add Stipe Customer Id Param)
          //           //New Work Sherbaz-27-Nov-2020 (Add GoCardless Customer Id Param)
          //           NewOpp = lwz.CreateOpportunity(AllDonationFieldMap, NewRec, 
          //           PurchaseId, 
          //           FundAllocationMap, 
          //           con, stripeCustomerId, 
          //           paymentGatewayUsed, isRecurring,
          //           GC_CustomerId); 
					
					// responseMap.put('DonationId', NewOpp.Id);
					// responseMap.put('isError', 'false');
					// responseMap.put('Message', 'New Donation: ' + NewOpp.Donation_ID__c + ' created successfully');
					
          //       }
                
            }
            catch(Exception ex) {
                responseMap.put('isError', 'true');
                responseMap.put('Message', 'Error Message: ' +ex.getMessage() + ' StackTrace: ' + ex.getStackTraceString());
				system.debug(':::ErrorMsgFromCatch Message=> '+ex.getMessage() + ' Line=> ' +ex.getLineNumber());
                system.debug(':::ErrorMsgFromCatch'+ ' StackTrace=>'+ex.getStackTraceString());
			}


        }
        else {
            responseMap.put('isError', 'true');
            responseMap.put('Message', 'No Fields found');
        }
        return responseMap;
    }


    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactById(string ConId)
    {
		List<Contact> conList = new List<Contact>();

		conList =  [Select Id, Salutation, FirstName, LastName, Email,  AccountId, //Contact_ID__c,
					Account.RecordTypeId, Account.RecordType.Name, OtherPhone, HomePhone
				//	MobilePhone, Other_Phone_2__c, Phone3__c, Phone, MailingCity, MailingCountry, MailingCountryCode,
				//	MailingPostalCode, MailingStateCode, MailingState, MailingStreet,
				//	Street__c, House_No__c, Building_Name__c, Sub_Building__c, Locality__c,
			//		Organisation__c, Comminication_Preference__c, Prefix2__c, AssistantName,
			//		Secondary_Middle_Name__c, Secondary_Last_Name__c, Secondary_Email__c,
				//	AssistantPhone,
			//		GAD_Type__c, Post_Opt_Out__c,Email_Opt_Out__c,Sms_Opt_Out__c,Receipt_Opt_Out__c,Opt_Out_Modified_by__c,
			//		Start_Date__c, Gift_Aid_Declared__c,End_Date__c,New_Gift_Aid_ID__c,Gift_Aid_ID__c, Gift_Aid_Status__c,R2020__c, Q2020__c,
			//		Address_Verified__c,Address_Verified_Against__c,Address_Verified_Date__c,
                //    Email_Verified__c, Email_Verified_Against__c, Email_Verified_Date__c,
                //    Stripe_Customer_ID__c,
               //     GC_Customer_Id__c,
               //     Account_Number_1__c
                    // Sort_Code_1__c,
                    // Account_Title__c,
                    // Account_Number_2__c,
                    // Sort_Code_2__c,
                    // Account_Title_2__c,
                    // Account_Number_3__c,
                    // Sort_Code_3__c,
                    // Account_Title_3__c,
                    // Account_Number_4__c,
                    // Sort_Code_4__c,
                    // Account_Title_4__c,
                    // Account_Number_5__c,
                    // Sort_Code_5__c,
                    // Account_Title_5__c,
                    // (Select Id, RecordTypeId, RecordType.Name, Bank_Account_Number__c, 
                    // GC_Bank_Account_Id__c, GC_Mandate_Id__c, 
                    // Sort_Code__c,
                    // Card_Number__c, CC_Expiry_Month__c, CC_Expiry_Year__c, CC_Token__c
                    // from Donor_Payment_Gateways__r)
                    From Contact Where Id =: ConId limit 1];


                    for(Contact con:conList)
                    {
                        
                        // if(con.Sub_Building__c!=null)
                        // {
                        //     con.Sub_Building__c=capitalizeWords(con.Sub_Building__c);
                        // }
                        // if(con.Building_Name__c!=null)
                        // {
                        //     con.Building_Name__c=capitalizeWords(con.Building_Name__c);
                        // }
                        // if(con.MailingCity!=null)
                        // {
                        //     con.MailingCity=capitalizeWords(con.MailingCity );
                        // }
                        // if(con.MailingStreet!=null)
                        // {
                        //     con.MailingStreet=capitalizeWords(con.MailingStreet);
                        // }
                        // if(con.Street__c!=null)
                        // {
                        //     con.Street__c=capitalizeWords( con.Street__c);
                        // }
                        // if(con.Locality__c!=null)
                        // {
                        //     con.Locality__c=capitalizeWords(con.Locality__c);
                        // }    
                        // if(con.Organisation__c!=null)
                        // {
                        //     con.Organisation__c=capitalizeWords(con.Organisation__c);
                        // }   
                       
            
                    }

		return conList;
    } 
    //Product2.Country__c,  Product2.Project_Info__c, Product2.Default_Product__c 
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry> GetDefaultProjects() {
        Product2 prd = [Select Id from Product2 where  Family != null and Donation_Type__c != null limit 1];
        List<PriceBookEntry> pbeList = [Select Id, Name, CurrencyIsoCode, Product2Id, Product2.Donation_Type__c,
                                        Product2.Family
                                        From PriceBookEntry Where IsActive = true 
                                        and PriceBook2Id != null and Product2Id =: prd.Id];
        return pbeList;                                        
    }
  
}