class Company < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true

end
