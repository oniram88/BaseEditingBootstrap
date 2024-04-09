module Utilities::PageHelper
  # @param [BaseModel] base_class
  def title_mod_g(base_class)
    "#{t("edit")} #{base_class.model_name.human}"
  end

  # @param [BaseModel] base_class
  def title_new_g(base_class)
    "#{t("new")} #{base_class.model_name.human}"
  end

  # Quando e se servirà verrà testato:
  # - form_field dovrebbe essere il campo del modello che ha associato il has_one_attached
  # def link_download(form_field)
  #   link_to rails_blob_path(form_field, disposition: 'attachment'), class: "btn btn-primary", style: "margin:5px;" do
  #     icon("fas", "eye") + content_tag(:span, " #{I18n.t('download')} #{form_field.filename.to_s}")
  #   end
  # end
  #
  # def link_delete(form_field, delete_link)
  #   link_to delete_link, data: {turbo_method: :delete, turbo_confirm: t('are_you_sure')},
  #           class: "btn btn-danger", style: "margin:5px;" do
  #     icon("fas", "times") + content_tag(:span, " #{I18n.t('delete')} #{form_field.filename.to_s}")
  #   end
  # end

  # @param [TrueClass, FalseClass] valore
  def boolean_to_icon(valore)
    if valore
      icon("fas", "check", class: "text-success")
    else
      icon("fas", "x", class: "text-danger")
    end
  end

  # @param [String] path
  # @param [Hash] options
  def new_button(path, options = {})
    options.merge!({class: 'btn btn-success btn-sm'})
    link_to icon("fas", "plus", I18n.t(:new)), path, options
  end

  # @param [BaseModel] obj instance
  # @param [Symbol] field
  def error_messages_for(obj, field)
    if obj.errors.include?(field)
      msg = obj.errors.full_messages_for(field).join(",")
      content_tag(:div, icon("fas", "times-circle", msg), class: "invalid-feedback")
    end
  end
end
