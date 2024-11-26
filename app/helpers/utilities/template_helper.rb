# frozen_string_literal: true

module Utilities::TemplateHelper

  ##
  # Ricerca template con fallbacks.
  # In ordine, cerca di trovare il partial per l'oggetto(tramite il metodo to_partial_path) e il campo specifico.
  # In successione cerca poi per il partial con nome relativo al tipo di dato
  # sempre nella cartella dell'oggetto
  # ed infine nella cerca nella cartella del base editing
  # @param [Object#to_partial_path] obj
  # @param [Symbol] field
  # @param [String] base_path
  # @param [String] generic_field
  def find_template_with_fallbacks(obj, field, base_path, generic_field)
    # nei casi in cui passiamo la classe e non l'oggetto, dobbiamo utilizzare un metodo interno a rails per
    # avere la partial_path
    partial_path = (obj.respond_to? :to_partial_path) ? obj.to_partial_path : obj._to_partial_path
    obj_base_path = "#{partial_path}/#{base_path}"
    return "#{obj_base_path}/#{field}" if lookup_context.exists?(field, [obj_base_path], true)
    return "#{obj_base_path}/#{generic_field}" if lookup_context.exists?(generic_field, [obj_base_path], true)
    return "base_editing/#{base_path}/#{generic_field}" if lookup_context.find_all("base_editing/#{base_path}/_#{generic_field}").any?
    "base_editing/#{base_path}/base"
  end

end
