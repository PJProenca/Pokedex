trigger PreventDuplicates on Pokemon__c(before insert, before update) {
  Set<String> names = new Set<String>();
  for (Pokemon__c pokemon : Trigger.new) {
    names.add(pokemon.Name.toUpperCase());
  }

  List<Pokemon__c> existingPokemons = [
    SELECT Name
    FROM Pokemon__c
    WHERE Name IN :names
  ];
  Map<String, Pokemon__c> existingMap = new Map<String, Pokemon__c>();
  for (Pokemon__c existing : existingPokemons) {
    existingMap.put(existing.Name.toUpperCase(), existing);
  }

  for (Pokemon__c pokemon : Trigger.new) {
    if (
      existingMap.containsKey(pokemon.Name.toUpperCase()) &&
      (pokemon.Id == null ||
      pokemon.Id != existingMap.get(pokemon.Name.toUpperCase()).Id)
    ) {
      pokemon.Name.addError('Duplicate record found. Please check the data.');
    }
  }

}
