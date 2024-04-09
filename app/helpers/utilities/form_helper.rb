module Utilities::FormHelper
  ##
  # Metodo su cui eseguire override per i campi specifici rispetto all'oggetto gestito dal controller
  #
  # @param [Forms::Base] form
  # @param [Symbol] field
  def editing_form_print_field(form, field)
    form.text_field(field, class: "form-control")
  end
  
end
