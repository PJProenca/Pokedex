/* eslint-disable guard-for-in */
/* eslint-disable vars-on-top */
import { LightningElement, api, wire, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import getStats from "@salesforce/apex/PokemonStatsAPICall.getStats";
import STATS_BG from "@salesforce/resourceUrl/statsBG";
export default class PokemonStats extends LightningElement {
  @api recordId;
  @track pokemon;
  @track pokemonName;
  error;
  @track imgUrl;
  @track pokeMap = [];
  stats_BG = STATS_BG;
  @wire(getRecord, {
    recordId: "$recordId",
    fields: ["Pokemon__c.Name", "Pokemon__c.Foto_URL__c"]
  })
  wiredPokemon({ data, error }) {
    if (data) {
      this.pokemon = data;
      this.pokemonName = this.pokemon.fields.Name.value.toLowerCase();
      this.imgUrl = this.pokemon.fields.Foto_URL__c.value;
      this.error = undefined;
    } else if (error) {
      this.pokemon = undefined;
      this.error = error;
    }
  }

  @wire(getStats, { pokemon: "$pokemonName" })
  wiredStats(result) {
    if (result.data) {
      let val = result.data;
      for (let key in val) {
        this.pokeMap.push({ value: val[key], key: key });
      }
    }
  }

  get exists() {
    return this.pokeMap.length > 0;
  }

  get getStatsBG() {
    return `background-image:url("${this.stats_BG}")`;
  }
}
