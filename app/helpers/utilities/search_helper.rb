module Utilities::SearchHelper
  ##
  # Per aggiungere bottoni:
  # ES:
  #    def search_form_buttons(ransack_form, &block)
  #       super #<-  questo serve per costruiri i bottoni definiti da super
  #       content_for(:search_form_buttons) do #<- questo serve per aggiungere al content_for un'altro bottone
  #         link_to "xls", admins_log_alarms_path(params: {q: params.permit(q:{})[:q]}, format: :xlsx), class: "btn btn-info", target: :_blank
  #       end
  #     end
  # @return [ActiveSupport::SafeBuffer]
  # @param [Ransack::Helpers::FormBuilder] ransack_form
  def search_form_buttons(ransack_form)
    content_for(:search_form_buttons) do
      ransack_form.submit(I18n.translate('.search'), class: "btn btn-primary")
    end
  end

  ##
  # Renderizza la cella della tabella nella pagina della index
  # @param [BaseModel] obj
  # @param [Symbol] field
  # @return [ActiveSupport::SafeBuffer]
  def render_cell_field(obj, field)
    case field
    when :created_at, :updated_at
      template = "base_editing/cell_field/timestamps"
      template = "#{obj.to_partial_path}/cell_field/timestamps" if lookup_context.exists?("timestamps", ["#{obj.to_partial_path}/cell_field"], true)
    else
      template = "base_editing/cell_field/base"
      template = "#{obj.to_partial_path}/cell_field/base" if lookup_context.exists?("base", ["#{obj.to_partial_path}/cell_field"], true)
      template = "#{obj.to_partial_path}/cell_field/#{field}" if lookup_context.exists?(field, ["#{obj.to_partial_path}/cell_field"], true)
    end
    render template, obj:, field:
  end

  ##
  # Renderizza header della tabella della index
  # @param [BaseModel] obj
  # @param [Symbol] field
  # @return [ActiveSupport::SafeBuffer]
  def render_header_cell_field(obj, field)
    content_tag(:th, obj.human_attribute_name(field))
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

  deprecate render_raw_field: <<-MESSAGE
Abbiamo migrato ad un sistema di rendering tramite views, 
è stato lasciato come memo per una migrazione semplificata
nel caso si voglia renderizzare un determinato campo in modo differente dal normale dato del DB
creare nalla path del modello la cartella cell_field e creare al suo interno il file con il nome
del _campo.html.erb e quindi inserire li il rendering (ES modello User, campo :name):
app/views/users/user/cell_field/_campo.html.erb
```
<%# locals: (obj:,field:)  -%>
<td><%= obj.name.upcase %></td>
```
MESSAGE

  def search_result_buttons(rec)
    btns = ActiveSupport::SafeBuffer.new

    if policy(rec).edit?
      btns << link_to(icon("pencil-square"),
                      edit_custom_polymorphic_path(rec),
                      class: "btn btn-sm btn-primary me-1")
    end

    if policy(rec).show?
      btns << link_to(icon(:eye),
                      show_custom_polymorphic_path(rec),
                      class: "btn btn-sm btn-primary me-1")
    end

    if policy(rec).destroy?
      btns << link_to(icon(:trash),
                      destroy_custom_polymorphic_path(rec),
                      data: {
                        turbo_method: :delete,
                        turbo_confirm: t("are_you_sure")
                      },
                      class: "btn btn-sm btn-danger me-1")
    end
    btns
  end

  ##
  # Possibile override dei parametri da passare a ransack nella form
  def search_form_for_params(ransack_instance)
    [ransack_instance.ransack_query]
  end
end
