class CommentPolicy < BaseModelPolicy

  def editable_attributes = %i[comment commentable_id]
  def permitted_attributes = %i[comment commentable_id]
  def search_result_fields = %i[comment commentable_id]
  def search_fields
    %i[comment_i_cont]
  end
  # TODO check if correct with search_fields
  def permitted_attributes_for_ransack
    %i[comment]
  end
end