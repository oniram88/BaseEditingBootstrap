# frozen_string_literal: true

class RedPost < Post

  ##
  # Esempio di metodo per restituire un partial specifico per un campo
  def self.field_to_form_partial(field)
    if field == :title
      return :textarea
    end
    false
  end

end
