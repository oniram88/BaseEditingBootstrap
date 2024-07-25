module Customer
  class Post < Post
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


    def this_is_special_method_for_customer_post
      "this_is_special_method_for_customer_post"
    end
  end
end
