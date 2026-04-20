# frozen_string_literal: true

class RedPostPolicy < PostPolicy

  def attribute_is_hidden(attr)
    attr == :editable
  end

end
