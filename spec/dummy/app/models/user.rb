class User < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :posts
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users
end
