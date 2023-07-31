public with sharing class PokemonStatsAPICall {
    @AuraEnabled(cacheable=true)
    public static Map<String,Integer> getStats(String pokemon)
    {
        List<Map<String,Integer>> statsList = new List<Map<String,Integer>>(); 
        Map<String,Integer> statsMap = new Map<String,Integer>();
        Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+pokemon);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200)
        {
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> stats = (List<Object>) responseData.get('stats');
            for(Object stat : stats )
            {
                Map<String,Object> statData = (Map<String,Object>) stat;
                Map<String,Object> statName = (Map<String,Object>) statData.get('stat');
                String name = (String) statName.get('name');
                Integer statValue = (Integer) statData.get('base_stat');
                statsMap.put(name,statValue);
              
            }
            statsList.add(statsMap); 
        }
        return statsMap;
    } 
}