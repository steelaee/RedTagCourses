public with sharing class AnimalLocator {
    public static String getAnimalNameById(Integer animalId) {
        Http http = new Http();
        String animalName = '';
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + animalId);
        request.setMethod('GET');
        HttpResponse responce = http.send(request);

        if(responce.getStatusCode() == 200){
            Map<String, Object> r = (Map<String, Object>)JSON.deserializeUntyped(responce.getBody());
            
            Map<String, Object> animal = (Map<String, Object>)r.get('animal');

            animalName = string.valueOf(animal.get('name'));
        }

        return animalName;
    }
}