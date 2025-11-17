module Utilities::PageHelper
  include Utilities::IconHelper

  ##
  # Traduzione del titolo EDIT con possibilità di modificare intestazione rispetto a modello
  # - Il default è quello di Utilizzare la chiave .edit
  # - Viene cercato la traduzione con la chiave titles.CHIAVE_I18N_MODELLO.edit
  # @param [BaseModel] base_class
  def title_mod_g(base_class)
    "#{t("titles.#{base_class.model_name.i18n_key}.edit", default: :edit)} #{base_class.model_name.human}"
  end

  ##
  # Traduzione del titolo NUOVO con possibilità di modificare intestazione rispetto a modello
  # - Il default è quello di Utilizzare la chiave .new
  # - Viene cercato la traduzione con la chiave titles.CHIAVE_I18N_MODELLO.new
  # @param [BaseModel] base_class
  def title_new_g(base_class)
    "#{t("titles.#{base_class.model_name.i18n_key}.new", default: :new)} #{base_class.model_name.human}"
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

  # @param [TrueClass, FalseClass, NilClass] valore
  def boolean_to_icon(valore)
    case valore
    when true
      icon("check-lg", class: "text-success")
    when false
      icon("x-lg", class: "text-danger")
    else
      nil
    end
  end

  # @param [String] path
  # @param [Hash] options
  def new_button(path, options = {})
    link_to icon("plus-lg", I18n.t(:new)), path, options.reverse_merge({class: 'btn btn-success btn-sm'})
  end

  # @param [BaseModel] obj instance
  # @param [Symbol] field
  def error_messages_for(obj, field)
    if obj.errors.include?(field)
      msg = obj.errors.full_messages_for(field).join(",")
      content_tag(:div, icon("x-circle-fill", msg), class: "invalid-feedback")
    end
  end
end
