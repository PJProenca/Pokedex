@isTest
public with sharing class PokmenonBatchTest {
  @isTest
    static void testPokemonbatch() 
    {
        PokemonBatchMock mock = new PokemonBatchMock();
        PopulatePokemonBatch batch = new PopulatePokemonBatch();
        Test.setMock(HttpCalloutMock.class, mock);
        List<String> testData = new List<String>{
        'bulbasaur',
        'ivysaur',
        'venusaur',
        'charmander',
        'charmeleon',
        'charizard',
        'squirtle',
        'wartortle',
        'blastoise',
        'caterpie'
        };

        Test.startTest();
        Iterable<String> scope = batch.start(null);
        batch.execute(null, testData);
        Test.stopTest();
        List<Pokemon__c> pokemonList = [
        SELECT Name, Peso__c, Altura__c, Tipo__c, Geracao__c, Foto_URL__c
        FROM Pokemon__c];
        System.assertEquals(10, pokemonList.size());
    }
}
