FactoryBot.define do
  factory :comment do
    comment { "MyText" }
    commentable { create(:post) }
  end
end
