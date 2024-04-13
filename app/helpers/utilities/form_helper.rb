module Utilities::FormHelper
  ##
  # Metodo su cui eseguire override per i campi specifici rispetto all'oggetto gestito dal controller
  # @deprecated Utilizza form_print_field(form, field) senza sovrascriverlo
  # @param [Forms::Base] form
  # @param [Symbol] field
  def editing_form_print_field(form, field)
    form_print_field(form, field)
  end

  ##
  # Metodo per il partial corretto per eseguire il render del campo della form
  #
  # @param [Forms::Base] form
  # @param [Symbol] field
  def form_print_field(form, field)
    case field
    when :created_at, :updated_at
      template = "base_editing/form_field/timestamps"
      template = "#{form.object.to_partial_path}/form_field/timestamps" if lookup_context.exists?("timestamps", ["#{form.object.to_partial_path}/form_field"], true)
    else
      template = "base_editing/form_field/base"
      template = "#{form.object.to_partial_path}/form_field/base" if lookup_context.exists?("base", ["#{form.object.to_partial_path}/form_field"], true)
      template = "#{form.object.to_partial_path}/form_field/#{field}" if lookup_context.exists?(field, ["#{form.object.to_partial_path}/form_field"], true)
    end
    render template, form:, field:
  end

end

BaseEditingBootstrap.deprecator.deprecate_methods(Utilities::FormHelper, editing_form_print_field: <<-MESSAGE

        Non vogliamo utilizzare più il sistema degli helpers ma direttamente le view,
        creare nella cartella del relativo modello la struttura di cartelle derivato
        dal to_partial_path chiamato sull'oggetto del modello che stiamo generando
        `nome_modello_plurale/nome_modello_singolare/form_field/_nomeField.html.erb`
        a cui vengono passati i parametri form e field

        <\%\# \locals: (form:, field:) -%\>
        <\%\= form.check_box(:field_name, class: "form-control") \%\>
MESSAGE
)