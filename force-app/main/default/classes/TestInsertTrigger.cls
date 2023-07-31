@istest
private class TestInsertTrigger {
  @isTest
  static void PokemonInsertTriggerTest() {
    Pokemon__c pokemon1 = new Pokemon__c(Name = 'Pikachu');
    insert pokemon1;
    Pokemon__c pokemon2 = new Pokemon__c(Name = 'pikachu');
    Test.startTest();
    Database.SaveResult insertResult = Database.insert(pokemon2, false);
    Test.stopTest();
    //* Check results */
    System.assert(!insertResult.isSuccess());
    System.assert(insertResult.getErrors().size() > 0);
    system.assertEquals(
      'Duplicate record found. Please check the data.',
      insertResult.getErrors()[0].getMessage()
    );
  }
}
