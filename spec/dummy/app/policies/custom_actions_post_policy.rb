# frozen_string_literal: true

# Policy per testare shared examples di pundit
class CustomActionsPostPolicy < PostPolicy

  def custom_action_one?
    true
  end
  def custom_action_second?
    false
  end

end
