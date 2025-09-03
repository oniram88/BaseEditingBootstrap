class AddressPolicy < BaseModelPolicy

  def permitted_attributes
    [
        :street,
        :cap,
        :city,
    ]
  end

  def editable_attributes
    [
        :street,
        :cap,
        :city,
    ]
  end

  def search_result_fields
    [
        :street,
        :cap,
        :city,
    ]
  end


end