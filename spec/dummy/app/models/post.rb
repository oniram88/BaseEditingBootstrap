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

  has_one_attached :primary_image
  belongs_to :user

  delegate :username, to: :user, prefix: true


  def custom_virtual_attribute
    "content from virtual attribute"
  end

end
