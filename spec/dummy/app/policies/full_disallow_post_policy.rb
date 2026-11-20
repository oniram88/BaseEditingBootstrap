# frozen_string_literal: true

# Policy per testare shared examples di pundit
class FullDisallowPostPolicy < PostPolicy

  private
  def general_rule
    false
  end

end
