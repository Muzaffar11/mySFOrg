@isTest
global class ParkServiceMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           ParkService.byCountryResponse Response_x =  new ParkService.byCountryResponse();
               List<String> myPark =  new List<String>{'Park1','Park2','Park3'};
               
               Response_x.return_x =  myPark;
               response.put('response_x', response_x);

           
           }

}