class CompanyPolicy < BaseModelPolicy

  def permitted_attributes
    [
      :name,
      addresses_attributes: AddressPolicy.new(user, Address.new).permitted_attributes + [:_destroy,:id]
    ]
  end

  def editable_attributes = %i[name addresses]

  def search_result_fields = %i[name]

end