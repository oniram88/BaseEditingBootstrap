class Role < ApplicationRecord
  has_many :role_users,dependent: :destroy
end
