class UserPolicy < BaseModelPolicy

  def editable_attributes
    [:username, :roles, :enabled]
  end

  def permitted_attributes
    [:username, :enabled, role_ids: []]
  end

  def search_result_fields
    [:username]
  end

  def permitted_associations_for_ransack = [:posts]

  def permitted_attributes_for_ransack = [:username]

end
