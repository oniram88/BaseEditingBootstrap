class Comment < ApplicationRecord
  include BaseEditingBootstrap::BaseModel
  belongs_to :commentable, polymorphic: true
end
