public with sharing class PokedexController_Main {
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> PokedexGetMain()
    {
        try {
            return PokedexController_Service.PokedexGetService();
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }

}