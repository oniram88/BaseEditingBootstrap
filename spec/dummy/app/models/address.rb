class Address < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  belongs_to :company

  validates :street, presence: true

end
