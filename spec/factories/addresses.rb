FactoryBot.define do
  factory :address do
    company
    street { Faker::Address.street_address }
    cap { Faker::Address.zip_code }
    city { Faker::Address.city }
  end
end
