public class PopulatePokemonBatch implements Database.Batchable<String>, Database.AllowsCallouts {
  public Iterable<String> start(Database.BatchableContext bc) {
    List<String> pokeList = new List<String>();
    //Make API call
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://pokeapi.co/api/v2/pokemon?limit=905');
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // Check if Connection was successful
    if (response.getStatusCode() == 200) {
      //deserialize response
      Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      List<Object> results = (List<Object>) responseData.get('results');
      //get url of pokemon's endpoints
      for (Object result : results) {
        Map<String, Object> pokemonData = (Map<String, Object>) result;
        String pokeName = (String) pokemonData.get('name');
        pokeList.add(pokeName);
      }
    }
    return pokeList;
  }

  public void execute(Database.BatchableContext bc, List<String> scope) {
    try {
      List<Pokemon__c> pokemonList = new List<Pokemon__c>();
      for (String record : scope) {
        String pokeName = record;
        HttpRequest detailsRequest = new HttpRequest();
        detailsRequest.setEndpoint(
          'https://pokeapi.co/api/v2/pokemon/' + pokeName
        );
        detailsRequest.setMethod('GET');
        HttpResponse detailsResponse = new Http().send(detailsRequest);
        // Check if Connection to the new endpoint was successful
        if (detailsResponse.getStatusCode() == 200) {
          //deserialize response
          Map<String, Object> detailData = (Map<String, Object>) JSON.deserializeUntyped(
            detailsResponse.getBody()
          );
          // get fields from detail data
          //***** get the id
          Integer id = (Integer) detailData.get('id');
          //***** Check if the id is greater than the number of pokemons we want to get
          //***** we only want the pokemons until the 8th generation

          //***** get and convert height and weight to the correct units
          Double height = (Double) detailData.get('height') / 10;
          Double weight = (Double) detailData.get('weight') / 10;
          //***** get the name
          // String name = (String) detailData.get('name');
          //***** get and handle multiple types
          List<Object> types = (List<Object>) detailData.get('types');
          List<String> typeList = new List<String>();
          for (Object type : types) {
            Map<String, Object> typeData = (Map<String, Object>) type;
            Map<String, Object> typeName = (Map<String, Object>) typeData.get(
              'type'
            );
            String nameType = (String) typeName.get('name');
            typeList.add(nameType);
          }
          //***** get species url to adquire the generation
          Map<String, Object> species = (Map<String, Object>) detailData.get(
            'species'
          );
          String speciesUrl = (String) species.get('url');
          // make a call to the species endpoint
          HttpRequest speciesRequest = new HttpRequest();
          speciesRequest.setEndpoint(speciesUrl);
          speciesRequest.setMethod('GET');
          HttpResponse speciesResponse = new Http().send(speciesRequest);
          // Check if Connection to the new endpoint was successful
          if (speciesResponse.getStatusCode() == 200) {
            //deserialize response
            Map<String, Object> speciesDetails = (Map<String, Object>) JSON.deserializeUntyped(
              speciesResponse.getBody()
            );
            //***** get the generation url and extract the the generation number from the end
            Map<String, Object> generationDetails = (Map<String, Object>) speciesDetails.get(
              'generation'
            );
            String generationUrl = (String) generationDetails.get('url');
            String generation = generationUrl.substring(
              generationUrl.length() - 2,
              generationUrl.length() - 1
            );
            //***** get the sprites
            Map<String, Object> sprites = (Map<String, Object>) detailData.get(
              'sprites'
            );
            String spriteUrl = (String) sprites.get('front_default');
            //***** create a new pokemon object and insert the data extrated fom the API
            Pokemon__c pokemon = new Pokemon__c(
              Name = pokeName.capitalize(),
              PokeIndex__c = id,
              Peso__c = String.valueOf(weight + ' kg'),
              Altura__c = String.valueOf(height + ' mts'),
              Tipo__c = String.join(typeList, ';'),
              Geracao__c = Integer.valueOf(generation),
              Foto_URL__c = spriteUrl
            );
            pokemonList.add(pokemon);
          }
        }
      }
      if (!pokemonList.isEmpty()) {
        insert pokemonList;
      }
    } catch (Exception e) {
      System.debug('Error: ' + e.getMessage());
    }
  }

  public void finish(Database.BatchableContext bc) {
    system.debug('batch finished');
  }
}
