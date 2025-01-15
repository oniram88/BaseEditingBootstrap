class User < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :posts
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users

  def option_label_method
    self.username
  end

end
