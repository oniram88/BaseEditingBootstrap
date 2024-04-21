class Post < ApplicationRecord
  include BaseEditingBootstrap::BaseModel
  validates :title, presence: true

  enum :category, {
    news: "news",
    project: "project",
    other: "other"
  }
end
