public class WorldPayCart {

    public string wpCurrency{get; set;}
     public string purchaseValue{get; set;}
     public string purchaseName{get; set;}
     public string purchaseDesc{get; set;}
     public string purchaseCount{get; set;}
     public string purchaseId{get; set;}
     public string buyerTitle{get; set;}
     public string buyerFirst{get; set;}
     public string buyerLast{get; set;}
     public string buyerPhone{get; set;}
     public string buyerEmail{get; set;}
     public string buyerPostcode{get; set;}
     public string buyerHouseNo{get; set;}
     public string buyerAddressTwo{get; set;}
     public string buyerState{get; set;}
     public string buyerCity{get; set;}
     public string buyerCountry{get; set;}
     public string buyerAddress{get; set;}
     public string buyerCardType{get; set;}
    public string ccNumber{get; set;}
    public string ccExpiryMonth{get; set;}
    public string ccExpiryYear{get; set;}
    public string ccHolderName{get; set;}
    public string cvc{get; set;}
  //wp cart details
  private string wpServerUrl;
  private boolean wpIsTest = false;
  public string wpExponent;  
  private string wpXml;
  public string wpSuccessUrl;
  public string wpFailUrl;
  private string certPath;
    
    
    
    
    public class PaymentResponse {
    public string ErrorCode;
    public string ErrorCodeMessage;
    public string OrderCode;
    public string PaymentMethod;
    public string LastEvent;
    public string CVCResultCode;
    public string Balance_AccountType;
    public string RiskScore;
    public string Amount;
    public string CurrencyCode;
    public string Exponent;
    public string DebitCreditIndicator;
    public string ISO8583ReturnCode;
    public string ISO8583ReturnCodeDescription;
  }
    
