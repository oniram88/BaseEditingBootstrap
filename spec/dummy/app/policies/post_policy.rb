class PostPolicy < BaseModelPolicy

  def editable_attributes
    [
      :title,
      :editable,
      :description,
      :user,
      :primary_image,
      :category,
      :priority,
      :published_at,
    ]
  end

  def permitted_attributes
    [
      :title,
      :editable,
      :description,
      :user_id,
      :primary_image,
      :category,
      :priority,
      :published_at,
    ]
  end

  def search_result_fields
    [:title, :category, :description, :created_at, :user_username]
  end

  def sortable_search_result_fields
    [:title, :category, :user_username]
  end

  def permitted_associations_for_ransack
    [:user]
  end

  def permitted_scopes_for_ransack
    [:test_scoped_ransack]
  end

  def search_fields
    [:title_i_cont]
  end

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
