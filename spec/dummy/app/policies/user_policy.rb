class UserPolicy < BaseModelPolicy

  def editable_attributes
    [
      :username,
      :roles,
      :enabled,
      :editable,
      :only_true_boolean,
      :only_false_virtual
    ]
  end

  def permitted_attributes
    [
      :username,
      :enabled,
      :editable,
      :only_true_boolean,
      :only_false_virtual,
      role_ids: []
    ]
  end

  def search_result_fields
    [:username, :enabled]
  end

  def search_fields
    [:username_i_cont]
  end

  def permitted_associations_for_ransack = [:posts]

  def permitted_attributes_for_ransack = [:username]

  def attribute_is_readonly?(attribute)
    if record.editable?
      # Editabili tutti gli attributi, quindi l'attributo passato NON è editable
      false
    else
      # Tutti i campi diversi da editable sono readonly
      attribute != :editable
    end
  end

end
