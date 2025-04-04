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

    obj_base_paths = []
    # Primo livello in cui troviamo la partial path rispetto ad istanza o classe
    partial_path = (obj.respond_to? :to_partial_path) ? obj.to_partial_path : obj._to_partial_path
    obj_base_paths << "#{partial_path}/#{base_path}"

    # Cerchiamo anche tutti i livelli di inheritance del modello
    start_class = ((obj.respond_to? :to_partial_path) ? obj.class : obj).superclass

    while start_class < ApplicationRecord
      partial_path = start_class._to_partial_path
      obj_base_paths << "#{partial_path}/#{base_path}"
      start_class = start_class.superclass
    end

    [
      # Precedenza modello e campo specifico
      ["Campo SPECIFICO + inheritance tra modelli", field, obj_base_paths],
      # cerco tramite nome modello semplice, con namespace della risorsa (cell_field,header_field,form_field) e nome del campo specifico
      ["Campo specifico con nome modello + inheritance controllers", "#{obj.model_name.element}/#{base_path}/#{field}", lookup_context.prefixes],
      # cerco struttura senza il livello del nome del modello
      ["Campo specifico senza nome modello + inheritance controllers", "#{base_path}/#{field}", lookup_context.prefixes],
      # Ricerca tramite campo generico e prefissi di contesto che contiene anche controller e namespace di controller
      ["Campo GENERICO + inheritance controllers", "#{base_path}/#{generic_field}", lookup_context.prefixes],
      ["Campo GENERICO + inheritance tra modelli", generic_field, obj_base_paths],
      ["Default BaseEditingController", "base_editing/#{base_path}/#{generic_field}", []],
    ].each do |desc,partial, prefixes|
      Rails.logger.debug { "[BASE EDITING BOOTSTRAP] #{desc} - partial:`#{partial}` in #{prefixes.inspect}" }
      if lookup_context.exists?(partial, prefixes, true)
        return lookup_context.find(partial, prefixes, true)
      end
    end
    # fallback finale
    lookup_context.find("base_editing/#{base_path}/base", [], true)
  end

end
