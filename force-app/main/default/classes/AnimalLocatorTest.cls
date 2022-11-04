@isTest
private class AnimalLocatorTest{
    @isTest
    static void testAnimalNameById(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        String result = AnimalLocator.getAnimalNameById(1);
        
        // Verify mock response is not null
        System.assertNotEquals(null,result,'The callout returned a null response.');
        // Verify status code
        System.assertEquals('tiger',result);
    }
}