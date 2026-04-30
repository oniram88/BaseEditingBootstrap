module Utilities
  module FormHelper
    include TemplateHelper
    include EnumHelper
    include IconHelper
    include Pundit::Authorization
    include BaseEditingBootstrap::Logging
    ##
    # Metodo su cui eseguire override per i campi specifici rispetto all'oggetto gestito dal controller
    # @deprecated Utilizza form_print_field(form, field) senza sovrascriverlo
    # @param [Forms::Base] form
    # @param [Symbol] field
    def editing_form_print_field(form, field)
      form_print_field(form, field)
    end

    ##
    # Metodo per il partial corretto per restituire l'oggetto della form con le logiche per
    # trovare il template e le informazioni necessarie
    #
    # @param [Forms::Base] form
    # @param [Symbol] field
    # @param [Boolean] readonly -> rende possibile nelle nested form, nel caso arrivi da un field padre che definisce
    #                               il campo come readonly di non controllare nemmeno la policy(il padre ha priorità su figlio)
    # @return [BaseEditingBootstrap::Forms::FormFieldRenderer]
    def form_print_field_object(form, field, readonly: nil)
      field_renderer_class.new(self, form, field, readonly: readonly)
    end


    ##
    # Metodo per il partial corretto per eseguire il render del campo della form
    #
    # @param [Forms::Base] form
    # @param [Symbol] field
    # @param [Boolean] readonly -> rende possibile nelle nested form, nel caso arrivi da un field padre che definisce
    #                               il campo come readonly di non controllare nemmeno la policy(il padre ha priorità su figlio)
    # @return [ActiveSupport::SafeBuffer]
    def form_print_field(...)
      form_print_field_object(...).render
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