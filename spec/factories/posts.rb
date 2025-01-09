FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title_#{n}" }
    description { "MyString" }

    trait :with_invalid_attributes do
      title { nil }
    end

    factory :customer_post, class: "Customer::Post"

  end
end
