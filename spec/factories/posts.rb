FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title_#{n}" }
    description { 'MyString' }
    user

    trait :with_invalid_attributes do
      title { nil }
    end

    trait :with_primary_image do
      after(:create) do |post|
        file_path = ENGINE_ROOT.join('spec/file_fixtures/test_image.png')

        File.open(file_path, 'rb') do |file|
          post.primary_image.attach(io: file, filename: 'test_image.png', content_type: 'image/png')
        end
      end
    end

    trait :with_text_file do
      after(:create) do |post|
        file_path = ENGINE_ROOT.join('spec/file_fixtures/example.txt')

        File.open(file_path, 'rb') do |file|
          post.primary_image.attach(io: file, filename: 'example.txt', content_type: 'text/plain')
        end
      end
    end

    factory :customer_post, class: 'Customer::Post'
    factory :red_post, class: 'RedPost'
  end
end
