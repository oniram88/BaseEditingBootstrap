class Post < ApplicationRecord
  include BaseEditingBootstrap::BaseModel
  validates :title, presence: true
end
