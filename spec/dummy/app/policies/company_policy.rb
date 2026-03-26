class CompanyPolicy < BaseModelPolicy

  def permitted_attributes
    [
      :name,
      :editable,
      addresses_attributes: AddressPolicy.new(user, Address.new).permitted_attributes + [:_destroy, :id],
      shipping_addresses_attributes: AddressPolicy.new(user, Address.new).permitted_attributes + [:_destroy, :id],
      comment_attributes: CommentPolicy.new(user, Comment.new).permitted_attributes
    ]
  end

  def editable_attributes = %i[name editable addresses shipping_addresses comment]

  def attribute_is_readonly(attribute)
    if record.editable?
      # Editabili tutti gli attributi, quindi l'attributo passato NON è editable
      false
    else
      # Tutti i campi diversi da editable sono readonly
      attribute != :editable
    end
  end


  def search_result_fields = %i[name]

end