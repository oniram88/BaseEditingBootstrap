FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title_#{n}" }
    description { "MyString" }

    trait :with_invalid_attributes do
      title { nil }
    end

    trait :with_primary_image do
      primary_image {
        Rack::Test::UploadedFile.new(
          ENGINE_ROOT.join("spec/file_fixtures/test_image.png"),
        )
      }
    end

    trait :with_text_file do
      primary_image {
        Rack::Test::UploadedFile.new(
          ENGINE_ROOT.join("spec/file_fixtures/example.txt"),
        )
      }
    end

    factory :customer_post, class: "Customer::Post"

  end
end
