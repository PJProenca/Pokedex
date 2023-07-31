public with sharing class PokedexController_Service 
{
    public static List<Pokemon__c> PokedexGetService()
    {
        return PokedexController_Selector.getPokemons();
    }


}