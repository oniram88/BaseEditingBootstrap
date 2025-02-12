class CommentPolicy < BaseModelPolicy

  def editable_attributes = %i[comment commentable]
  def permitted_attributes = %i[comment]
  def search_result_fields = %i[comment]

end