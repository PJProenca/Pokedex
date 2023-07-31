@isTest
public with sharing class PokemonStatsCallMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"stats":[{"stat":{"name":"speed"},"base_stat":70},{"stat":{"name":"attack"},"base_stat":90}]}');
        res.setStatusCode(200);
        return res;
    }
}