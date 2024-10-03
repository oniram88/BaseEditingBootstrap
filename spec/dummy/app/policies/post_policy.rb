class PostPolicy < BaseModelPolicy

  def editable_attributes
    [
      :title,
      :description,
      :category,
      :priority,
      :published_at
    ]
  end

  def permitted_attributes
    [
      :title,
      :description,
      :category,
      :priority,
      :published_at
    ]
  end

  def search_result_fields
    [:title]
  end

  def search_fields
    [:title_i_cont]
  end
end
