class UserPolicy < BaseModelPolicy

  def editable_attributes
    [:username, :roles]
  end

  def permitted_attributes
    [:username]
  end

  def search_result_fields
    [:username]
  end

  def permitted_associations_for_ransack = [:posts]

  def permitted_attributes_for_ransack = [:username]

end
