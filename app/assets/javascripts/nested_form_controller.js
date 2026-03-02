import NestedForm from "@stimulus-components/rails-nested-form"

// Connects to data-controller="nested-form"
export default class extends NestedForm {

  static values = {
    limit: Number,
  }

  add(e) {
    super.add(e);
    this.check_for_enabling_add_button(e);
  }

  remove(e) {
    super.remove(e);
    this.check_for_enabling_add_button(e);
  }

  // Elenco elementi presenti visibili (e quindi non settati per essere cancellati)
  total_active_elements() {
    let count = 0;

    this.targetTarget.parentElement.querySelectorAll(this.wrapperSelectorValue).forEach((ele) => {
      if (ele.checkVisibility()) {
        count += 1;
      }
    })
    return count;
  }

  check_for_enabling_add_button(e) {
    if (this.hasLimitValue) {
      if (this.total_active_elements() >= this.limitValue) {
        // Aggiungiamo classe disable sull'elemento che ha lanciato questo evento
        this.add_button().disabled = "disabled";
      } else {
        this.add_button().removeAttribute("disabled");
      }
    }
  }

  add_button() {
    return this.element.querySelector('[data-action="nested-form#add"]')
  }


}