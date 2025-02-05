class User < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :posts
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users

  # Campi virtuali per simulare visualizzare validazione nelle form
  attribute :only_true_boolean, :boolean, default: true
  validates :only_true_boolean, inclusion: {in: [true]}
  attribute :only_false_virtual, :boolean, default: false
  validates :only_false_virtual, inclusion: {in: [false]}


  def option_label
    self.username
  end

end
