import { LightningElement, api } from "lwc";

export default class MultiSelectComboboxItem extends LightningElement {
  @api item;
  get itemClass() {
    return `slds-listbox_item ${this.item.selected ? "slds-is-selected" : ""}`;
  }

  handleClick() {
    const evt = new CustomEvent("change", {
      detail: { item: this.item, selected: !this.item.selected }
    });
    this.dispatchEvent(evt);
  }
}
