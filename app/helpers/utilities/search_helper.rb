module Utilities
  module SearchHelper
    include TemplateHelper
    include PageHelper
    include IconHelper
    include EnumHelper

    ##
    # Per aggiungere bottoni:
    # ES:
    #    def search_form_buttons(ransack_form, &block)
    #       super #<-  questo serve per costruire i bottoni definiti da super
    #       content_for(:search_form_buttons) do #<- questo serve per aggiungere al content_for un'altro bottone
    #         link_to "xls", admins_log_alarms_path(params: {q: params.permit(q:{})[:q]}, format: :xlsx), class: "btn btn-info", target: :_blank
    #       end
    #     end
    # @return [ActiveSupport::SafeBuffer]
    # @param [Ransack::Helpers::FormBuilder] ransack_form
    def search_form_buttons(ransack_form)
      content_for(:search_form_buttons) do
        ransack_form.submit(I18n.translate('.search'), class: "btn btn-primary") +
          link_to(I18n.translate('.clear_search'),
                  index_custom_polymorphic_path(ransack_form.object.klass),
                  class: "btn btn-secondary")
      end
    end

    ##
    # Renderizza la cella della tabella nella pagina della index
    # @param [BaseModel] obj
    # @param [Symbol] field
    # @return [ActiveSupport::SafeBuffer]
    def render_cell_field(obj, field)
      template = template_for_column(obj.class, field, "cell_field")
      template.render(self,{obj:, field:})
    end

    ##
    # Renderizza header della tabella della index
    # @param [BaseEditingBootstrap::Searches::Base] search_instance
    # @param [Symbol] field
    # @return [ActiveSupport::SafeBuffer]
    def render_header_cell_field(search_instance, field)
      template = template_for_column(search_instance.model_klass, field, "header_field")
      template.render(self,{obj: search_instance.model_klass, field:, search_instance: search_instance})
    end

    ##
    # Restituisce il valore che vogliamo mostrare
    def render_raw_field(obj, field)
      case field
      when :created_at, :updated_at
        l(obj.read_attribute(field), format: :long)
      else
        obj[field]
      end
    end

    ##
    # Possibile override dei parametri da passare a ransack nella form
    def search_form_for_params(ransack_instance)
      [ransack_instance.ransack_query]
    end

    private

    ##
    # Restituisce il template corretto per la tripletta, andando a ricercare il tipo di campo attraverso le informazioni
    # che type_for_attribute può restituirci
    def template_for_column(klazz, field, partial_type)
      generic_field = case field
                      when :created_at, :updated_at
                        "timestamps"
                      else
                        if klazz.respond_to?(:defined_enums) && klazz.defined_enums.key?(field.to_s)
                          type = :enum
                        else
                          type = klazz.type_for_attribute(field).type
                        end
                        case type
                        when :boolean
                          "boolean"
                        when :enum
                          "enum"
                        else
                          "base"
                        end

                      end
      find_template_with_fallbacks(
        klazz,
        field,
        partial_type,
        generic_field
      )
    end
  end
end

BaseEditingBootstrap.deprecator.deprecate_methods(Utilities::SearchHelper, render_raw_field: <<-MESSAGE
Abbiamo migrato ad un sistema di rendering tramite views, 
è stato lasciato come memo per una migrazione semplificata
nel caso si voglia renderizzare un determinato campo in modo differente dal normale dato del DB
creare nalla path del modello la cartella cell_field e creare al suo interno il file con il nome
del _campo.html.erb e quindi inserire lì il rendering (ES modello User, campo :name):
app/views/users/user/cell_field/_campo.html.erb
```
<%# locals: (obj:,field:)  -%>
<td><%= obj.name.upcase %></td>
```

Altrimenti in modo semplificato basta lanciare il generatore:
```
rails g base_editing_bootstrap:cell_override ClasseModello nome_campo
```
MESSAGE
)

BaseEditingBootstrap.deprecator.deprecate_methods(Utilities::SearchHelper, search_result_buttons: <<-MESSAGE
Come per il raw field, anche i bottoni sono stati spostati nelle viste.
Sovrascrivi la vista _search_result_buttons.html.erb
MESSAGE
)