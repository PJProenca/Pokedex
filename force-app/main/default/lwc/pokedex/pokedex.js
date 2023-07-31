/* eslint-disable no-unreachable */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable radix */
import { LightningElement, wire } from "lwc";
import getPokemons from "@salesforce/apex/PokedexController_Main.PokedexGetMain";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { NavigationMixin } from "lightning/navigation";
import SAD_PIKACHU from "@salesforce/resourceUrl/SadPikachu";
import ERROR_IMG from "@salesforce/resourceUrl/ErrorPsyduck";
export default class Pokedex extends NavigationMixin(LightningElement) {
  //* array of the types to map into the colortypes there are show on the html
  typeColor = [];
  spinner = true;
  errorImg = ERROR_IMG;
  sad_pikachu = SAD_PIKACHU;
  selectedGeneration = "all";
  typeOptions = [];
  selectedTypes = [];
  pokemons;
  error;
  searchTerm = "";
  numberOfPokemons = 0;
  generationOptions = [];
  genSet = new Set();

  connectedCallback() {
    this.loadPokemoms();
    this.setGenerationOptions();
  }

  loadPokemoms() {
    // this.spinner = false; //* to force the error for testing */
    // return (this.error = new Error("Network error test"));
    getPokemons()
      .then((result) => {
        this.pokemons = result.map((pokemon) => {
          const mappedTipo = pokemon.Tipo__c
            ? pokemon.Tipo__c.split(";").map((tipo) => ({
                name: tipo,
                colorType: `poke ${tipo}`
              }))
            : [];
          return {
            ...pokemon,
            tipo__c: mappedTipo,
            Geracao__c: pokemon.Geracao__c || 0
          };
        });
        this.pokemons.forEach((pokemon) => {
          this.genSet.add(pokemon.Geracao__c);
        });
        this.setGenerationOptions();
        this.numberOfPokemons = result.length;
        this.spinner = false;
      })
      .catch((error) => {
        this.spinner = false;
        this.error = error;
      });
  }

  //* To set the options to be displayed on the generation picklist. the sort is for the case there is a manual insert
  //*  the list will be allways ordered asc.
  setGenerationOptions() {
    this.generationOptions = [{ label: "All", value: "all" }];
    const genSorted = Array.from(this.genSet).sort((a, b) => a - b);
    genSorted.forEach((generation) => {
      this.generationOptions.push({
        label: `Generation ${generation}`,
        value: `${generation}`
      });
    });
  }

  //** get objectInfo to get the picklist values of the types to set on the typeOptions and on the typeColor
  @wire(getObjectInfo, { objectApiName: "Pokemon__c" })
  objectInfo;

  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: "Pokemon__c.Tipo__c"
  })
  loadTypeOptions({ data, error }) {
    if (data) {
      this.typeOptions = data.values
        .map((picklistValue) => ({
          label: picklistValue.label,
          value: picklistValue.value
        }))
        .sort((a, b) => a.label.localeCompare(b.label));
      this.typeColor = data.values.map((picklistValue) => picklistValue.label);
    } else if (error) {
      console.error("Error retrieving picklist values:", error);
    }
  }
  //* filter the pokemons by specified criteria
  get pokemonsFilter() {
    if (
      this.selectedGeneration === "all" &&
      this.selectedTypes.length === 0 &&
      this.searchTerm === ""
    ) {
      return this.pokemons;
    }
    return this.pokemons.filter((pokemon) => {
      const generationMatch =
        this.selectedGeneration === "all" ||
        pokemon.Geracao__c === parseInt(this.selectedGeneration);
      const searchTermMatch =
        this.searchTerm === "" ||
        pokemon.Name.toLowerCase().includes(this.searchTerm.toLowerCase());
      const typeMatch =
        this.selectedTypes.length === 0 ||
        this.selectedTypes.every((type) => pokemon.Tipo__c.includes(type));
      return generationMatch && searchTermMatch && typeMatch;
    });
  }

  //*  update the number o pokemons there are shown when applied the filter
  updateNumberOfPokemons() {
    this.numberOfPokemons = Object.keys(this.pokemonsFilter).length;
  }

  handleSearchChange(event) {
    window.clearTimeout(this.delayTimeout);
    const searchTerm = event.target.value;
    this.delayTimeout = setTimeout(() => {
      this.searchTerm = searchTerm;
      this.updateNumberOfPokemons();
    }, 300);
  }

  handleGenerationChange(event) {
    this.selectedGeneration = event.target.value;
    this.updateNumberOfPokemons();
  }

  handleTypeChange(event) {
    this.selectedTypes = event.detail.map((item) => item.value);
    this.updateNumberOfPokemons();
  }

  //* handle the navigation when click on img
  handleNavigationChange(event) {
    const pokemonId = event.detail;
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: pokemonId,
        objectApiName: "Pokemon__c",
        actionName: "view"
      }
    });
  }
  //* check if there are pokemons to displayed so it can show an error message
  get existsPokemons() {
    const exists = this.pokemonsFilter;
    return exists && exists.length > 0;
  }
}
