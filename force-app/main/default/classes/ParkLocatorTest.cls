@isTest
public class ParkLocatorTest {
    
    @isTest  static void testCallout(){ 
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        List<String> result  =  new List<String>();
        List<String> expectedvalue  =  new List<String>{'Park12','Park2','Park3'};
            
        result =  ParkLocator.country('India');
        System.assertEquals(expectedvalue, result);
    } 

}