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
    obj_base_path = "#{obj.to_partial_path}/#{base_path}"
    return "#{obj_base_path}/#{field}" if lookup_context.exists?(field, [obj_base_path], true)
    return "#{obj_base_path}/#{generic_field}" if lookup_context.exists?(generic_field, [obj_base_path], true)
    "base_editing/#{base_path}/#{generic_field}"
  end

end
