class User < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  has_many :posts
end
