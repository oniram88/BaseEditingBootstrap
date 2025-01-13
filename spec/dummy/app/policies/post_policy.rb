class PostPolicy < BaseModelPolicy

  def editable_attributes
    [
      :title,
      :description,
      :category,
      :priority,
      :published_at,
      :primary_image
    ]
  end

  def permitted_attributes
    [
      :title,
      :description,
      :category,
      :priority,
      :published_at,
      :primary_image
    ]
  end

  def search_result_fields
    [:title, :category, :description, :created_at,]
  end

  def sortable_search_result_fields
    [:title, :category]
  end

  def search_fields
    [:title_i_cont]
  end
end
