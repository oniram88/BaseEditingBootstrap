class Company < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank

  has_one :comment, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comment, reject_if: :all_blank

  validates :name, presence: true

  validate -> {
    # Test max number of addresses to raise error in form and check nested attributes rendering
    if self.addresses.reject(&:marked_for_destruction?).size > 2
      self.errors.add(:addresses, "TOO MANY ADDRESSES")
      self.errors.add(:addresses, "Other Error") # to simulate joined error
    end
  }

end
