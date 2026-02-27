class CompanyPolicy < BaseModelPolicy

  def permitted_attributes
    [
      :name,
      addresses_attributes: AddressPolicy.new(user, Address.new).permitted_attributes + [:_destroy, :id],
      shipping_addresses_attributes: AddressPolicy.new(user, Address.new).permitted_attributes + [:_destroy, :id],
      comment_attributes: CommentPolicy.new(user, Comment.new).permitted_attributes
    ]
  end

  def editable_attributes = %i[name addresses shipping_addresses comment]

  def search_result_fields = %i[name]

end