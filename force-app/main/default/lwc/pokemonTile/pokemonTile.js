import { LightningElement, api } from "lwc";

export default class PokemonTile extends LightningElement {
  @api pokemon;

  get getColorByGeneration() {
    const generation = this.pokemon && this.pokemon.Geracao__c;
    // return `gen_color_${generation}`;
    return `pokemon-gen-color gen${generation}`;
  }

  handleOpenRecordOnClick() {
    const selectEvent = new CustomEvent("pokemonview", {
      detail: this.pokemon.Id
    });
    this.dispatchEvent(selectEvent);
  }
}
