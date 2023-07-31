@isTest
public with sharing class PokemonStatsCallTest {
  @isTest
  static void testStatsCall() {
    PokemonStatsCallMock mock = new PokemonStatsCallMock();
    Test.setMock(HttpCalloutMock.class, mock);
    PokemonStatsAPICall statsCall = new PokemonStatsAPICall();
    Map<String, Integer> statsMap = PokemonStatsAPICall.getStats('pikachu');

    System.assertEquals(2, statsMap.size());
    System.assertEquals(70, statsMap.get('speed'));
    System.assertEquals(90, statsMap.get('attack'));
  }
}
