class PostPolicy < BaseModelPolicy

  def editable_attributes
    [
      :title,
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
end
