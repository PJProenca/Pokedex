public with sharing class PokedexController_Selector {

    public static List<Pokemon__c> getPokemons()
    {
        return [SELECT Id,Name,Altura__c,Foto_URL__c,Geracao__c,
                Peso__c,PokeIndex__c,Tipo__c FROM Pokemon__c ORDER BY PokeIndex__c ASC];
    }

}