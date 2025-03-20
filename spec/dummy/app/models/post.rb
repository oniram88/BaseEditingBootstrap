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
  validates :user_id, presence: true

  ##
  # Simulo un errore per il base, per poterlo vedere nella form
  validate ->{
    if self.title == "BASE ERROR"
      self.errors.add(:base,"SIMULATE BASE ERROR")
    end
  }

  scope :test_scoped_ransack, ->(category) { where(category: category) }

  def custom_virtual_attribute
    "content from virtual attribute"
  end

end
