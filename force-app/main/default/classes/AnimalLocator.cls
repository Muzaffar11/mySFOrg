public class AnimalLocator{
    public static String getAnimalNameById(Integer idAsParam){
        String retVal = null;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+idAsParam);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<string,object> mapOfAnimals = (map<string,object>) results.get('animal');

            retVal = string.valueof(mapOfAnimals.get('name'));
        }
        
        return retVal;
    }
}