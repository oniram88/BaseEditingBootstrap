FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title_#{n}" }
    description { "MyString" }
  end
end
