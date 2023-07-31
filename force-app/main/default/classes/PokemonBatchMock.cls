@isTest
public with sharing class PokemonBatchMock implements HttpCalloutMock
{
    public HttpResponse respond(HttpRequest request)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (request.getEndpoint().contains('pokemon?limit=905')) {
            res.setBody('{"results": [{"name": "bulbasaur"},{"name": "charmander"},{"name": "squirtle"}]}');
            res.setStatusCode(200);
        } else if (request.getEndpoint().contains('pokemon/')) {
            res.setBody('{"id": 1, "height": 7, "weight": 69, "types": [{"type": {"name": "grass"}},{"type": {"name": "poison"}}], "species": {"url": "https://pokeapi.co/api/v2/pokemon-species/1/"}, "sprites": {"front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"}}');
            res.setStatusCode(200);
        } else if (request.getEndpoint().contains('pokemon-species/')) {
            res.setBody('{"generation": {"url": "https://pokeapi.co/api/v2/generation/1/"}}');
            res.setStatusCode(200);
        }
        return res;    
    }
}