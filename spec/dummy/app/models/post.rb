class Post < ApplicationRecord
  include BaseEditingBootstrap::BaseModel
  validates :title, presence: true

  enum :category, {
    news: "news",
    project: "project",
    other: "other"
  }

  enum :priority, {
    normal: 0,
    low: 1,
    urgent: 2
  }, default: :normal, prefix: true
end
