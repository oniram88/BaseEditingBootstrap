module Utilities
  module FormHelper
    include TemplateHelper
    include EnumHelper
    include IconHelper
    include Pundit::Authorization
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
      if form.object.class.respond_to?(:defined_enums) && form.object.class.defined_enums.key?(field.to_s)
        type = :enum
        generic_field = "enum"
      elsif form.object.class.respond_to?(:reflect_on_association) &&
        form.object.class.reflect_on_association(field.to_s).is_a?(ActiveRecord::Reflection::BelongsToReflection) &&
        !form.object.class.reflect_on_association(field.to_s).polymorphic? # non deve essere polymorphic
        # Abbiamo una relazione belongs_to da gestire
        reflection = form.object.class.reflect_on_association(field.to_s)
        type = :belongs_to
        generic_field = "belongs_to_select"
        locals[:relation_class] = reflection.klass
        locals[:foreign_key] = reflection.foreign_key
      else
        if form.object.class.respond_to?(:type_for_attribute)
          type = form.object.class.type_for_attribute(field).type

          # Se non abbiamo ancora il type tentiamo di capire se è di tipo attachment SINGOLO
          if type.nil? and form.object.respond_to?(:"#{field}_attachment")
            type = :has_one_attachment
          end
        else
          type = :string
        end

        case type
        when :datetime
          generic_field = "datetime"
        when :date
          generic_field = "date"
        when :decimal
          locals[:scale] = form.object.class.type_for_attribute(field).scale || 2
          generic_field = "decimal"
        when :float
          locals[:scale] = 2 # usiamo il default dato che non abbiamo questa informazione negli attributes di rails
          generic_field = "decimal"
        when :integer
          generic_field = "integer"
        when :boolean
          generic_field = "boolean"
        when :has_one_attachment
          generic_field = "has_one_attachment"
        else
          generic_field = "base"
        end
      end

      template = find_template_with_fallbacks(
        form.object,
        field,
        "form_field",
        generic_field
      )
      Rails.logger.debug do
        <<~TEXT
          [BASE EDITING BOOTSTRAP]
           TYPE: #{type}
           GENERIC_FIELD: #{generic_field}
           TEMPLATE: #{template.short_identifier}
           LOCALS:#{locals}
        TEXT
      end
      template.render(self, locals)
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