 public static PaymentResponse ParsePaymentResponse(string xmlString) {
    
    PaymentResponse response = new PaymentResponse();
    //New Work Sherbaz-20-July-2020 (Added Try Catch and Email Send Whenever Code Crash)
    try
    {
        
        Dom.Document doc = new Dom.Document();
        doc.load(xmlString);
        Dom.Xmlnode xml = doc.getRootElement();
        
        Dom.Xmlnode reply = xml.getChildElement('reply', null);
        
        Dom.Xmlnode error = reply.getChildElement('error', null);
        
        if(error != null) {
        response.ErrorCode = error.getAttribute('code', null);
        response.ErrorCodeMessage = error.getText();
        return response;  
        }
        
        Dom.Xmlnode orderStatus = reply.getChildElement('orderStatus', null);
        
        if(orderStatus != null) {
        response.OrderCode = orderStatus.getAttribute('orderCode', null);
        
        if(error != null) {
            response.ErrorCode = error.getAttribute('code', null);
            response.ErrorCodeMessage = error.getText();
            return response;  
        }
        }
        
        Dom.Xmlnode payment = orderStatus.getChildElement('payment', null);
        
        if(payment != null) {
        response.PaymentMethod = getChildValue(payment, 'paymentMethod', null, null); //payment.getChildElement('paymentMethod', null).getText();
        response.Amount = getChildValue(payment, 'amount', null, 'value');
        response.CurrencyCode = getChildValue(payment, 'amount', null, 'currencyCode');
        response.Exponent = getChildValue(payment, 'amount', null, 'exponent');
        response.DebitCreditIndicator = getChildValue(payment, 'amount', null, 'debitCreditIndicator');
        response.LastEvent = getChildValue(payment, 'lastEvent', null, null);
        response.CVCResultCode = getChildValue(payment, 'CVCResultCode', null, null);
        response.RiskScore = getChildValue(payment, 'riskScore', null, 'value');
        response.ISO8583ReturnCode = getChildValue(payment, 'ISO8583ReturnCode', null, 'code');
        response.ISO8583ReturnCodeDescription = getChildValue(payment, 'ISO8583ReturnCode', null, 'description');
        response.Balance_AccountType = getChildValue(payment, 'balance', null, 'accountType');
        }
        
        return response;
    }
    catch(Exception ex)
    {
        Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
        List<String> toemailadd2 = new List<String>();
        toemailadd2.add('sherbaz.beyondvision@gmail.com');
        mail2.setToAddresses(toemailadd2);
        mail2.setSubject('WorldPayCart XML Parsing Crash Email');
        mail2.setHtmlBody('Exception: ' + ex + '<br/><br/>Exception Message: '+ ex.getMessage() +' Line No:' + ex.getLineNumber() +'<br/><br/>Response:' + xmlString) ;                
        mail2.setCharset('UTF-8');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail2 }, false );
        return null;
    }
  }
    
    
    
  public PaymentResponse send_payment_worldpay_xml() {
      try{
    string abc = this.wpServerUrl;
    string xml_cart = this.GetPaymentXML();
    HttpResponse res = this.SendReq('https://secure-test.worldpay.com/jsp/merchant/xml/paymentService.jsp', xml_cart);
    PaymentResponse response = ParsePaymentResponse(res.getBody());
    return response;
          }
      catch(exception ex){
          system.debug(':: exception' + ex.getMessage() +':: '+ ex.getLineNumber());
          return null;
      }
     
  }//end send_payment_worldpay_xml
    
   public HttpResponse SendReq(string url, string postargs) {
       try{
    httpRequest req = new httpRequest();
       system.debug(':: Start SendReq');
    //code by mona 
    Blob headerValue = Blob.valueOf('f15f7047-16d9-46a9-a0fc-16f944eeb2eb' + ':' + 'T_S_594ccb78-af74-49e9-9e95-e13ddfeefcc3');
        String xauthorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', xauthorizationHeader);
        //code by mona
          system.debug('headerValue'+ headerValue);
    req.setMethod('POST');
    req.setEndpoint(url);
    req.setBody(postargs);

    req.setTimeout(30000); //New Work Sherbaz-1-July-2020
    
    Http h = new Http();
    
    return h.send(req);
           }
       catch(exception ex)
       {
           system.debug(':: exception' + ex.getMessage());
           return null;
       }
    
  }//send requirements
    
    
    
 private string GetPaymentXML() {
    //this.setExponent(this.purchaseValue);
     try{
    system.debug('::  Start GetPaymentXML ');
    XmlBuild xml = new XmlBuild('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE paymentService PUBLIC "-//Worldpay//DTD Worldpay PaymentService v1//EN" "http://dtd.worldpay.com/paymentService_v1.dtd">');
    
    xml.Push('paymentService',
      new Map<string, string>{'version' => '1.4', 'merchantCode' => 'f15f7047-16d9-46a9-a0fc-16f944eeb2eb'}
    );
    
    xml.Push('submit');
    
    xml.Push('order',
      new Map<string, string>{'orderCode' => this.purchaseId}
    );
    
    xml.Element('description', this.purchaseDesc);
    xml.EmptyElement('amount',
    new Map<string, string>{'currencyCode' => this.wpCurrency, 'exponent' => '2', 'value' => this.purchaseValue});
   
       system.debug('::  Start xml '+ xml);
     xml.Push('orderContent');
    
    
    
    string cdata = '<center><table>'+
      '<tr><td bgcolor="#CCCCCC">Your Donation ID:</td><td colspan="2" bgcolor="#ffff00" align="right"></td></tr>'+
      '<tr><td bgcolor="#ffff00">Description:</td><td></td><td align="right">1.0</td></tr>'+
      '<tr><td colspan="2">Subtotal:</td><td align="right">14,00</td></tr>'+
      '<tr><td colspan="2">VAT: 13%</td><td align="right">1,82</td></tr>'+
      '<tr><td colspan="2">Shipping and Handling:</td><td align="right">4,00</td></tr>'+
      '<tr><td colspan="2" bgcolor="#c0c0c0">Total cost:</td><td bgcolor="#c0c0c0" align="right">Euro 19,82</td></tr>'+
      '<tr><td colspan="3">&nbsp;</td></tr>'+
      '<tr><td bgcolor="#ffff00" colspan="3">Your billing address:</td></tr>'+
      '<tr><td colspan="3"><br>Thisplace.</td></tr>'+
      '<tr><td colspan="3">&nbsp;</td></tr>'+
      '<tr><td bgcolor="#ffff00" colspan="3">Your shipping address:</td></tr>'+
      '<tr><td colspan="3"><br>Thisplace.</td></tr>'+
      '<tr><td colspan="3">&nbsp;</td></tr>'+
      '<tr><td bgcolor="#ffff00" colspan="3">Our contact information:</td></tr>'+
      '<tr><td colspan="3">ACME Webshops Int. Inc.,<br>11 Strangewood Blv.,<br>1255 KZ Thisisit,<br>Nowhereatall.<br><br>acmeweb@acme.inc<br>(555) 1235 456</td></tr>'+
      '<tr><td colspan="3">&nbsp;</td></tr>'+
      '<tr><td bgcolor="#c0c0c0" colspan="3">Billing notice:</td></tr>'+
      '<tr><td colspan="3">Your payment will be handled by WorldPay Global Payments Services<br>This name may appear on your bank statement<br>http://www.worldpay.com</td></tr>'+
      '</table></center>';
      
    
    
    xml.cdata_open('CDATA', cdata);

    xml.Pop('orderContent');

    
    /** Added Payment Details **/
    xml.Push('paymentDetails');
    xml.Push(this.buyerCardType);   // Card type tag
    xml.Element('cardNumber', this.ccNumber);               
    xml.Push('expiryDate');
    xml.EmptyElement('date',new Map<string, string>{'month' => this.ccExpiryMonth, 'year'=>this.ccExpiryYear});
    xml.Pop('expiryDate');
    xml.Element('cardHolderName', 'Test');
     system.debug('::  Start xml 2 '+ xml);
  //  string a = this.cvc;
  //  if(this.cvc != '') {
   //   xml.Element('cvc', this.cvc);
  //  }
    
    xml.Push('cardAddress');
    xml.Push('address');
    //xml.Element('firstName', this.buyerFirst);
   // xml.Element('lastName', this.buyerLast);
    xml.Element('address1', this.buyerAddress);
    xml.Element('address2', this.buyerAddressTwo);
    xml.Element('address3', '');
    xml.Element('postalCode', this.buyerPostcode);
    xml.Element('city', this.buyerCity);
    xml.Element('state', this.buyerState);                    
    xml.Element('countryCode', this.buyerCountry);
   // xml.Element('telephoneNumber', this.buyerPhone);
    xml.Pop('address');                
    xml.Pop('cardAddress');                
    xml.Pop(this.buyerCardType);   
    //Ip work by Iqrar
    Map<String,String> ipmap = new Map<String,String>();
    
    String ipAddress = '00.00.00.00';
    
    if(!Test.isRunningTest())
    {
      	if(ApexPages.currentPage() != null)
      	{
	        Map<String, String> mapHeaders = ApexPages.currentPage().getHeaders();
	        if(mapHeaders != null){
	           ipAddress = mapHeaders.get('X-Salesforce-SIP');
	        }
      	}
    }
    
    ipmap.put('shopperIPAddress',ipAddress);
      xml.EmptyElement('session',ipmap);
    xml.Pop('paymentDetails');
    /** End Payment Details **/
    
    xml.Push('shopper');
   	  xml.Element('shopperEmailAddress', 'muzaffarmoiz@hotmail.com');
    xml.Push('browser');
      xml.Element('acceptHeader', 'text/html');
      xml.Element('userAgentHeader', 'Mozilla/5.0 ...');
    xml.Pop('browser');
    xml.Pop('shopper');
   /* xml.Push('shippingAddress');
    xml.Push('address');
    xml.Element('firstName', this.buyerFirst);
    xml.Element('lastName', this.buyerLast);
    xml.Element('address1', this.buyerAddress);
    xml.Element('address2', this.buyerAddressTwo);
    xml.Element('postalCode', this.buyerPostcode);
    xml.Element('city', this.buyerCity);
    xml.Element('state', this.buyerState);                    
    xml.Element('countryCode', this.buyerCountry);
    xml.Element('telephoneNumber', this.buyerPhone);
    xml.Pop('address');
    xml.Pop('shippingAddress');*/
    xml.Element('dynamicMCC', '5045');
    xml.EmptyElement('dynamicInteractionType',new Map<string, string>{'type' => 'ECOMMERCE'});
    xml.EmptyElement('dynamic3DS',new Map<string, string>{'overrideAdvice' => 'do3DS'});      
         
    xml.Pop('order'); 
    //xml.Pop('payAsOrder'); 
    
    xml.Pop('submit');
    xml.Pop('paymentService');
         
         system.debug('::  Start xml end  '+ xml);
    return xml.GetXML();
         }
     catch(exception ex ){
 			system.debug(':: exception '  +  ex.getMessage() +  ex.getLineNumber());   
         return null;
     }
         
  }//end getXML
    

  private static string getChildValue(Dom.Xmlnode node, string childName, string nameSpace, string attributeName) {
    Dom.Xmlnode child = node.getChildElement(childName, nameSpace);
    if(child == null) {
      return null;
    }
    
    if(attributeName == null) {
      return child.getText();  
    } else {
      return child.getAttribute(attributeName, nameSpace);
    }
    
   // return null;
  }    
    
}