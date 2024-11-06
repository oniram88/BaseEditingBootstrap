# frozen_string_literal: true

module BaseEditingBootstrap::Forms
  class Base < ActionView::Helpers::FormBuilder
    [
      :text_field,
      :password_field,
      :text_area,
      :date_field,
      :datetime_field,
      :time_field,
      :file_field,
      :number_field
    ].each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{selector}(method, options = {})  
            super(method,
                  options.merge(class: form_style_class_for(method, options))
            )
          end                                    
      RUBY_EVAL
    end

    ##
    # Costruisce l'array delle classi che devono essere presenti sul campo della form
    #
    def form_style_class_for(method, options = {})
      classes = ["form-control"]
      classes << "is-invalid" if object.errors && object.errors.include?(method)
      classes << options[:class].split(" ") if options[:class]
      classes.flatten.compact.uniq.join(" ")
    end

    def decimal_field(field, options = {})
      number_field(field,
                   options.reverse_merge(
                     value: @template.number_with_delimiter(object[field].to_f,
                                                            separator: ".", # questo è secondo definizione html5
                                                            delimiter: ""),
                     step: :any
                   ))
    end

    def ckeditor_text_area(field, options = {})
      text_area(field, options.reverse_merge(data: {controller: "ckeditor"}))
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      html_options[:class] = "form-select #{html_options[:class]}"
      super(method, choices, options, html_options.merge(class: form_style_class_for(method, html_options)), &block)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      label = options.extract!(:label)[:label] || nil
      if label
        label_tag = label(label, class: "form-check-label")
      else
        label_tag = nil
      end
      classes = (["form-check"] + (options.extract!(:class)[:class] || "").split(" ")).join(" ")
      @template.content_tag(:div, class: classes) do
        super(method, options.reverse_merge(class: "form-check-input"), checked_value, unchecked_value) + label_tag
      end
    end

    def switch_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      options[:class] = (["form-switch"] + (options[:class] || "").split(" ")).join(" ")
      self.check_box(method, options, checked_value, unchecked_value)
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      super do |builder|
        @template.content_tag(:div, class: "form-check") do
          builder.check_box(class: "form-check-input") + builder.label(class: "form-check-label")
        end
      end
    end

    def radio_button(method, tag_value, options = {})
      @template.content_tag(:div, class: "form-check") do
        super(method, tag_value, options.reverse_merge(class: "form-check-input")) +
          label(method, class: "form-check-label")
      end
    end

    ##
    # Se necessario modificare il testo dell' "undo", basta aggiungere nelle traduzioni
    # nella solita struttura di active record l'attributo :_submit_undo,
    # per il normale submit consiglio la lettura della guida standard di rails
    # ATTENZIONE: nelle classi del bottone undo, abbiamo aggiunto .btn-undo-button
    #             che ascoltiamo dalle modal e utilizziamo per chiudere la modal, al posto
    #             seguire realmente il link con il browser.
    def submit(value = nil, options = {})
      @template.content_tag(:div, class: "btn-group mr-1") do
        super(value, options.reverse_merge(class: "btn btn-primary")) +
          @template.link_to(object.class.human_attribute_name(:_submit_undo, default: :undo),
                            @template.index_custom_polymorphic_path(object.class),
                            class: "btn btn-default btn-undo-button")
      end
    end
  end
end
