module Utilities
  module FormHelper
    include TemplateHelper
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
      locals = {form:, field:}
      case form.object.class.type_for_attribute(field).type
      when :datetime
        generic_field = "datetime_field"
      when :date
        generic_field = "date_field"
      when :decimal
        locals[:scale] = form.object.class.type_for_attribute(field).scale || 2
        generic_field = "decimal_field"
      when :float
        locals[:scale] = 2 # usiamo il default dato che non abbiamo questa informazione negli attributes di rails
        generic_field = "decimal_field"
      when :integer
        generic_field = "integer_field"
      else
        generic_field = "base"
      end

      template = find_template_with_fallbacks(
        form.object,
        field,
        "form_field",
        generic_field
      )
      Rails.logger.debug { "#{template}->#{ locals.inspect}" }
      render template, **locals
    end

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