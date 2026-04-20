module Utilities
  # Responsible for deciding which template and locals to use for form fields
  # Usage: Utilities::FormFieldRenderer.new(view_context, form, field, readonly:).render
  class FormFieldRenderer
    attr_reader :view, :form, :field, :locals, :type, :generic_field

    def initialize(view, form, field, readonly: nil)
      @view = view
      @form = form
      @field = field
      @readonly = readonly
      @locals = { form: form, field: field }
      @type = nil
      @generic_field = nil
      determine_field_and_locals
    end

    # Perform full rendering and return SafeBuffer
    def render
      tmpl = template
      view.bs_logger.debug do
        <<~TEXT
          TYPE: #{type}
          GENERIC_FIELD: #{generic_field}
          TEMPLATE: #{tmpl.short_identifier}
          LOCALS:#{locals}
        TEXT
      end
      tmpl.render(view, locals)
    end

    # Public helpers for tests or external callers
    def template
      view.find_template_with_fallbacks(
        form.object,
        field,
        "form_field",
        generic_field,
        readonly: readonly_value
      )
    end

    def readonly_value
      @readonly.nil? ? view.readonly_attribute?(field, form.object) : @readonly
    end

    private

    def determine_field_and_locals
      if form.object.class.respond_to?(:field_to_form_partial) &&
         (generic = form.object.class.field_to_form_partial(field)
         )
        @type = :custom
        @generic_field = generic
      elsif form.object.class.respond_to?(:defined_enums) && form.object.class.defined_enums.key?(field.to_s)
        @type = :enum
        @generic_field = "enum"
      elsif belongs_to_reflection?
        reflection = form.object.class.reflect_on_association(field.to_s)
        @type = :belongs_to
        @generic_field = "belongs_to_select"
        locals[:relation_class] = reflection.klass
        locals[:foreign_key] = reflection.foreign_key
      elsif nested_attributes?
        @type = :nested_attributes
        reflection = form.object.class.reflect_on_association(field.to_s)
        case reflection
        when ActiveRecord::Reflection::HasManyReflection
          locals[:new_object] = reflection.klass.new(reflection.foreign_key => form.object)
          @generic_field = "accept_has_many_nested_field"
        when ActiveRecord::Reflection::HasOneReflection
          form.object.send(:"build_#{field}") unless form.object.send(field).present?
          @generic_field = "accept_has_one_nested_field"
        else
          raise "Unknown reflection for nested attributes #{field}->#{reflection.class}"
        end
      else
        determine_by_attribute_type
      end
    end

    def belongs_to_reflection?
      form.object.class.respond_to?(:reflect_on_association) &&
        (ref = form.object.class.reflect_on_association(field.to_s)).is_a?(ActiveRecord::Reflection::BelongsToReflection) &&
        !ref.polymorphic?
    end

    def nested_attributes?
      form.object.class.respond_to?(:nested_attributes_options) &&
        form.object.class.nested_attributes_options.key?(field.to_sym)
    end

    def determine_by_attribute_type
      if form.object.class.respond_to?(:type_for_attribute)
        @type = form.object.class.type_for_attribute(field).type

        # If nil, check for single attachment
        if @type.nil? && form.object.respond_to?(:"#{field}_attachment")
          @type = :has_one_attachment
        end
      else
        @type = :string
      end

      case type
      when :datetime
        @generic_field = "datetime"
      when :date
        @generic_field = "date"
      when :decimal
        locals[:scale] = form.object.class.type_for_attribute(field).scale || 2
        @generic_field = "decimal"
      when :float
        locals[:scale] = 2
        @generic_field = "decimal"
      when :integer
        @generic_field = "integer"
      when :boolean
        @generic_field = "boolean"
      when :has_one_attachment
        @generic_field = "has_one_attachment"
      when :text
        @generic_field = "textarea"
      else
        @generic_field = "base"
      end
    end
  end
end
