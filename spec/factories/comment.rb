FactoryBot.define do
  factory :comment do
    commentable { create(:user) }
  end
end