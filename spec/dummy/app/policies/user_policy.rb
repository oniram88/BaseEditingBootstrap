class UserPolicy < BaseModelPolicy

  def editable_attributes
    [:username]
  end

  def permitted_attributes
    [:username]
  end

  def search_result_fields
    [:username]
  end
end
